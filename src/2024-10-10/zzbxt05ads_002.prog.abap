*&---------------------------------------------------------------------*
*& Report ZZBXT05ADS_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzbxt05ads_002.

data: ls_header type zzbxt05s_ads01,
      lt_items  type zzbxt05t_ads02.

""PDF 변수
data: gv_fmname         type rs38l_fnam,
      gs_fpdocparams    type sfpdocparams,
      gs_fpoutputparams type sfpoutputparams,
      gs_fpformoutput   type fpformoutput,
      go_pdf            type ref to cl_rspo_pdf_merge.

parameters p_ebeln type ekko-ebeln default `4500000291`.

initialization.
  go_pdf = new #( ).

start-of-selection.

  select single from ekko as a
    inner join lfa1 as b
    on a~lifnr eq b~lifnr
    fields a~ebeln, a~lifnr as vendor, b~name1 as vendor_name,
    concat_with_space( concat_with_space( b~pstlz, ')', 1 ), concat_with_space( b~ort01, b~stras, 1 ), 1 ) as vendor_address,
    b~telf1 as vendor_tel, b~j_1kfrepre as vendor_ceo,
    a~rlwrt as price_sum, a~waers
    where a~ebeln eq @p_ebeln
    into corresponding fields of @ls_header.


  select from ekpo as a
    inner join ekko as b
    on a~ebeln eq b~ebeln

    inner join t001w as c
    on a~werks eq c~werks
    fields a~ebeln, ebelp, matnr, txz01, menge, meins, netpr, peinh, netwr, b~waers, c~name1 as znote
    where a~ebeln eq @p_ebeln
    order by a~ebeln, a~ebelp
    into corresponding fields of table @lt_items.

   select single sum( netwr ) as price_sum from @lt_items as a
     into @ls_header-price_sum.


*  cl_demo_output=>write_data( ls_header ).
*  cl_demo_output=>write_data( lt_items ).
*
*  cl_demo_output=>display( ).


  "Call PDF.


  "Call ADS Form.

  gs_fpoutputparams-dest = 'LP01'.
  gs_fpoutputparams-preview = 'X'.
  gs_fpoutputparams-nodialog = abap_true.
*  gs_fpoutputparams-getpdf   = 'M'."M 값을 지정해야 리턴값이 부여됨
*  gs_fpoutputparams-assemble = 'M'.""M 값을 지정해야 리턴값이 부여됨
*  gs_fpoutputparams-bumode   = 'M'.

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
      i_name     = `ZZZZTEST0003_PO`  "Adobe Form Name.
    importing
      e_funcname = gv_fmname.

  gs_fpdocparams-langu = sy-langu.

  call function gv_fmname
    exporting
      /1bcdwb/docparams  = gs_fpdocparams
      po_header          = ls_header
      po_items           = lt_items
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
