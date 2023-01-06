*&---------------------------------------------------------------------*
*& Report ZZJHL_ALVTREE_TEMP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzjhl_alvtree_temp_002.

include zzjhl_temp_common_01.

include zzjhl_alvtree_temp_002_top.
include zzjhl_alvtree_temp_002_c01.
include zzjhl_alvtree_temp_002_pbo.
include zzjhl_alvtree_temp_002_pai.
include zzjhl_alvtree_temp_002_f01.
include zzjhl_alvtree_temp_002_f02.


initialization.

  perform set_init.


start-of-selection.

  select * from scarr into corresponding fields of table @gt_data.
  select * from spfli into corresponding fields of table @gt_spfli.
*  select * from sflight into corresponding fields of table @gt_sflight.

*  loop at gt_data assigning field-symbol(<fs_data>).
*
*    <fs_data>-spfli = value #( for wa in gt_spfli where ( carrid eq <fs_data>-carrid ) ( wa ) ).
*
*  endloop.

*  loop at gt_data assigning <fs_data>.
*
*    loop at <fs_data>-spfli into data(ls_spfli).
*
*      <fs_data>-sflight = value #( for ga in gt_sflight where ( carrid eq ls_spfli-carrid and
*                                                                connid eq ls_spfli-connid ) ( ga ) ).
*
*    endloop.
*
*  endloop.

  call screen '9000'.
