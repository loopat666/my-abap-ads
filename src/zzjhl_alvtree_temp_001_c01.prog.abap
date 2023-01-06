*&---------------------------------------------------------------------*
*& Include          ZZJHL_ALVTREE_TEMP_001_C01
*&---------------------------------------------------------------------*
include <cl_alv_control>.

class lcl_gui_alv_grid definition deferred.

data: gs_layout         type lvc_s_layo,
      gs_variant        type disvariant,
      gt_fieldcat_spfli type lvc_t_fcat,
      gt_sort           type lvc_t_sort,       "ALV Sort field
      gt_exclude        type ui_functions,     "ALV Exclude
      gv_alvtitle       type lvc_title,
      gt_dropdown       type lvc_t_dral.       "

*data: go_alvtree_spfli type ref to cl_gui_alv_tree.
data: go_alvtree_spfli type ref to lcl_gui_alv_grid.

data gs_treev_hhdr type treev_hhdr.

* Custom Container.
constants:
  c_cont_scarr type scrfname value 'CONT_SPFLI'.

data go_cont_docking type ref to cl_gui_docking_container.

class lcl_gui_alv_grid definition inheriting from cl_gui_alv_tree.

  public section.

endclass.

class lcl_gui_alv_grid implementation.



endclass.
