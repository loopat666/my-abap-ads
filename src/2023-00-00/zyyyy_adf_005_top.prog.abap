*&---------------------------------------------------------------------*
*& Include          ZYYYY_ADF_005_TOP
*&---------------------------------------------------------------------*
data: go_pdf type ref to cl_rspo_pdf_merge.

""PDF 변수
data: gv_fmname         type rs38l_fnam,
      gs_fpdocparams    type sfpdocparams,
      gs_fpoutputparams type sfpoutputparams,
      gs_fpformoutput   type fpformoutput.

data: gs_scarr type scarr,
      gs_spfli type spfli,
      gt_sbook type table of sbook.
