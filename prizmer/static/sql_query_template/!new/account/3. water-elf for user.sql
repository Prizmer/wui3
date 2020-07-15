WITH water_elf_info as (
SELECT 
  abonents.name as ab_name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.address, 
  meters.factory_number_manual,  
  types_meters.name as type_meter,
  CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter,
   CASE
            WHEN params.channel = 2 THEN 'ГВ'::text
            WHEN params.channel = 1 Then 'ХВ'::text
   END as type_res
FROM 
  public.abonents, 
  public.auth_user, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.types_meters,
  public.params
WHERE 
  taken_params.guid_params = params.guid AND
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.guid_meters = meters.guid AND
  meters.guid_types_meters = types_meters.guid
  and (channel=1 or channel=2)
  and types_meters.name = 'Эльф 1.08'
  and auth_user.id = 1
Group by abonents.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name, 
  meters.address, 
  meters.factory_number_manual, 
  meters.attr1, 
  meters.attr2, 
  types_meters.name,
  meters.attr2,
  meters.attr1,
  params.channel
)

Select water_elf_info.ab_name, water_elf_info.username, water_elf_info.first_name, water_elf_info.last_name,water_elf_info.meter, water_elf_info.type_res, z.value
From water_elf_info
LEFT JOIN 
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter,
   CASE
            WHEN params.channel = 2 THEN 'ГВ'::text
            WHEN params.channel = 1 Then 'ХВ'::text
   END as type_res,
  daily_values.date, 
  daily_values.value,
  abonents.name
   
  
 
FROM 
  public.abonents, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.auth_user, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.daily_values,
  types_meters
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.id_taken_params = taken_params.id AND 
  params.guid_types_meters = types_meters.guid  AND
  daily_values.date = '04/02/2019' 
  and (channel=1 or channel=2)
  and types_meters.name = 'Эльф 1.08'
  and auth_user.id = 1
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name,
  daily_values.date,
  daily_values.value,
  types_meters.name,
  params.channel,
  meters.attr2,
  meters.attr1) z
  on z.meter = water_elf_info.meter

