@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZRAP_R_XLSXU_Child'

define view entity ZRAP_C_XLSXU_Child
  as projection on ZRAP_R_XLSXU_Child
{

  key UUID,

      Parent,

      Subject,

      Amount,

      Currency,

      CreatedBy,

      CreatedAt,

      LastChangedBy,

      LastChangedAt,

      EtagMaster,

      /* Associations */
      _Root : redirected to parent ZRAP_C_XLSXU_Root

}
