WITH heat_info as
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.factory_number_manual 
 
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
  resources.name = 'Тепло' AND 
  auth_user.id = 1
  and types_meters.name = 'Эльф 1.08'
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.factory_number_manual
)

Select heat_info.username, heat_info.username, heat_info.first_name, heat_info.last_name, heat_info.factory_number_manual, z.energy, z.volume, z.t_in, z.t_out
From heat_info
Left JOIN
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.factory_number_manual, 
  daily_values.date, 

 sum(Case when names_params.name = 'Энергия' then value  end) as energy,
            sum(Case when names_params.name = 'Объем' then value  end) as volume,
            sum(Case when names_params.name = 'Ti' then value  end) as t_in,
            sum(Case when names_params.name = 'To' then value  end) as t_out
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
  resources.name = 'Тепло' AND 
  daily_values.date = '4/02/2019' AND
  auth_user.id = 1
  and types_meters.name = 'Эльф 1.08'
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.factory_number_manual, 
  daily_values.date
) z
ON z.factory_number_manual = heat_info.factory_number_manual
