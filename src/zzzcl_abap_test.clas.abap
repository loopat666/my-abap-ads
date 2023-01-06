class ZZZCL_ABAP_TEST definition
  public
  final
  create public .

public section.
protected section.
private section.

  methods GET_TODAY
    returning
      value(RV_DATE) type DATUM .
ENDCLASS.



CLASS ZZZCL_ABAP_TEST IMPLEMENTATION.


  method get_today.

    rv_date = sy-datum.

  endmethod.
ENDCLASS.
