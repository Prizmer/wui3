Select z3.c_date,z3.obj_name,z3.obj_name, z3.gvs,z3.hvs,
round((z3.gvs-lag(gvs)over (order by c_date))::numeric,3)  as delta_gvs,
round((z3.hvs-lag(hvs) over (order by c_date))::numeric,3) as delta_hvs
from
(Select z_date.c_date,z1.obj_name, z1.gvs,z1.hvs
from
(select c_date::date
from
generate_series('01.01.2019'::timestamp without time zone, '11.01.2019'::timestamp without time zone, interval '1 day') as c_date) z_date
left join
(
SELECT 
  objects.name as obj_name,   
  daily_values.date, 
  sum(Case when resources.name= 'ГВС' then daily_values.value  end) as gvs,
  sum(Case when resources.name= 'ХВС' then daily_values.value  end) as hvs
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.resources, 
  public.names_params, 
  public.daily_values
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  names_params.guid = params.guid_names_params AND
  daily_values.id_taken_params = taken_params.id AND
  (resources.name = 'ХВС' or
  resources.name = 'ГВС') AND 
  daily_values.date BETWEEN '01.01.2019' and '11.01.2019'
  and objects.name = 'Корпус 2' 
  group by 
  objects.name,    
  daily_values.date
  order by obj_name, date) z1
  on z1.date=z_date.c_date
  order by z_date.c_date
  ) z3
  
