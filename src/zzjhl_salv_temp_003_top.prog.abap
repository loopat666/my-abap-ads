*&---------------------------------------------------------------------*
*& Include          ZZJHL_SALV_TEMP_001_TOP
*&---------------------------------------------------------------------*

tables scarr.

types:begin of ty_scarr,
        carrid   type	s_carr_id,
        carrname type	s_carrname,
        currcode type	s_currcode,
        url      type  s_carrurl,
        celltab  type lvc_t_scol,  "Color column
      end of ty_scarr.

data: gs_scarr type ty_scarr,
      gt_scarr type table of ty_scarr.

*data: gs_scarr type scarr,
*      gt_scarr type table of scarr.
