*&---------------------------------------------------------------------*
*& Report ZYYYY_ADF_005
*&---------------------------------------------------------------------*
*& ADS 출력 sample
*&---------------------------------------------------------------------*
report zzdev0433_adf_005.


include zzdev0433_adf_005_top.
include zzdev0433_adf_005_c01.


initialization.





start-of-selection.

  select * from sflight
  where carrid in @s_carrid
  into corresponding fields of table @gt_sflight.



  call screen '9000'.



*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module status_9000 output.
  set pf-status 'S9000'.
* SET TITLEBAR 'xxx'.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_9000 input.

  save_ok = ok_code.
  clear ok_code.

  case save_ok.
    when `BACK` or `EXIT` or `CANC`.
      leave to screen 0.
    when others.
  endcase.
endmodule.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module display_salv output.
  perform display_salv.
endmodule.
*&---------------------------------------------------------------------*
*& Form display_salv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form display_salv .

  if go_salv is initial.

    go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).

    try.

        cl_salv_table=>factory(
          exporting
            r_container    = go_cont_docking                          " Abstract Container for GUI Controls
          importing
            r_salv_table   = go_salv                           " Basis Class Simple ALV Tables
          changing
            t_table        = gt_sflight
            ).

      catch cx_salv_msg. " ALV: General Error Class with Message
        cl_demo_output=>display( |Error~!| ).
    endtry.

    go_salv->get_layout( )->set_key( value #( report = sy-repid ) ).
    go_salv->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    go_salv->get_layout( )->set_default( abap_true ).

    go_salv->get_functions( )->set_all( abap_true ).

    try.
        go_salv->get_functions( )->add_function(
        exporting
          name     = `PRINT`                  " ALV Function
          icon     = conv #( icon_print )
          text     = `Print`
          tooltip  = `Print`
          position = if_salv_c_function_position=>right_of_salv_functions                  " Positioning Function
          ).
      catch cx_root into data(msg).
        data(error) = msg->get_text( ).
        message i303(me) with error display like 'E'.
    endtry.

    go_event = new #( ).

    data(lo_event) = go_salv->get_event( ).

    set handler go_event->on_added_function for lo_event.

  endif.

  go_salv->display( ).

endform.
*&---------------------------------------------------------------------*
*& Form on_added_function
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SENDER
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
form on_added_function  using    po_sender
                                 p_function type sy-ucomm.

  case p_function.
    when `PRINT`.

      if go_pdf is initial.
        go_pdf = new #( ).
      endif.

      data(lt_selected_rows) = go_salv->get_selections( )->get_selected_rows( ).

      check lt_selected_rows is not initial.

      read table gt_sflight index lt_selected_rows[ 1 ] into data(ls_sflight).

      check sy-subrc eq 0.

      select single * from scarr
        where carrid eq @ls_sflight-carrid
         into corresponding fields of @gs_scarr.

      select single * from spfli
        where carrid eq @ls_sflight-carrid
        and connid eq @ls_sflight-connid
        into corresponding fields of @gs_spfli.

      select * from sbook
        where carrid eq @ls_sflight-carrid
         and connid eq @ls_sflight-connid
         and fldate eq @ls_sflight-fldate
        order by bookid
        into corresponding fields of table @gt_sbook.
*    up to 30 rows.

      check gt_sbook is not initial.

      data(lv_lines) = lines( gt_sbook ).

      data(lv_rest) = lv_lines mod 15.

      data(lv_add) = 15 - lv_rest.

      if lv_add is not initial.
        do lv_add times.
          append initial line to gt_sbook.
        enddo.
      endif.


      gs_fpoutputparams-dest = 'LP01'.
      gs_fpoutputparams-preview = 'X'.
      gs_fpoutputparams-nodialog = abap_true.
      gs_fpoutputparams-getpdf   = `M`."M 값을 지정해야 리턴값이 부여됨
      gs_fpoutputparams-assemble = `M`."M 값을 지정해야 리턴값이 부여됨
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
          i_name     = `ZZDEV0433_ADF004`  "Adobe Form Name.
        importing
          e_funcname = gv_fmname.

      gs_fpdocparams-langu = sy-langu.

      call function gv_fmname
        exporting
          /1bcdwb/docparams  = gs_fpdocparams
          is_scarr           = gs_scarr
          is_spfli           = gs_spfli
*         IS_SBUSPART        = ``
          it_sbook           = gt_sbook
        importing
          /1bcdwb/formoutput = gs_fpformoutput
        exceptions
          usage_error        = 1
          system_error       = 2
          internal_error     = 3.
      if sy-subrc = 0.
        go_pdf->add_document( gs_fpformoutput-pdf ).
      else.
        message id sy-msgid type sy-msgty number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      endif.


      call function 'FP_JOB_CLOSE'
        exceptions
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          others         = 4.


      data: lv_desktop  type string,
            lv_filename type string,
            lv_length   type i,
            lt_file     type standard table of x255.

      cl_gui_frontend_services=>get_desktop_directory(
        changing
          desktop_directory    = lv_desktop                 " Desktop Directory
        exceptions
          cntl_error           = 1                " Control error
          error_no_gui         = 2                " No GUI available
          not_supported_by_gui = 3                " GUI does not support this
          others               = 4
      ).
      if sy-subrc <> 0.
        message id sy-msgid type sy-msgty number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

        exit.
      endif.

      cl_gui_cfw=>update_view( ).


      lv_filename = |{ lv_desktop }/BookingList_{ sy-datum }_{ sy-uzeit }.pdf|.


      call function 'SCMS_XSTRING_TO_BINARY'
        exporting
          buffer        = gs_fpformoutput-pdf
        importing
          output_length = lv_length
        tables
          binary_tab    = lt_file.

      cl_gui_frontend_services=>gui_download(
        exporting
          filename                  = lv_filename                     " Name of file
          filetype                  = 'BIN'                " File type (ASCII, binary ...)
*    importing
*      filelength                =                      " Number of bytes transferred
        changing
          data_tab                  = lt_file                      " Transfer table
        exceptions
          file_write_error          = 1                    " Cannot write to file
          no_batch                  = 2                    " Cannot execute front-end function in background
          gui_refuse_filetransfer   = 3                    " Incorrect Front End
          invalid_type              = 4                    " Invalid value for parameter FILETYPE
          no_authority              = 5                    " No Download Authorization
          unknown_error             = 6                    " Unknown error
          header_not_allowed        = 7                    " Invalid header
          separator_not_allowed     = 8                    " Invalid separator
          filesize_not_allowed      = 9                    " Invalid file size
          header_too_long           = 10                   " Header information currently restricted to 1023 bytes
          dp_error_create           = 11                   " Cannot create DataProvider
          dp_error_send             = 12                   " Error Sending Data with DataProvider
          dp_error_write            = 13                   " Error Writing Data with DataProvider
          unknown_dp_error          = 14                   " Error when calling data provider
          access_denied             = 15                   " Access to file denied.
          dp_out_of_memory          = 16                   " Not enough memory in data provider
          disk_full                 = 17                   " Storage medium is full.
          dp_timeout                = 18                   " Data provider timeout
          file_not_found            = 19                   " Could not find file
          dataprovider_exception    = 20                   " General Exception Error in DataProvider
          control_flush_error       = 21                   " Error in Control Framework
          not_supported_by_gui      = 22                   " GUI does not support this
          error_no_gui              = 23                   " GUI not available
          others                    = 24
      ).
      if sy-subrc <> 0.
        message id sy-msgid type sy-msgty number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      endif.


    when others.
  endcase.


endform.
