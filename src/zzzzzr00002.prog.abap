*&---------------------------------------------------------------------*
*& Report ZZZZZR00002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zzzzzr00002.


data: ok_code type sy-ucomm.

data gv_text type text30.

parameters p_text type text30 default sy-datum.


start-of-selection.

  gv_text = p_text.


  call screen '9000'.
*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module status_9000 output.
  set pf-status 'S9000'.
* SET TITLEBAR 'xxx'.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_9000 input.


  case ok_code.
    when `BACK` or `EXIT` or `canc`.
      leave to screen 0.
    when others.
  endcase.

endmodule.
