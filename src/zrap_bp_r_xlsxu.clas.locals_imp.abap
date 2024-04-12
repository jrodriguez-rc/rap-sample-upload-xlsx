CLASS lhc_root DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
      REQUEST requested_authorizations FOR Root
      RESULT result.

ENDCLASS.



CLASS lhc_root IMPLEMENTATION.


  METHOD get_global_authorizations.
  ENDMETHOD.


ENDCLASS.
