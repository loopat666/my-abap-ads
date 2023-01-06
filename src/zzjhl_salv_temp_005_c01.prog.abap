*&---------------------------------------------------------------------*
*& Include          ZZJHL_SALV_TEMP_001_C01
*&---------------------------------------------------------------------*
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
      gs_stable           type lvc_s_stbl value 'XX',
      gt_dropdown         type lvc_t_dral.       "

data: go_alvtree_sflight    type ref to cl_salv_tree,
      go_salv_event_handler type ref to lcl_gui_alv_grid,
      go_events             type ref to cl_salv_events_table.

* Custom Container.
constants:
  c_cont_sflight type scrfname value 'CONT_SPFLI'.

data: go_cont_docking     type ref to cl_gui_docking_container,
      go_custom_container type ref to cl_gui_custom_container.

class lcl_gui_alv_grid definition.

  public section.
    methods: on_added_function
      for event added_function of cl_salv_events_tree
      importing sender e_salv_function.

*    methods on_added_function               " ADDED_FUNCTION
*      for event if_salv_events_functions~added_function
*      of cl_salv_events_table
*      importing sender e_salv_function.
*
*    methods on_double_click                 " DOUBLE_CLICK
*      for event if_salv_events_actions_table~double_click
*      of cl_salv_events_table
*      importing sender row column.
*
*    "hotspot & button click.
*    methods on_link_click                   " LINK_CLICK
*      for event if_salv_events_actions_table~link_click
*      of cl_salv_events_table
*      importing sender row column.

*    methods on_before_salv_function         " BEFORE_SALV_FUNCTION
*      for event if_salv_events_functions~before_salv_function
*      of cl_salv_events_table
*      importing sender e_salv_function.
*
*    methods on_after_salv_function          " AFTER_SALV_FUNCTION
*      for event if_salv_events_functions~before_salv_function
*      of cl_salv_events_table
*      importing sender e_salv_function.

*    methods on_top_of_page                  " TOP_OF_PAGE
*      for event if_salv_events_list~top_of_page
*      of cl_salv_events_table
*      importing sender r_top_of_page
*                page
*                table_index.
*
*    methods on_end_of_page                  " END_OF_PAGE
*      for event if_salv_events_list~end_of_page
*      of cl_salv_events_table
*      importing sender r_end_of_page
*                page.
endclass.

class lcl_gui_alv_grid implementation.

  method on_added_function.

    case e_salv_function.
      when `NEW`.

        data(lt_nodes) = go_alvtree_sflight->get_selections( )->get_selected_nodes( ).
        data(lt_items) = go_alvtree_sflight->get_selections( )->get_selected_item( ).


        message |added Function Key: { e_salv_function }| type `I`.
      when ``.
      when others.
    endcase.

  endmethod.


*  method on_added_function.
*
*    case sender."if Multi object.
*      when go_events.
*
*        message |UserCommand~| type `I`.
*
*      when others.
*    endcase.
*
*
*  endmethod.
*
*  method on_double_click.
*
*    case sender.
*      when go_events.
*
*
*
*      when others.
*    endcase.
*
*    go_alvtree_sflight->refresh( ).
*
*  endmethod.
*
*  method on_link_click.
*
*
*    message |Row: { row }, Column: { column }| type `I`.
*
*
*  endmethod.

endclass.
