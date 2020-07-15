Select '24/01/2019','24/01/2019', z.obj_name, z.ab_name, '',
sum(z.sum_30_t0) as sum_t0,
sum(z.sum_30_tr0) as sum_tr0
from 

(SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name, 
  various_values.date, 

  sum(Case when names_params.name = 'A+ Профиль' then various_values.value  end) as sum_30_t0,
  sum(Case when names_params.name = 'R+ Профиль' then various_values.value end) as sum_30_tr0
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.various_values, 
  public.params,
  names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.guid_params = params.guid AND
  various_values.id_taken_params = taken_params.id AND
  names_params.guid = params.guid_names_params AND 
  various_values.date between '21/01/2019' and '23/01/2019' and
                        abonents.name = 'КТП_1' AND 
                        objects.name = 'БКТП' 
  
  group by objects.name, 
  abonents.name,  
  various_values.date
  order by date
  ) z
group by z.obj_name, z.ab_name

  
