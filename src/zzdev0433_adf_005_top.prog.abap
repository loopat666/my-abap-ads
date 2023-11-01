*&---------------------------------------------------------------------*
*& Include          ZYYYY_ADF_005_TOP
*&---------------------------------------------------------------------*

tables scarr.

data: ok_code type sy-ucomm,
      save_ok type sy-ucomm.

data: go_pdf type ref to cl_rspo_pdf_merge.

""PDF 변수
data: gv_fmname         type rs38l_fnam,
      gs_fpdocparams    type sfpdocparams,
      gs_fpoutputparams type sfpoutputparams,
      gs_fpformoutput   type fpformoutput.

data: gs_scarr   type scarr,
      gs_spfli   type spfli,
      gt_sflight type table of sflight,
      gt_sbook   type table of sbook.


select-options s_carrid for scarr-carrid obligatory.
