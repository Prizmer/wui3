SELECT 
  meters.factory_number_manual, 
  names_params.name
FROM 
  public.groups_80020, 
  public.meters, 
  public.types_meters, 
  public.names_params, 
  public.params, 
  public.link_groups_80020_meters
WHERE 
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  (names_params.name = 'T0 A+' OR 
  names_params.name = 'T0 R+')
  and groups_80020.name='80020'
group by   meters.factory_number_manual, 
  names_params.name,
  measuringpoint_name
  order by measuringpoint_name