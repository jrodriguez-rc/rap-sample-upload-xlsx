CLASS lhc_root DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_ExcelContent,
             Subject  TYPE ZRAP_R_XLSXU_Child-Subject,
             Amount   TYPE ZRAP_R_XLSXU_Child-Amount,
             Currency TYPE ZRAP_R_XLSXU_Child-Currency,
           END OF ty_ExcelContent,
           ty_ExcelContentTable TYPE STANDARD TABLE OF ty_ExcelContent WITH EMPTY KEY.

    TYPES ty_entity_update TYPE STRUCTURE FOR UPDATE zrap_c_xlsxu_root\\root.
    TYPES ty_create_child  TYPE STRUCTURE FOR CREATE ZRAP_R_XLSXU_Root\\Root\_Child.

    METHODS augment_update FOR MODIFY
      IMPORTING entities FOR UPDATE Root.

    METHODS LoadExcel
      IMPORTING !entity       TYPE ty_entity_update
      RETURNING VALUE(result) TYPE ty_create_child.

ENDCLASS.



CLASS lhc_root IMPLEMENTATION.


  METHOD augment_update.

    DATA create_child TYPE TABLE FOR CREATE ZRAP_R_XLSXU_Root\\Root\_Child.
    DATA related      TYPE abp_behv_relating_tab.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      DATA(line) = sy-tabix.

      DATA(childs_to_create) = LoadExcel( <entity> ).
      IF childs_to_create IS INITIAL.
        CONTINUE.
      ENDIF.

      APPEND childs_to_create TO create_child.
      APPEND line TO related.

    ENDLOOP.

    IF create_child IS INITIAL.
      RETURN.
    ENDIF.

    MODIFY AUGMENTING ENTITIES OF ZRAP_R_XLSXU_Root
           ENTITY Root
           CREATE BY \_Child
           AUTO FILL CID
           WITH create_child
           RELATING TO entities BY related.

  ENDMETHOD.


  METHOD LoadExcel.

    DATA excel_content TYPE ty_ExcelContentTable.

    IF entity-StreamFile IS INITIAL OR entity-%control-StreamFile = if_abap_behv=>mk-off.
      RETURN.
    ENDIF.

    DATA(read_access) = xco_cp_xlsx=>document->for_file_content( entity-StreamFile )->read_access( ).

    IF read_access IS NOT BOUND.
      RETURN.
    ENDIF.

    DATA(worksheet) = read_access->get_workbook( )->worksheet->at_position( 1 ).

    DATA(selection_pattern) = xco_xlsx_selection=>pattern_builder->simple_from_to(
                          )->from_column( xco_xlsx=>coordinate->for_numeric_value( 1 )
                          )->from_row( xco_xlsx=>coordinate->for_numeric_value( 2 )
                          )->to_column( xco_xlsx=>coordinate->for_numeric_value( 3 )
                          )->get_pattern( ).

    worksheet->select( selection_pattern
      )->row_stream(
      )->operation->write_to( REF #( excel_content )
      )->if_xco_xlsx_ra_operation~execute( ).

    IF excel_content IS INITIAL.
      RETURN.
    ENDIF.

    result-%cid_ref  = entity-%cid_ref.
    result-%is_draft = entity-%is_draft.
    result-uuid      = entity-uuid.
    result-%target   = VALUE #( FOR <excel_content> IN excel_content
                                ( %is_draft         = entity-%is_draft
                                  Subject           = <excel_content>-Subject
                                  Amount            = <excel_content>-Amount
                                  Currency          = <excel_content>-Currency
                                  %control-Subject  = if_abap_behv=>mk-on
                                  %control-Amount   = if_abap_behv=>mk-on
                                  %control-Currency = if_abap_behv=>mk-on ) ).

  ENDMETHOD.


ENDCLASS.
