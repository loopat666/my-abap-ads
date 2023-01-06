*&---------------------------------------------------------------------*
*& Report ZZJHL_SALV_TEMP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzjhl_salv_temp_002.

include zzjhl_temp_common_01.

include zzjhl_salv_temp_002_top.
include zzjhl_salv_temp_002_c01.
include zzjhl_salv_temp_002_pbo.
include zzjhl_salv_temp_002_pai.
include zzjhl_salv_temp_002_f01.
include zzjhl_salv_temp_002_f02.


initialization.




start-of-selection.


  select * from scarr into corresponding fields of table @gt_scarr.


  call screen '9000'.
