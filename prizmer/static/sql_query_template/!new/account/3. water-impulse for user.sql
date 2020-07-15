with water_info as
(SELECT  
  resources.name as res_name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name as ab_name
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
  params.guid_types_meters = types_meters.guid  AND
  resources.name = 'Импульс' AND   
  auth_user.id = 1
  and types_meters.name like '%Пульсар%'
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name)

SELECT res_name, water_info.username, water_info.first_name, water_info.last_name, water_info.ab_name, date, value
From water_info
LEFT JOIN 
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name as ab_name,
  daily_values.date, 
   daily_values.value 
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
  resources.name = 'Импульс' AND 
  daily_values.date = '01.04.2019' AND
  auth_user.id = 1
  and types_meters.name like '%Пульсар%'
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name,
  daily_values.date,
  daily_values.value) as z
  ON z.ab_name = water_info.ab_name
  