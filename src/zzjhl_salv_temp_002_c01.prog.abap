*&---------------------------------------------------------------------*
*& Include          ZZJHL_SALV_TEMP_001_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZZJHL_ALVTREE_TEMP_001_C01
*&---------------------------------------------------------------------*
include <cl_alv_control>.

class lcl_gui_alv_grid definition deferred.

data: gs_layout         type lvc_s_layo,
      gs_variant        type disvariant,
      gt_fieldcat_scarr type lvc_t_fcat,
      gt_sort           type lvc_t_sort,       "ALV Sort field
      gt_exclude        type ui_functions,     "ALV Exclude
      gv_alvtitle       type lvc_title,
      gs_stable         type lvc_s_stbl value 'XX',
      gt_dropdown       type lvc_t_dral.       "

data: go_alv_scarr          type ref to cl_salv_table,
      go_salv_event_handler type ref to lcl_gui_alv_grid,
      go_events             type ref to cl_salv_events_table.

* Custom Container.
constants:
  c_cont_scarr type scrfname value 'CONT_SPFLI'.

data go_cont_docking type ref to cl_gui_docking_container.

class lcl_gui_alv_grid definition.

  public section.

    methods on_added_function               " ADDED_FUNCTION
      for event if_salv_events_functions~added_function
      of cl_salv_events_table
      importing sender e_salv_function.

    methods on_double_click                 " DOUBLE_CLICK
      for event if_salv_events_actions_table~double_click
      of cl_salv_events_table
      importing sender row column.

    "hotspot & button click.
    methods on_link_click                   " LINK_CLICK
      for event if_salv_events_actions_table~link_click
      of cl_salv_events_table
      importing sender row column.

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

    case sender.
      when go_alv_scarr.
      when go_events.

        message |UserCommand~| type `I`.

      when others.
    endcase.


  endmethod.

  method on_double_click.
    break-point.
  endmethod.

  method on_link_click.

    break-point.

  endmethod.

endclass.
