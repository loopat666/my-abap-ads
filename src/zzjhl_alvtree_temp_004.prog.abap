*&---------------------------------------------------------------------*
*& Report ZZJHL_ALVTREE_TEMP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzjhl_alvtree_temp_004.

include zzjhl_temp_common_01.

include zzjhl_alvtree_temp_004_top.
include zzjhl_alvtree_temp_004_c01.
include zzjhl_alvtree_temp_004_pbo.
include zzjhl_alvtree_temp_004_pai.
include zzjhl_alvtree_temp_004_f01.
include zzjhl_alvtree_temp_004_f02.


initialization.

  perform set_init.


start-of-selection.


  call screen '9000'.
