@AbapCatalog.sqlViewName: 'ZANNUALAPRSAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition for Annual Appraisal Notification'
define view ZDD_ANNUAL_APPRAISAL_LIST as select from ztab_customers
association [0..1] to ZDD_BusinessUnit_VH as _BusinessUnit         on $projection.zbusiness_unit_name = _BusinessUnit.Businessunit
{
    key zcustomer_num,
    
    zbusiness_unit_name,
    ztotal_credit_amount,
    zfirst_name,
    zmdg_bp_id,
    zrequest_no,
    zlicense_no,
    zcredit_limit,
    zvalid_to,
    _BusinessUnit.cc as Credit_Controller,
    _BusinessUnit.ccemailid as CC_email, 
    dats_add_months(zvalid_to, -1 ,'FAIL') as Notification_Date
    
    
}
where zvalid_to <> '00000000' and _BusinessUnit.cc != 'NA'
