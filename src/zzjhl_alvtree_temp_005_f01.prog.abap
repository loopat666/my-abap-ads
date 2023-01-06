*&---------------------------------------------------------------------*
*& Include          ZZJHL_ALVTREE_TEMP_001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_alvtree_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_alvtree_display .

  if go_alvtree_sflight is initial.

    go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).

    go_alvtree_sflight = new #(
      parent = go_cont_docking
*      node_selection_mode = cl_gui_column_tree=>node_sel_mode_single
      node_selection_mode = cl_gui_column_tree=>node_sel_mode_multiple
      item_selection = space
      no_html_header = abap_true
    ).

    gs_treev_hhdr = value #(
     heading = `Airline/Schedule`
     tooltip = `Airline/Schedule`
     width = 20
    ).

    gs_layout = value #(
                 cwidth_opt  = abap_true
                 zebra       = abap_true
                 box_fname   = space
                 no_rowmark  = space
                 sel_mode    = `A`
                 stylefname  = space
                 grid_title  = space
                 smalltitle  = abap_true
                 no_toolbar  = space
                 info_fname  = space
                 ctab_fname  = space ).

*--------- Make Fieldcatalog -------------
    try.
        cl_salv_table=>factory(
        exporting
          list_display = abap_false
        importing
          r_salv_table = data(lo_salv_table)
        changing
          t_table      = gt_sflight ).
      catch cx_salv_msg.                                "#EC NO_HANDLER
    endtry.

    gt_fieldcat_sflight = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                          r_columns      = lo_salv_table->get_columns( )
                          r_aggregations = lo_salv_table->get_aggregations( )
                        ).

    loop at gt_fieldcat_sflight assigning field-symbol(<fs_fieldcat_sflight>).
      <fs_fieldcat_sflight>-col_opt = abap_true.
      case <fs_fieldcat_sflight>-fieldname.
        when `PRICE`.
          <fs_fieldcat_sflight>-do_sum = abap_true.
          <fs_fieldcat_sflight>-h_ftype = `SUM`.
        when `SEATSMAX`.
          <fs_fieldcat_sflight>-do_sum = abap_true.
          <fs_fieldcat_sflight>-h_ftype = `MAX`.
        when `SEATSOCC`.
          <fs_fieldcat_sflight>-do_sum = abap_true.
          <fs_fieldcat_sflight>-h_ftype = `AVG`.
        when `PAYMENTSUM`.
          <fs_fieldcat_sflight>-do_sum = abap_true.
          <fs_fieldcat_sflight>-h_ftype = `MIN`.
        when `MANDT` or `CARRID` or `CONNID`.
          <fs_fieldcat_sflight>-tech = abap_true.
        when others.
      endcase.
    endloop.

    data: ls_variant type disvariant.
    ls_variant-report = sy-repid.

    go_alvtree_sflight->set_table_for_first_display(
      exporting
        is_hierarchy_header  = gs_treev_hhdr                 " Hierarchy Fields
        i_background_id     = 'ALV_BACKGROUND'
        i_save              = 'A'
        is_variant          = ls_variant
      changing
        it_outtab            = gt_sflight               " Output Table
         it_fieldcatalog      =  gt_fieldcat_sflight                " Field Catalog
    ).

*   add nodes.

    data lt_item_layout	type lvc_t_layi.

    append value #(
      fieldname = go_alvtree_sflight->c_hierarchy_column_name
      class = cl_gui_column_tree=>item_class_checkbox
      editable = abap_true
    ) to lt_item_layout.

    select * from sflight order by carrid, connid into table @data(lt_sflight).

    loop at lt_sflight into data(ls_sflight) group by ( carrid = ls_sflight-carrid ).



      go_alvtree_sflight->add_node(
        exporting
          i_relat_node_key     = ``                  " Node Already in Tree Hierarchy
          i_relationship       = cl_gui_column_tree=>relat_last_child                  " How to Insert Node
          is_outtab_line       = gs_sflight                 " Attributes of Inserted Node
          i_node_text          = conv #( ls_sflight-carrid )                 " Hierarchy Node Text
        importing
          e_new_node_key       = data(lv_node_key)                  " Key of New Node Key
      ).

      loop at group ls_sflight into data(ls_group).


        go_alvtree_sflight->add_node(
          exporting
            i_relat_node_key     = lv_node_key                  " Node Already in Tree Hierarchy
            i_relationship       = cl_gui_column_tree=>relat_last_child                  " How to Insert Node
            is_outtab_line       = ls_group                 " Attributes of Inserted Node
          it_item_layout       = lt_item_layout
            i_node_text          = conv #( ls_group-connid )                  " Hierarchy Node Text
        ).

      endloop.

    endloop.

*   Toolbar add.
    go_alvtree_sflight->get_toolbar_object(
      importing
        er_toolbar = data(lo_toolbar)                 " Toolbar Object
    ).

    lo_toolbar->add_button(
      exporting
        fcode     = ''
        icon      = ''
        butn_type = cntb_btype_sep
    ).

    lo_toolbar->add_button(
      exporting
        fcode            = `DELETE`                  " Function Code Associated with Button
        icon             = icon_delete                 " Icon Name Defined Like "@0a@"
        butn_type        = cntb_btype_button                 " Button Types Defined in CNTB
        text             = `Delete`                  " Text Shown to the Right of the Image
        quickinfo        = `Delete`                 " Purpose of Button Text
    ).

    lo_toolbar->add_button(
      exporting
        fcode            = `MENU`                  " Function Code Associated with Button
        icon             = icon_information                 " Icon Name Defined Like "@0a@"
        butn_type        = cntb_btype_menu                 " Button Types Defined in CNTB
        text             = `Information`                  " Text Shown to the Right of the Image
        quickinfo        = `Information`                 " Purpose of Button Text
    ).

    go_alvtree_sflight->update_calculations( ).

    go_alvtree_sflight->frontend_update( ).

*   Events.
    data lt_events type cntl_simple_events.

    append value #( eventid = cl_gui_column_tree=>eventid_expand_no_children ) to lt_events.
    append value #( eventid = cl_gui_column_tree=>eventid_checkbox_change ) to lt_events.
    append value #( eventid = cl_gui_column_tree=>eventid_header_context_men_req ) to lt_events.
    append value #( eventid = cl_gui_column_tree=>eventid_node_context_menu_req ) to lt_events.
    append value #( eventid = cl_gui_column_tree=>eventid_item_context_menu_req ) to lt_events.
    append value #( eventid = cl_gui_column_tree=>eventid_header_click ) to lt_events.
    append value #( eventid = cl_gui_column_tree=>eventid_item_keypress ) to lt_events.

    go_alvtree_sflight->set_registered_events(
      exporting
        events                    = lt_events                 " Event Table
      exceptions
        cntl_error                = 1                " cntl_error
        cntl_system_error         = 2                " cntl_system_error
        illegal_event_combination = 3                " ILLEGAL_EVENT_COMBINATION
        others                    = 4
    ).
    if sy-subrc <> 0.
    endif.

    set handler go_alvtree_sflight->on_function_selected for lo_toolbar.
    set handler go_alvtree_sflight->on_dropdown_clicked for lo_toolbar.






  endif.



endform.
