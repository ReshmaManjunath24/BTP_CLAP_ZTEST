

CLASS zcl_wf_credit_limit_update DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

   INTERFACES if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
       tt_result TYPE STANDARD TABLE OF zcreditmanagementaccount WITH EMPTY KEY.

    CONSTANTS:
      c_destination TYPE string VALUE `S4D`,
      c_entity      TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'CREDITMANAGEMENTACCOUNT'.

  METHODS:
      get_proxy
        RETURNING VALUE(ro_result) TYPE REF TO /iwbep/if_cp_client_proxy.

ENDCLASS.



CLASS ZCL_WF_CREDIT_LIMIT_UPDATE IMPLEMENTATION.


  METHOD get_proxy.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
          i_name       = c_destination
          i_authn_mode = if_a4c_cp_service=>service_specific
        ).

        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

*        ro_result = cl_web_odata_client_factory=>create_v2_remote_proxy(
*        EXPORTING
*                    iv_service_definition_name = 'ZAPI_CRDTMBUSINESSPARTNER'
*            io_http_client             = lo_client
*            iv_relative_service_root   = '/sap/opu/odata/sap/API_CRDTMBUSINESSPARTNER/' ).
      CATCH cx_root.

    ENDTRY.

ENDMETHOD.


METHOD if_rap_query_provider~select.
   DATA: BEGIN OF ls_filter_plain,
            documentid TYPE if_rap_query_filter=>tt_range_option,
          END OF ls_filter_plain.

    DATA: BEGIN OF ls_key1,
            documentid TYPE sysuuid_x16,
          END OF ls_key1.

    DATA(lv_top)         = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)        = io_request->get_paging( )->get_offset( ).
    DATA(lt_fields)      = io_request->get_requested_elements( ).
    DATA(lt_sort)        = io_request->get_sort_elements( ).
    DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).

    LOOP AT lt_filter_cond ASSIGNING FIELD-SYMBOL(<ls_filter_cond>).
      ASSIGN COMPONENT <ls_filter_cond>-name OF STRUCTURE ls_filter_plain TO FIELD-SYMBOL(<lv_any>).
      CHECK sy-subrc = 0.
      <lv_any> = <ls_filter_cond>-range.
      ASSIGN COMPONENT <ls_filter_cond>-name OF STRUCTURE ls_key1 TO <lv_any>.
      CHECK sy-subrc = 0.
      <lv_any> = <ls_filter_cond>-range[ 1 ]-low.
    ENDLOOP.
Data ls_bp TYPE  zdd_customer.
    SELECT SINGLE *
        FROM zdd_customer where zcustomer_num in @<ls_filter_cond>-range

    INTO   @ls_bp.





      DATA(lo_wf_update) = NEW zcl_credit_limit_update( ).
      lo_wf_update->update_Credit_data( ls_bp-zcustomer_num ).







*    ENDLOOP.
*    io_out->write( `Updated company:` ).
*    io_out->write( ls_updated ).

    DATA:lt_result  TYPE TABLE of ZDD_UPDATE_CREDIT_LIMIT_API.

*    DATA(lo_bp) = NEW zcl_wf_bp( ).
*    DATA(lt_bp) = lo_bp->try_to_update_bp(  ).
*

 APPEND INITIAL LINE TO lt_result ASSIGNING FIELD-SYMBOL(<ls_result>).
   <ls_result>-customer = ls_bp-zcustomer_num.
                      <ls_result>-status = 'Completed'.

*                      role     = ls_approver-role

*    ENDLOOP.
    io_response->set_data( lt_result ).
    io_response->set_total_number_of_records( 1 ).
  ENDMETHOD.
ENDCLASS.
