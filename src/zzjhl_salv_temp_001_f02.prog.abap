*&---------------------------------------------------------------------*
*& Include          ZZJHL_SALV_TEMP_001_F02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_salv_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_salv_display .

  if go_alv_scarr is initial.

    go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).

*-------------------SALV Creation.--------------------------------------
    "creat salv.
    try.
        call method cl_salv_table=>factory
          exporting
            r_container  = go_cont_docking
          importing
            r_salv_table = go_alv_scarr
          changing
            t_table      = gt_scarr.

      catch cx_salv_msg.
        exit.
    endtry.

*   Layout.
    go_alv_scarr->get_layout( )->set_key( value #( report = sy-repid ) ).
    go_alv_scarr->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    go_alv_scarr->get_layout( )->set_default( abap_true ).

*   Functions
    go_alv_scarr->get_functions( )->set_default( abap_true ).

*   ALV Title.
    go_alv_scarr->get_display_settings( )->set_list_header( `Airline Information` ).
    go_alv_scarr->get_display_settings( )->set_list_header_size( 2 ).
    go_alv_scarr->get_display_settings( )->set_striped_pattern( abap_true ).

*   Selection Mode.
    go_alv_scarr->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column )."has Rowmark.
*    go_alv_scarr->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>multiple )."No Rowmark

*   Column Optimize.
    go_alv_scarr->get_columns( )->set_optimize( abap_true ).


  endif.


  go_alv_scarr->display( ).

endform.
