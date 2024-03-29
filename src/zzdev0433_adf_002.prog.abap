*&---------------------------------------------------------------------*
*& Report ZYYYY_ADF_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzdev0433_adf_002.

data: go_pdf type ref to cl_rspo_pdf_merge.

""PDF 변수
data: gv_fmname         type rs38l_fnam,
      gs_fpdocparams    type sfpdocparams,
      gs_fpoutputparams type sfpoutputparams,
      gs_fpformoutput   type fpformoutput.

data: ls_scarr type scarr,
      ls_spfli type spfli,
      lt_sbook type table of sbook.

start-of-selection.

  go_pdf = new #( ).

  select single * from scarr
    where carrid eq `AA`
     into corresponding fields of @ls_scarr.

  select single * from spfli
    where carrid eq `AA`
    and connid eq `0017`
    into corresponding fields of @ls_spfli.

  select * from sbook
    where carrid eq `AA`
    and connid eq `0017`
    and fldate eq `20211209`
    into corresponding fields of table @lt_sbook.


  gs_fpoutputparams-dest = 'LP01'.
  gs_fpoutputparams-preview = 'X'.
  gs_fpoutputparams-nodialog = abap_true.
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
      i_name     = `ZZDEV0433_ADF002`  "Adobe Form Name.
    importing
      e_funcname = gv_fmname.

  gs_fpdocparams-langu = sy-langu.

  call function gv_fmname
    exporting
      /1bcdwb/docparams  = gs_fpdocparams
      is_scarr           = ls_scarr
      is_spfli           = ls_spfli
*     IS_SBUSPART        = ``
      it_sbook           = lt_sbook
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
