*&---------------------------------------------------------------------*
*& Report ZZDEV0433_EXCEL_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzdev0433_excel_03.

data lo_excel_func type ref to zz0433cl_excel_common.


constants c_header_rowid type i value 4.

data lv_data_rowid type i.

data: go_excel        type ref to zcl_excel,
      go_excel_reader type ref to zif_excel_reader,
      go_excel_writer type ref to zif_excel_writer.

data: lo_style_border type ref to zcl_excel_style,
      lo_border       type ref to zcl_excel_style_border,
      lo_style_fill   type ref to zcl_excel_style.

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
*

  go_excel = new #( ).

  go_excel->add_new_worksheet(
      ip_title = `Air`
  ).
*  catch zcx_excel. " Exceptions for ABAP2XLSX

  data(lo_work_sheet) = go_excel->get_active_worksheet( ).

  "Make Fill Style.

  lo_style_fill = go_excel->add_new_style( ).
  lo_style_fill->fill->fgcolor-theme = zcl_excel_style_color=>c_theme_light1.
  lo_style_fill->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
  data(lv_fill_guid) = lo_style_fill->get_guid( ).

  "Make Border Style.
  lo_border = new #( ).
  lo_border->border_color-rgb = zcl_excel_style_color=>c_gray.
  lo_border->border_style = zcl_excel_style_border=>c_border_thick.

  lo_style_border = go_excel->add_new_style( ).
  lo_style_border->borders->allborders = lo_border.

  data(lv_style_guid) = lo_style_border->get_guid( ).


*   Set Excel Data.
  lo_work_sheet->set_cell( exporting ip_column = `B` ip_row = c_header_rowid  " Cell Row
      ip_value = `Connection Number`                 " Cell Value
      ip_style = lv_style_guid
  ).

  lo_work_sheet->change_cell_style(
    exporting
      ip_column                      = `B`                 " Cell Column
      ip_row                         = c_header_rowid                 " Cell Row
      ip_fill_filltype               = zcl_excel_style_fill=>c_fill_solid                  " Fill Type
      ip_fill_fgcolor_rgb            = zcl_excel_style_color=>c_blue                 " Color ARGB
  ).

  lo_work_sheet->set_cell( exporting ip_column = `C` ip_row = c_header_rowid  " Cell Row
      ip_value = `Fly Date`                 " Cell Value
  ).

*   여러가지 스타일을 적용할경우 해당 메소스 사용 (lo_work_sheet->change_cell_style).
  lo_work_sheet->change_cell_style(
    exporting
      ip_column                      = `C`                 " Cell Column
      ip_row                         = c_header_rowid                 " Cell Row
      ip_fill_filltype               = zcl_excel_style_fill=>c_fill_solid                  " Fill Type
      ip_fill_fgcolor_rgb            = zcl_excel_style_color=>c_yellow                 " Color ARGB
  ).

  lo_work_sheet->change_cell_style(
    exporting
      ip_column                      = `C`                 " Cell Column
      ip_row                         = c_header_rowid                " Cell Row
      ip_borders_allborders_style    = zcl_excel_style_border=>c_border_double                   " Border style
      ip_borders_allborders_color    = value #( rgb = zcl_excel_style_color=>c_red )                  " Color
  ).


  lo_work_sheet->set_cell( exporting ip_column = `D` ip_row = c_header_rowid  " Cell Row
      ip_value = `Price`                 " Cell Value
      ip_style = lv_style_guid
  ).

  lo_work_sheet->set_cell( exporting ip_column = `E` ip_row = c_header_rowid  " Cell Row
      ip_value = `Currency`                 " Cell Value
      ip_style = lv_style_guid
  ).

  lo_work_sheet->set_cell( exporting ip_column = `F` ip_row = c_header_rowid  " Cell Row
      ip_value = `Plane Typle`                 " Cell Value
      ip_style = lv_style_guid
  ).

  lo_work_sheet->set_cell( exporting ip_column = `G` ip_row = c_header_rowid  " Cell Row
      ip_value = `Seats Max`                 " Cell Value
      ip_style = lv_style_guid
  ).

  lo_work_sheet->set_cell( exporting ip_column = `H` ip_row = c_header_rowid  " Cell Row
     ip_value = `Seat Socc`                 " Cell Value
     ip_style = lv_style_guid
 ).

  loop at lt_sflight into data(ls_sflight).

    lv_data_rowid = c_header_rowid + sy-tabix.

    lo_work_sheet->set_cell( exporting ip_column = `B` ip_row = lv_data_rowid  " Cell Row
        ip_value = ls_sflight-connid                 " Cell Value
        ip_abap_type = `N`
        ip_style = lv_style_guid
    ).

    lo_work_sheet->set_cell( exporting ip_column = `C` ip_row = lv_data_rowid " Cell Row
        ip_value = |{ ls_sflight-fldate date = environment }|                  " Cell Value
        ip_style = lv_style_guid
    ).

    lo_work_sheet->set_cell( exporting ip_column = `D` ip_row = lv_data_rowid " Cell Row
        ip_value = |{ ls_sflight-price currency = ls_sflight-currency }|                   " Cell Value
        ip_abap_type = `P`
        ip_style = lv_style_guid
    ).

    lo_work_sheet->set_cell( exporting ip_column = `E` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-currency                  " Cell Value
        ip_style = lv_style_guid
    ).

    lo_work_sheet->set_cell( exporting ip_column = `F` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-planetype                  " Cell Value
        ip_style = lv_style_guid
    ).

    lo_work_sheet->set_cell( exporting ip_column = `G` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-seatsmax                  " Cell Value
        ip_style = lv_style_guid
    ).

    lo_work_sheet->set_cell( exporting ip_column = `H` ip_row = lv_data_rowid " Cell Row
        ip_value = ls_sflight-seatsocc                  " Cell Value
        ip_style = lv_style_guid
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
