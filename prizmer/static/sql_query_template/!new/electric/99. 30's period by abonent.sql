Select        
       meter_name,
       factory_number_manual,
       ktt,
       date,
       time,
       c_date,
       activ,
       reactiv,
       '30',
       (EXTRACT(EPOCH FROM c_date) * 1000)::text  as utc,
       row_number() over(ORDER BY meter_name) num
from 
(select c_date
from
generate_series('28.03.2019 00:00:00'::timestamp without time zone, '02.04.2019 23:30:00'::timestamp without time zone, interval '30 minutes') as c_date) as z_date
Left join
(SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name, 
  meters.name as meter_name, 
  meters.factory_number_manual, 
  link_abonents_taken_params.coefficient as ktt, 
  various_values.date, 
  various_values.time,   
  (various_values.date + various_values.time)::timestamp as date_time,
  SUM (CASE when names_params.name = 'A+ Профиль' then various_values.value else 0 end) as activ,
  SUM (CASE when names_params.name = 'R+ Профиль' then various_values.value else 0 end) as reactiv
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.various_values, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  various_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  various_values.date between '28.03.2019' and '02.04.2019' AND 
  abonents.name = 'ГРЩ1_ Ввод1' AND 
  objects.name = 'д. 43'
  group by 
  objects.name, 
  abonents.name, 
  meters.name, 
  meters.factory_number_manual, 
  link_abonents_taken_params.coefficient, 
  various_values.date, 
  various_values.time
  ORDER BY
  various_values.date ASC, 
  various_values.time ASC) z1
  on z1.date_time = z_date.c_date
