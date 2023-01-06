*&---------------------------------------------------------------------*
*& Report ZZJHL_ALVTREE_TEMP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzjhl_alvtree_temp_005.

include zzjhl_temp_common_01.

include zzjhl_alvtree_temp_005_top.
include zzjhl_alvtree_temp_005_c01.
include zzjhl_alvtree_temp_005_pbo.
include zzjhl_alvtree_temp_005_pai.
include zzjhl_alvtree_temp_005_f01.
include zzjhl_alvtree_temp_005_f02.


initialization.

  perform set_init.


start-of-selection.


  call screen '9000'.
