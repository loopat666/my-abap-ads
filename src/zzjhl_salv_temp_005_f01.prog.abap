*&---------------------------------------------------------------------*
*& Include          ZZJHL_SALV_TEMP_001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_fieldcatalogs
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form get_fieldcatalogs .

**     SALV Can not Editable.
*
*  gt_fieldcat_sflight = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
*                            r_columns      = go_alvtree_sflight->get_columns( )
*                            r_aggregations = go_alvtree_sflight->get_aggregations( )
*                          ).
*
*  data(lo_columns) = go_alvtree_sflight->get_columns( ).
*  data(lo_aggregations) = go_alvtree_sflight->get_aggregations( ).
*
*  loop at gt_fieldcat_sflight assigning field-symbol(<fs_fieldcat_sflight>).
*    case <fs_fieldcat_sflight>-fieldname.
*      when `URL`.
*        <fs_fieldcat_sflight>-just = `C`.
*      when ``.
*      when others.
*    endcase.
*  endloop.
*
*  cl_salv_controller_metadata=>set_lvc_fieldcatalog(
*    exporting
*      t_fieldcatalog = gt_fieldcat_sflight                 " Field Catalog for List Viewer Control
*      r_columns      = lo_columns                 " ALV Filter
*      r_aggregations = lo_aggregations                 " ALV Columns
*  ).

endform.
