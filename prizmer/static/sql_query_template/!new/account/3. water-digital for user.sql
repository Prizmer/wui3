WITH water_info as
(
  SELECT
  resources.name as res_name,
  auth_user.username,
  auth_user.first_name,
  auth_user.last_name,
  meters.name as meters_name
  
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
  (resources.name = 'ХВС' or resources.name = 'ГВС')AND 
  auth_user.id = 1
  and (types_meters.name = 'Пульсар ХВС' or types_meters.name = 'Пульсар ГВС')
  group by  resources.name,
  auth_user.username,
  auth_user.first_name,
  auth_user.last_name,
  meters.name)

SELECT res_name, water_info.username, water_info.first_name, water_info.last_name, water_info.meters_name, date, value
From water_info
LEFT JOIN 
(
  SELECT
  resources.name,
  auth_user.username,
  auth_user.first_name,
  auth_user.last_name,
  meters.name as meters_name,
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
  (resources.name = 'ХВС' or resources.name = 'ГВС')AND
  daily_values.date = '2019-06-10' AND
  auth_user.id = 1
  and (types_meters.name = 'Пульсар ХВС' or types_meters.name = 'Пульсар ГВС')
  group by  resources.name,
  auth_user.username,
  auth_user.first_name,
  auth_user.last_name,
  meters.name,
  daily_values.date,
  daily_values.value) as z
  ON z.meters_name = water_info.meters_name