Select z_end.obj_name, z_end.ab_name, z_end.factory_number_manual, z_start.energy,  z_end.energy, round((z_end.energy- z_start.energy)::numeric,2) as delta_energy, z_start.volume, z_end.volume, round((z_end.volume-z_start.volume)::numeric,2) as delta_volume
FROM
(Select obj_name, ab_name, heat_abons.factory_number_manual, energy, volume, t_in, t_out
from heat_abons
Left Join
(
SELECT 
objects.name,
abonents.name,
  resources.name,   
   
  meters.factory_number_manual, 
  sum(Case when names_params.name = 'Энергия' then value  end) as energy,
            sum(Case when names_params.name = 'Объем' then value  end) as volume,
            sum(Case when names_params.name = 'Ti' then value  end) as t_in,
            sum(Case when names_params.name = 'To' then value  end) as t_out
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.names_params, 
  public.params, 
  public.meters, 
  public.daily_values
WHERE 
  objects.guid = abonents.guid_objects AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid = taken_params.guid_meters AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Тепло'   
  and date = '11.06.2019'
  group by resources.name,   
  meters.name,   
  meters.factory_number_manual,
  objects.name,
  abonents.name) z
  on z.factory_number_manual = heat_abons.factory_number_manual
  where obj_name='Корпус М1'
  order by ab_name) z_end,
  (Select obj_name, ab_name, heat_abons.factory_number_manual, energy, volume, t_in, t_out
from heat_abons
Left Join
(
SELECT 
objects.name,
abonents.name,
  resources.name,   
   
  meters.factory_number_manual, 
  sum(Case when names_params.name = 'Энергия' then value  end) as energy,
            sum(Case when names_params.name = 'Объем' then value  end) as volume,
            sum(Case when names_params.name = 'Ti' then value  end) as t_in,
            sum(Case when names_params.name = 'To' then value  end) as t_out
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.names_params, 
  public.params, 
  public.meters, 
  public.daily_values
WHERE 
  objects.guid = abonents.guid_objects AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid = taken_params.guid_meters AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Тепло'   
  and date = '10.06.2019'
  group by resources.name,   
  meters.name,   
  meters.factory_number_manual,
  objects.name,
  abonents.name) z
  on z.factory_number_manual = heat_abons.factory_number_manual
  where obj_name='Корпус М1'
  order by ab_name) z_start
  where z_end.factory_number_manual=z_start.factory_number_manual