*&---------------------------------------------------------------------*
*& Report ZYYYY_ADF_005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zyyyy_adf_005.


include zyyyy_adf_005_top.
include zyyyy_adf_005_c01.


initialization.





start-of-selection.

  go_pdf = new #( ).

  select single * from scarr
    where carrid eq `AA`
     into corresponding fields of @gs_scarr.

  select single * from spfli
    where carrid eq `AA`
    and connid eq `0017`
    into corresponding fields of @gs_spfli.

  select * from sbook
    where carrid eq `AA`
    and connid eq `0017`
    and fldate eq `20211209`
    into corresponding fields of table @gt_sbook.
*    up to 30 rows.

  data(lv_lines) = lines( gt_sbook ).

  data(lv_rest) = lv_lines mod 15.

  data(lv_add) = 15 - lv_rest.

  if lv_add is not initial.
    do lv_add times.
      append initial line to gt_sbook.
    enddo.
  endif.


  gs_fpoutputparams-dest = 'LP01'.
*  gs_fpoutputparams-nodialog = 'X'.
  gs_fpoutputparams-preview = 'X'.

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
      i_name     = `ZYYYYADF004`  "Adobe Form Name.
    importing
      e_funcname = gv_fmname.

  gs_fpdocparams-langu = sy-langu.

  call function gv_fmname
    exporting
      /1bcdwb/docparams  = gs_fpdocparams
      is_scarr           = gs_scarr
      is_spfli           = gs_spfli
*     IS_SBUSPART        = ``
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
