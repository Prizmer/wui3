WITH electic_info as
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
  public.resources
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND 
  resources.name = 'Электричество' AND  
  auth_user.id = 1
  group by resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name
)

Select electic_info.res_name, electic_info.username, electic_info.first_name, electic_info.last_name, electic_info.meters_name, date, t0,t1,t2,t3
From electic_info
LEFT JOIN
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name as meters_name, 
  daily_values.date, 
sum(Case when names_params.name = 'T0 A+' then value  end) as t0,
sum(Case when names_params.name = 'T1 A+' then value  end) as t1,
sum(Case when names_params.name = 'T2 A+' then value end) as t2,
sum(Case when names_params.name = 'T3 A+' then value  end) as t3
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
  public.daily_values
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
  resources.name = 'Электричество' AND 
  daily_values.date = '01/06/2019' AND
  auth_user.id = 1
  group by resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name, 
  daily_values.date) as z
  ON z.meters_name = electic_info.meters_name