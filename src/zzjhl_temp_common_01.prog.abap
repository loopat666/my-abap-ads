*&---------------------------------------------------------------------*
*& Include          ZZJHL_TEMP_COMMON_01
*&---------------------------------------------------------------------*
data: save_ok         type sy-ucomm,                         " SAVE_OK
      ok_code         type sy-ucomm,                         " OK_CODE
      gv_title        type sy-title,                         " Title
      gv_sign         type char1,                            " Sign
      gv_init         type sap_bool,                            " Sign
      gv_count        type sy-tabix,                            " Grid selected rows.
      gv_error        type sap_bool,
      gv_display      type sap_bool,
      gv_cursor       type fieldname,
      gv_cursor_dynnr type sydynnr,
      gv_message_text type bapi_msg,
      gt_fcode        type table of sy-ucomm,                " GUI fcode
      gt_cond         type table of text300,                 " Dynamic Cond
      gt_message      type table of bapiret2,  " Message
      gv_lvc_title    type lvc_title,                        " Data Count
      gv_cprog        type sy-cprog.

*data gt_fieldvalue type hrbas_prof_filter_table. "FieldName, FieldValue.
*data gt_ranges type table of crmt_bsp_range. "Ranges Value.






*&---------------------------------------------------------------------*
*& Constants 정의
*&---------------------------------------------------------------------*
*-- Traffic Light
constants: c_red    type icon-id    value '@0A@',
           c_yellow type icon-id    value '@09@',
           c_green  type icon-id    value '@08@'.

*-- Led Light
constants: c_rled type icon-id    value '@5C@',
           c_yled type icon-id    value '@5D@',
           c_gled type icon-id    value '@5B@'.

constants: c_copy           type icon-id value '@14@',
           c_delete         type icon-id value '@11@',
           c_delete_line    type icon-id value '@18@',
           c_insert         type icon-id value '@17@',
           c_create         type icon-id value '@0Y@',
           c_export         type icon-id value '@49@',
           c_import         type icon-id value '@48@',
           c_save           type icon-id value '@2L@',
           c_exec           type icon-id value '@15@', "exacute.
           c_ok             type icon-id value '@0V@', "
           c_canc           type icon-id value '@0W@', "
           c_display        type icon-id value '@10@', "
           c_change         type icon-id value '@0Z@', "
           c_change_display type icon-id value '@3I@'. "

*-- 알파벳
constants: c_a(1) type c         value 'A',
           c_b(1) type c         value 'B',
           c_c(1) type c         value 'C',
           c_d(1) type c         value 'D',
           c_e(1) type c         value 'E',
           c_f(1) type c         value 'F',
           c_g(1) type c         value 'G',
           c_h(1) type c         value 'H',
           c_i(1) type c         value 'I',
           c_j(1) type c         value 'J',
           c_k(1) type c         value 'K',
           c_l(1) type c         value 'L',
           c_m(1) type c         value 'M',
           c_n(1) type c         value 'N',
           c_o(1) type c         value 'O',
           c_p(1) type c         value 'P',
           c_q(1) type c         value 'Q',
           c_r(1) type c         value 'R',
           c_s(1) type c         value 'S',
           c_t(1) type c         value 'T',
           c_u(1) type c         value 'U',
           c_v(1) type c         value 'V',
           c_w(1) type c         value 'W',
           c_x(1) type c         value 'X',
           c_y(1) type c         value 'Y',
           c_z(1) type c         value 'Z'.

constants: c_0 type   c    value '0',
           c_1 type   c    value '1',
           c_2 type   c    value '2',
           c_3 type   c    value '3',
           c_4 type   c    value '4',
           c_5 type   c    value '5',
           c_6 type   c    value '6',
           c_7 type   c    value '7',
           c_8 type   c    value '8',
           c_9 type   c    value '9'.

constants: c_zero2  type c length 2  value '00',
           c_zero3  type c length 3  value '000',
           c_zero4  type c length 4  value '0000',
           c_zero5  type c length 5  value '00000',
           c_zero6  type c length 6  value '000000',
           c_zero7  type c length 7  value '0000000',
           c_zero8  type c length 8  value '00000000',
           c_zero9  type c length 9  value '000000000',
           c_zero10 type c length 10 value '0000000000',
           c_zero11 type c length 11 value '00000000000',
           c_zero12 type c length 12 value '000000000000'.

constants: c_bt(2) type c          value 'BT',
           c_eq(2) type c          value 'EQ',
           c_ge(2) type c          value 'GE',
           c_gt(2) type c          value 'GT',
           c_le(2) type c          value 'LE',
           c_lt(2) type c          value 'LT',
           c_ne(2) type c          value 'NE'.

*&---------------------------------------------------------------------*
*&      Form  BAPI_COMMIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form _bapi_commit.
  call function 'BAPI_TRANSACTION_COMMIT'
    exporting
      wait = 'X'.
endform.                    "BAPI_COMMIT

*&---------------------------------------------------------------------*
*&      Form  BAPI_ROLLBACK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form _bapi_rollback.
  call function 'BAPI_TRANSACTION_ROLLBACK'.
endform.                    "BAPI_ROLLBACK



*&---------------------------------------------------------------------*
*&      Form  POPUP_TO_CONFIRM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form popup_to_confirm using p_title type text50
                            p_question type text255
                            r_answer type char1."Return values: '1', '2', 'A'

  call function 'POPUP_TO_CONFIRM'
    exporting
      titlebar              = p_title
      text_question         = p_question
      text_button_1         = 'Yes'
      text_button_2         = 'No'
      display_cancel_button = space
    importing
      answer                = r_answer "Return values: '1', '2', 'A'
    exceptions
      text_no_found         = 1
      others                = 2.

  case r_answer.
    when `1`.
      r_answer = `Y`.
    when others.
      r_answer = `N`.
  endcase.

endform.

*&---------------------------------------------------------------------*
*&      Form  exit_ucomm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form exit_ucomm.
  data lv_answer type char1.

  case sy-ucomm.
    when 'EXIT'.

      perform popup_to_confirm using `Exit` `Do you want to Exit Programe?` lv_answer.


      check lv_answer eq 'Y'.

      leave program.

    when 'BACK'  or 'CANC'.

      perform popup_to_confirm using `Exit` `Do you want to Back to Previous screen?` lv_answer.

      check lv_answer eq 'Y'.

      leave to screen 0.
  endcase.

endform.                    "exit_usercommond
