*&---------------------------------------------------------------------*
*& Report ZZBXT05ADS_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzbxt05ads_003.

data: lt_items type ty_flights,
      lt_data  type ty_flights.

""PDF 변수
data: gv_fmname         type rs38l_fnam,
      gs_fpdocparams    type sfpdocparams,
      gs_fpoutputparams type sfpoutputparams,
      gs_fpformoutput   type fpformoutput,
      go_pdf            type ref to cl_rspo_pdf_merge.

parameters p_carrid type scarr-carrid default `AA`.

initialization.
  go_pdf = new #( ).

start-of-selection.

  select from sflight
    fields *
    where carrid eq @p_carrid
    into corresponding fields of table @lt_items.


*  cl_demo_output=>write_data( ls_header ).
*  cl_demo_output=>write_data( lt_items ).
*
*  cl_demo_output=>display( ).


  "Call PDF.

  "Call ADS Form.

  gs_fpoutputparams-dest = 'LP01'.
  gs_fpoutputparams-preview = 'X'.
*  gs_fpoutputparams-nodialog = abap_true.
  gs_fpoutputparams-getpdf   = 'M'."M 값을 지정해야 리턴값이 부여됨
  gs_fpoutputparams-assemble = 'M'.""M 값을 지정해야 리턴값이 부여됨
  gs_fpoutputparams-bumode   = 'M'.

  call function 'FP_JOB_OPEN'
    changing
      ie_outputparams = gs_fpoutputparams
    exceptions
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      others          = 5.

  call function 'FP_FUNCTION_MODULE_NAME'
    exporting
      i_name     = `ZZZZTEST0003_PAIR`  "Adobe Form Name.
    importing
      e_funcname = gv_fmname.

  gs_fpdocparams-langu = sy-langu.

  data lv_index type i.

  loop at lt_items into data(ls_items).


    add 1 to lv_index.

    append initial line to lt_data assigning field-symbol(<fs_data>).

    <fs_data> = corresponding #( ls_items ).


    if lv_index mod 6 eq 0.

      call function gv_fmname
        exporting
          /1bcdwb/docparams  = gs_fpdocparams
          lt_items           = lt_data
        importing
          /1bcdwb/formoutput = gs_fpformoutput
        exceptions
          usage_error        = 1
          system_error       = 2
          internal_error     = 3.
      if sy-subrc = 0.

        clear lt_data.

        go_pdf->add_document( gs_fpformoutput-pdf ).

      else.
        message id sy-msgid type sy-msgty number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      endif.


    endif.


  endloop.

  if lt_data is not initial.

    call function gv_fmname
      exporting
        /1bcdwb/docparams  = gs_fpdocparams
        lt_items           = lt_data
      importing
        /1bcdwb/formoutput = gs_fpformoutput
      exceptions
        usage_error        = 1
        system_error       = 2
        internal_error     = 3.
    if sy-subrc = 0.

      clear lt_data.

      go_pdf->add_document( gs_fpformoutput-pdf ).

    else.
      message id sy-msgid type sy-msgty number sy-msgno
        with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

  endif.

  go_pdf->merge_documents( importing merged_document = data(lv_doc) ).


  data: l_file type string,
        lv_sep type c.

  call method cl_gui_frontend_services=>get_temp_directory
    changing
      temp_dir             = l_file
    exceptions
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      others               = 4.
  if sy-subrc is not initial.
    message id 'ED' type 'E' number '256'.
  endif.


  call method cl_gui_cfw=>flush
    exceptions
      cntl_system_error = 1
      cntl_error        = 2
      others            = 3.
  if sy-subrc is not initial.
    message id 'ED' type 'E' number '256'.
  endif.


  call method cl_gui_frontend_services=>get_file_separator
    changing
      file_separator       = lv_sep
    exceptions
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      others               = 4.
  if sy-subrc is not initial.
    message id 'ED' type 'E' number '256'.
  endif.


  concatenate l_file lv_sep sy-repid `11111.pdf` into l_file.

  data: l_pdf_xstring type xstring.

  data : begin of lt_bin_data occurs 0,
           line type x length 255,
         end of lt_bin_data.

  call function 'SCMS_XSTRING_TO_BINARY'
    exporting
      buffer     = lv_doc
    tables
      binary_tab = lt_bin_data.

  data(l_len) = xstrlen( lv_doc ).

  call method cl_gui_frontend_services=>gui_download
    exporting
      bin_filesize            = l_len
      filename                = l_file
      filetype                = 'BIN'
    changing
      data_tab                = lt_bin_data[]
    exceptions
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      not_supported_by_gui    = 22
      error_no_gui            = 23
      others                  = 24.
  if sy-subrc is not initial.
    message id 'ED' type 'E' number '256'.
  endif.


  call method cl_gui_frontend_services=>execute
    exporting
      document               = l_file
      synchronous            = 'X'
    exceptions
      cntl_error             = 1
      error_no_gui           = 2
      bad_parameter          = 3
      file_not_found         = 4
      path_not_found         = 5
      file_extension_unknown = 6
      error_execute_failed   = 7
      synchronous_failed     = 8
      not_supported_by_gui   = 9
      others                 = 10.
  if sy-subrc is not initial.
    message id 'ED' type 'I' number '256'.
  endif.

  data l_rc type i.


  call method cl_gui_frontend_services=>file_delete
    exporting
      filename             = l_file
    changing
      rc                   = l_rc
    exceptions
      file_delete_failed   = 1
      cntl_error           = 2
      error_no_gui         = 3
      file_not_found       = 4
      access_denied        = 5
      unknown_error        = 6
      not_supported_by_gui = 7
      wrong_parameter      = 8
      others               = 9.
  if sy-subrc is not initial.
    message id 'ED' type 'E' number '256'.
  endif.

  call function 'FP_JOB_CLOSE'
    exceptions
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      others         = 4.
