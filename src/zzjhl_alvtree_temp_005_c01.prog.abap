*&---------------------------------------------------------------------*
*& Include          ZZJHL_ALVTREE_TEMP_001_C01
*&---------------------------------------------------------------------*
include <cl_alv_control>.

class lcl_gui_alv_grid definition deferred.

data: gs_layout           type lvc_s_layo,
      gs_variant          type disvariant,
      gt_fieldcat_sflight type lvc_t_fcat,
      gt_sort             type lvc_t_sort,       "ALV Sort field
      gt_exclude          type ui_functions,     "ALV Exclude
      gv_alvtitle         type lvc_title,
      gt_dropdown         type lvc_t_dral.       "

*data: go_alvtree_sflight type ref to cl_gui_alv_tree.
data: go_alvtree_sflight type ref to lcl_gui_alv_grid.

data gs_treev_hhdr type treev_hhdr.

* Custom Container.
constants:
  c_cont_scarr type scrfname value 'CONT_SPFLI'.

data go_cont_docking type ref to cl_gui_docking_container.

class lcl_gui_alv_grid definition inheriting from cl_gui_alv_tree.

  public section.
    methods: on_function_selected "UserCommand.
      for event function_selected of cl_gui_toolbar
      importing sender fcode.

    methods: on_dropdown_clicked "menu.
      for event dropdown_clicked of cl_gui_toolbar
      importing sender fcode posx posy.

endclass.

class lcl_gui_alv_grid implementation.

  method on_function_selected.

    data: lt_node_keys    type lvc_t_nkey.

    case fcode.
      when `DELETE`.

        go_alvtree_sflight->get_checked_items(
          importing
            et_checked_items = data(lt_checked_items)                  " Item table
        ).



        go_alvtree_sflight->get_selected_nodes(
          changing
            ct_selected_nodes = lt_node_keys ).

        loop at lt_node_keys into data(ls_node_keys).

          go_alvtree_sflight->delete_subtree(
            exporting
              i_node_key                = ls_node_keys                  " Node to be Deleted
              i_update_parents_expander = abap_true ).
        endloop.

      when `INFO`.
        message |information| type `I`.
      when `URL`.
        message |information| type `I`.
      when others.
    endcase.



  endmethod.


  method on_dropdown_clicked.

    data(lo_menus) = new cl_ctmenu( ).

    go_alvtree_sflight->get_toolbar_object(
      importing
        er_toolbar = data(lo_toolbar)                  " Toolbar Object
    ).

    lo_menus->add_function(
      exporting
        fcode             = `INFO`                  " Function code
        text              = `Information`                 " Function text
        icon              = icon_information                 " Icons
    ).

    lo_menus->add_function(
      exporting
        fcode             = `URL`                  " Function code
        text              = `Url`                 " Function text
        icon              = icon_url                 " Icons
    ).

    lo_toolbar->track_context_menu(
      exporting
        context_menu = lo_menus                 " Context Menu
        posx         = posx                  " X coordinate
        posy         = posy                 " Y Coordinate
*      exceptions
*        ctmenu_error = 1                " Error processing context menu
*        others       = 2
    ).
    if sy-subrc <> 0.
*     message id sy-msgid type sy-msgty number sy-msgno
*       with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.





  endmethod.

endclass.
