@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child entity'

define view entity ZRAP_R_XLSXU_Child
  as select from zrap_xlsxu_child
  association to parent ZRAP_R_XLSXU_Root as _Root on $projection.Parent = _Root.UUID
{

  key uuid            as UUID,

      parent          as Parent,

      subject         as Subject,

      @Semantics.amount.currencyCode: 'Currency'
      amount          as Amount,

      currency        as Currency,

      @Semantics.user.createdBy: true
      created_by      as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      etag_master     as EtagMaster,

      _Root // Make association public

}
