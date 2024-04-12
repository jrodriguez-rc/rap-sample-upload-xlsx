@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED ZRAP_XLSXU_ROOT'

define root view entity ZRAP_R_XLSXU_Root
  as select from zrap_xlsxu_root
  composition [0..*] of ZRAP_R_XLSXU_Child as _Child
{

      @ObjectModel.text.element: [ 'Title' ]
  key uuid            as UUID,

      title           as Title,

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

      _Child

}
