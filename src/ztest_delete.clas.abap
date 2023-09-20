CLASS ztest_delete DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ztest_delete IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.


DELETE from ztab_req_history.

  ENDMETHOD.

ENDCLASS.
