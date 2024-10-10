*&---------------------------------------------------------------------*
*& Report ZZBXT05ADS_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzbxt05ads_010.

data lt_list type zzbxt05t_ads10.

""PDF 변수
data: gv_fmname         type rs38l_fnam,
      gs_fpdocparams    type sfpdocparams,
      gs_fpoutputparams type sfpoutputparams,
      gs_fpformoutput   type fpformoutput,
      go_pdf            type ref to cl_rspo_pdf_merge.

select-options s_date for sy-datum.

initialization.
  go_pdf = new #( ).


  s_date[] = value #( ( sign = `I` option = `BT` low = `20240501` high = `20240601` ) ).

start-of-selection.

  with
    +po_vendor as (
      select from ekko
        fields count( lifnr ) as lifnr_cnt ,lifnr,
        row_number( ) over( ) as zseq
        where bedat in @s_date
        and lifnr ne @space
        and bsart in (`NB`,`ZIM`)
        group by lifnr
    )
    select from +po_vendor as a
      inner join lfa1 as b
      on a~lifnr eq b~lifnr

      fields a~zseq, a~lifnr, b~name1 as lifnr_name, a~lifnr_cnt,
       concat_with_space( b~ort01, b~stras, 1 ) as lifnr_addr,
       b~telf1 as lifnr_tel
      into table @data(lt_vendors).

  loop at lt_vendors into data(ls_vendors).


    append initial line to lt_list assigning field-symbol(<fs_list>).

    <fs_list>-zseq = ls_vendors-zseq.

    append initial line to <fs_list>-po_vendors assigning field-symbol(<fs_vendors>).

    <fs_vendors> = corresponding #( ls_vendors ).


    "PO Items.

    select from ekko as a
      inner join ekpo as b
      on a~ebeln eq b~ebeln
      fields b~ebeln, b~ebelp, b~matnr, b~txz01, b~menge, b~meins
      where a~lifnr eq @ls_vendors-lifnr
      and a~bedat in @s_date
      into table @data(lt_items).


    loop at lt_items into data(ls_items).

      append initial line to <fs_vendors>-po_items assigning field-symbol(<fs_items>).

      <fs_items> = corresponding #( ls_items ).



    endloop.





  endloop.






*
  cl_demo_output=>write_data( lt_list ).
**
  cl_demo_output=>display( ).

  exit.

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
      i_name     = `ZZZZTEST_ADS01`  "Adobe Form Name.
    importing
      e_funcname = gv_fmname.

  gs_fpdocparams-langu = sy-langu.

  call function gv_fmname
    exporting
      /1bcdwb/docparams  = gs_fpdocparams
      it_list            = lt_list
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
