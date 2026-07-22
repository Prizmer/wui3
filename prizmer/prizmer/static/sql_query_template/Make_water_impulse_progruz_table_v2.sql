SELECT 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0,  
  abonents.name, 
  meters.factory_number_manual||'('||types_meters.name||')' as reg, 
  meters.address, 
  types_meters.name,
  params.param_address,
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port
 
 
FROM 
  public.parent_objects_for_progruz, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.params, 
  public.resources, 
  public.names_params, 
  public.link_meters_tcpip_settings, 
  public.tcpip_settings,
  types_meters
WHERE 
  types_meters.guid = params.guid_types_meters and
  parent_objects_for_progruz.ab_guid = abonents.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  link_meters_tcpip_settings.guid_meters = meters.guid AND
  link_meters_tcpip_settings.guid_tcpip_settings = tcpip_settings.guid
  and (resources.name = 'Импульс')
  group by 
parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0, 
  parent_objects_for_progruz.ab_name, 
  abonents.name, 
  abonents.account_1, 
  meters.factory_number_manual, 
  meters.address, 
  resources.name, 
  link_abonents_taken_params.coefficient,
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port, 
  meters.password,
  meters.name,
  types_meters.name,
 params.param_address
  order by 
  parent_objects_for_progruz.obj_name1,
  meters.factory_number_manual, 
  params.param_address,
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port
 
 