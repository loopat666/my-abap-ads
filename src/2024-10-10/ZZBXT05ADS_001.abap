*&---------------------------------------------------------------------*
*& Report ZZBXT05ADS_001
*&---------------------------------------------------------------------*
*& 구매오더 리스트
*&---------------------------------------------------------------------*
report zzbxt05ads_001.

tables: ekko, ekpo.

data: ls_header type zzbxt05ss0005,
      lt_items  type table of zzbxt05ss0004.

""PDF 변수
data: gv_fmname         type rs38l_fnam,
      gs_fpdocparams    type sfpdocparams,
      gs_fpoutputparams type sfpoutputparams,
      gs_fpformoutput   type fpformoutput,
      go_pdf            type ref to cl_rspo_pdf_merge.
*&---------------------------------------------------------------------*
parameters p_lifnr type ekko-lifnr default `100021`.

*&---------------------------------------------------------------------*
initialization.
  go_pdf = new #( ).

*&---------------------------------------------------------------------*
start-of-selection.

  select from ekko as a
  inner join ekpo as b
  on a~ebeln eq b~ebeln

  inner join lfa1 as z
  on a~lifnr eq z~lifnr

  fields b~ebeln, b~ebelp, b~matnr, b~txz01,
  b~menge, b~meins, b~netpr, b~netwr, a~waers,
  a~lifnr, z~name1 as lifnr_name, z~ort01 as ztext


  where a~bsart eq `NB`
  and a~lifnr eq @p_lifnr
  order by b~ebeln, b~ebelp
  into table @data(lt_data).

  if sy-subrc ne 0.
    exit.
  endif.

  ls_header-lifnr = lt_data[ 1 ]-lifnr.
  ls_header-lifnr_name = lt_data[ 1 ]-lifnr_name.

  lt_items = corresponding #( lt_data ).

  "Call ADS Form.

*  gs_fpoutputparams-dest = 'LP01'.
  gs_fpoutputparams-dest = 'PDF1'.
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
      i_name     = `ZZZZTEST0001`  "Adobe Form Name.
    importing
      e_funcname = gv_fmname.

  gs_fpdocparams-langu = sy-langu.

  call function gv_fmname
    exporting
      /1bcdwb/docparams  = gs_fpdocparams
      ls_po_header       = ls_header
      lt_po_items        = lt_items
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
      internal_e