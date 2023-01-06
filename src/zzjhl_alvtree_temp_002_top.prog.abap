*&---------------------------------------------------------------------*
*& Include          ZZJHL_ALVTREE_TEMP_001_TOP
*&---------------------------------------------------------------------*

tables: spfli, sflight.

data: gs_spfli type spfli,
      gt_spfli type table of spfli.

data: gs_sflight type sflight,
      gt_sflight type table of sflight.

types:begin of ty_data,
        carrid   type scarr-carrid,
        carrname type scarr-carrname,
        currcode type scarr-currcode,
        url      type scarr-url,
        spfli    type spfli_tab,
        sflight  type ty_flights,
      end of ty_data.

data: gs_data type ty_data,
      gt_data type table of ty_data.
