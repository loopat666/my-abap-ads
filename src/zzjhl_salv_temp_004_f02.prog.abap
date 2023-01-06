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

  if go_alvtree_sflight is initial.

    if cl_salv_tree=>is_offline( ) eq if_salv_c_bool_sap=>false.
      go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).
    endif.

    try.
        cl_salv_tree=>factory(
          exporting
            r_container = conv #( go_cont_docking )
          importing
            r_salv_tree = go_alvtree_sflight
          changing
            t_table = gt_sflight )."Internal Table 반드시 초기화.

      catch cx_salv_no_new_data_allowed cx_salv_error into data(msg).
        data(r_msg) = msg->get_message( ).
        cl_demo_output=>display( r_msg ).
        exit.
    endtry.

    "   Toolbar.
    go_alvtree_sflight->get_functions( )->set_all( abap_true ).

    "   FieldCatalog.
    go_alvtree_sflight->get_columns( )->get_column( columnname = `MANDT` )->set_technical( abap_true ).
    go_alvtree_sflight->get_columns( )->get_column( columnname = `CARRID` )->set_technical( abap_true ).
    go_alvtree_sflight->get_columns( )->get_column( columnname = `CONNID` )->set_technical( abap_true ).
    go_alvtree_sflight->get_columns( )->get_column( columnname = `FLDATE` )->set_technical( abap_true ).

    "   Tree Header.
    go_alvtree_sflight->get_tree_settings( )->set_hierarchy_header( `Airline/Schedule` ).
    go_alvtree_sflight->get_tree_settings( )->set_hierarchy_tooltip( `Airline/Schedule` ).
    go_alvtree_sflight->get_tree_settings( )->set_hierarchy_size( 20 ).

    "   Set Tree Nodes.
    perform set_tree_nodes.




  endif.

  go_alvtree_sflight->display( ).




endform.
*&---------------------------------------------------------------------*
*& Form set_tree_nodes
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_tree_nodes .

  select * from scarr into table @data(lt_scarr).
  select * from sflight into table @data(lt_sflight).

  loop at lt_scarr into data(ls_scarr).

    go_alvtree_sflight->get_nodes( )->add_node(
      exporting
        related_node   = ''
        relationship   = cl_gui_column_tree=>relat_last_child
        text           = conv #( ls_scarr-carrid )
        receiving
        node = data(lo_node_carrid) ).

    loop at lt_sflight into data(ls_sflight) where carrid eq ls_scarr-carrid
                                              group by ( carrid = ls_sflight-carrid
                                                        connid = ls_sflight-connid ).

      go_alvtree_sflight->get_nodes( )->add_node(
        exporting
          related_node   = lo_node_carrid->get_key( )
          relationship   = cl_gui_column_tree=>relat_last_child
          text           = conv #( ls_sflight-connid )
        receiving
          node = data(lo_node_connid) ).


      loop at group ls_sflight into data(ls_group).

        go_alvtree_sflight->get_nodes( )->add_node(
          exporting
            related_node   = lo_node_connid->get_key( )
            relationship   = cl_gui_column_tree=>relat_last_child
            data_row = ls_group
            text           = conv #( |{ ls_group-fldate date = iso }| ) ).

      endloop.

    endloop.

  endloop.

endform.
