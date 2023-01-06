*&---------------------------------------------------------------------*
*& Report ZZJHL_ALVTREE_TEMP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzjhl_alvtree_temp_001.

include zzjhl_temp_common_01.

include zzjhl_alvtree_temp_001_top.
include zzjhl_alvtree_temp_001_c01.
include zzjhl_alvtree_temp_001_pbo.
include zzjhl_alvtree_temp_001_pai.
include zzjhl_alvtree_temp_001_f01.
include zzjhl_alvtree_temp_001_f02.


initialization.

  perform set_init.


start-of-selection.


  call screen '9000'.
