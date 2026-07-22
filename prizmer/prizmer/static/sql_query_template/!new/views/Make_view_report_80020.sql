Create or replace view report_80020 as 
(SELECT 
  groups_80020.name as group_name, 
  groups_80020.name_sender, 
  groups_80020.inn_sender, 
  groups_80020.name_postavshik, 
  groups_80020.inn_postavshik, 
  groups_80020.dogovor_number, 
  meters.factory_number_manual, 
  link_groups_80020_meters.measuringpoint_code, 
  link_groups_80020_meters.measuringpoint_name, 
  meters.dt_last_read
FROM 
  public.meters, 
  public.link_groups_80020_meters, 
  public.groups_80020
WHERE 
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  link_groups_80020_meters.guid_meters = meters.guid)
