*&---------------------------------------------------------------------*
*& Include          ZYYYY_ADF_005_C01
*&---------------------------------------------------------------------*


class lcl_event definition deferred.

data go_salv type ref to cl_salv_table.

data go_event type ref to lcl_event.

data go_cont_docking type ref to cl_gui_docking_container.

class lcl_event definition.

  public section.
    methods on_added_function               " ADDED_FUNCTION
      for event added_function of cl_salv_events_table
      importing sender e_salv_function.



endclass.

class lcl_event implementation.

  method on_added_function.
    perform on_added_function using sender e_salv_function.
  endmethod.
endclass.
