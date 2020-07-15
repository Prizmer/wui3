Select obj_name, Count(z.volume), Count(z.ab_name), round((count(volume)*100/count(ab_name))::numeric,2) as percent_val, (count (ab_name)-count (volume)) as no_val
from
(Select water_pulsar_abons.obj_name, water_pulsar_abons.ab_name, water_pulsar_abons.factory_number_manual, 
round(z2.value_daily::numeric,3) as volume, water_pulsar_abons.name
from water_pulsar_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.value_daily
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type,
            			  resources.name as res
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters,
            			  resources
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  names_params.guid_resources=resources.guid and
            			  objects.name = 'Корпус 7' AND            			  
            			  (types_meters.name::text = 'Пульсар ГВС'::text OR types_meters.name::text = 'Пульсар ХВС'::text)
            			  AND
            			  daily_values.date = '01/09/2018' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual, z1.res, z1.value_daily
            order by z1.name_abonents) as z2
on z2.number_manual=water_pulsar_abons.factory_number_manual
where water_pulsar_abons.obj_name='Корпус 7'
order by water_pulsar_abons.ab_name) as z
group by obj_name