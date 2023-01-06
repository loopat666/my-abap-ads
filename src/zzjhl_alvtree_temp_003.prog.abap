*&---------------------------------------------------------------------*
*& Report ZZJHL_ALVTREE_TEMP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzjhl_alvtree_temp_003.

include zzjhl_temp_common_01.

include zzjhl_alvtree_temp_003_top.
include zzjhl_alvtree_temp_003_c01.
include zzjhl_alvtree_temp_003_pbo.
include zzjhl_alvtree_temp_003_pai.
include zzjhl_alvtree_temp_003_f01.
include zzjhl_alvtree_temp_003_f02.


initialization.

  perform set_init.


start-of-selection.


  call screen '9000'.
