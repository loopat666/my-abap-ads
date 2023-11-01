*&---------------------------------------------------------------------*
*& Report ZZDEV0433_EXCEL_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzdev0433_excel_01.

data lo_excel_func type ref to zz0433cl_excel_common.


constants c_header_rowid type i value 4.

data lv_data_rowid type i.

data: go_excel        type ref to zcl_excel,
      go_excel_reader type ref to zif_excel_reader,
      go_excel_writer type ref to zif_excel_writer.


parameters p_carrid type scarr-carrid obligatory default `AA`.
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
initialization.

  lo_excel_func = new #( ).

*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
start-of-selection.


*   Get Data.

  select single * from scarr
    where carrid eq @p_carrid
    into @data(ls_scarr).

  select * from sflight
    where carrid eq @p_carrid
    order by connid, fldate
    into table @data(lt_sflight).





*   Set Excel.
  lo_excel_func->get_excel_by_smw0(
    exporting
      iv_excel_bjid          = `ZZEXCELFORMS01`
    importing
      eo_excel               = go_excel
    ev_excel_xstring       = data(lv_excel_xstring)
  exceptions
    smw0_object_notfounded = 1
    others                 = 2
  ).
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
      with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    exit.
  endif.
*
*  create object go_excel_reader type zcl_excel_reader_2007.
*
*  go_excel = go_excel_reader->load( i_excel2007 = lv_excel_xstring ).

  data(lo_work_sheet) = go_excel->get_active_worksheet( ).


  loop at lt_sflight into data(ls_sflight).

    lv_data_rowid = c_header_rowid + sy-tabix.

    lo_work_sheet->set_cell( exporting ip_column = `B` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-connid                 " Cell Value
        ip_abap_type = `N`
    ).

    lo_work_sheet->set_cell( exporting ip_column = `C` ip_row = lv_data_rowid " Cell Row
        ip_value = |{ ls_sflight-fldate date = environment }|                  " Cell Value
    ).

    lo_work_sheet->set_cell( exporting ip_column = `D` ip_row = lv_data_rowid " Cell Row
        ip_value = |{ ls_sflight-price currency = ls_sflight-currency }|                   " Cell Value
        ip_abap_type = `P`
    ).

    lo_work_sheet->set_cell( exporting ip_column = `E` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-currency                  " Cell Value
    ).

    lo_work_sheet->set_cell( exporting ip_column = `F` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-planetype                  " Cell Value
    ).

    lo_work_sheet->set_cell( exporting ip_column = `G` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-seatsmax                  " Cell Value
    ).

    lo_work_sheet->set_cell( exporting ip_column = `H` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-seatsocc                  " Cell Value
    ).

  endloop.

  add 2 to lv_data_rowid.

  lo_work_sheet->set_cell( exporting ip_column = `B` ip_row = lv_data_rowid " Cell Row
      ip_value = |{ ls_scarr-carrname } ({ ls_scarr-carrid })|                   " Cell Value
  ).

  add 1 to lv_data_rowid.

  lo_work_sheet->set_cell( exporting ip_column = `B` ip_row = lv_data_rowid " Cell Row
      ip_value = |{ ls_scarr-url }|                   " Cell Value
  ).




  create object go_excel_writer type zcl_excel_writer_2007.

  data(lv_xstring) = go_excel_writer->write_file( go_excel ).


  lo_excel_func->get_desktop_directory(
    importing
      ev_file_separator    = data(lv_separator)                 " Single-Character Flag
    receiving
      rv_desktop_directory = data(lv_desktop)
  ).

  lv_desktop = |{ lv_desktop } { lv_separator }111.xlsx|.

  lo_excel_func->gui_download(
    exporting
      iv_filename = conv #( lv_desktop )
      iv_xstring  = lv_xstring
  ).
