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
      gt_dropdown       type lvc_t_dral.       "

data: go_alv_scarr type ref to cl_salv_table.

* Custom Container.
constants:
  c_cont_scarr type scrfname value 'CONT_SPFLI'.

data go_cont_docking type ref to cl_gui_docking_container.

class lcl_gui_alv_grid definition inheriting from cl_gui_alv_tree.

  public section.
*    methods: on_function_selected "UserCommand.
*      for event function_selected of cl_gui_toolbar
*      importing sender fcode.
*
*    methods: on_dropdown_clicked "menu.
*      for event dropdown_clicked of cl_gui_toolbar
*      importing sender fcode posx posy.

endclass.

class lcl_gui_alv_grid implementation.

*  method on_function_selected.
*
*  endmethod.
*
*
*  method on_dropdown_clicked.
*
*  endmethod.

endclass.
