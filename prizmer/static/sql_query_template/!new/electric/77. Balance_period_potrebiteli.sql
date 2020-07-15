select balance_name,type,'Потребители'::text,sumT,res_name, date,
round((z1.sumT-lag(sumT) over (order by date))::numeric,3) as delta,
countAbon
from
(SELECT 
  balance_groups.name as balance_name, 
  link_balance_groups_meters.type, 
 
  sum(daily_values.value * link_abonents_taken_params.coefficient) as sumT, 
  count(daily_values.value) as countAbon,
  names_params.name as param_name, 
  resources.name AS res_name, 
  daily_values.date
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.link_balance_groups_meters, 
  public.taken_params, 
  public.meters, 
  public.balance_groups, 

  public.daily_values, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND

  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_balance_groups_meters.guid_meters = meters.guid AND
  link_balance_groups_meters.guid_balance_groups = balance_groups.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  balance_groups.name = 'Лазоревый пр-д, д.1а к2 (к6)' AND 
  daily_values.date between'21.08.2018' and '11.09.2018' AND 
  resources.name='Электричество' and
  names_params.name = 'T0 A+' and  
  link_balance_groups_meters.type is False
  group by  balance_groups.name, 
  link_balance_groups_meters.type, 
  names_params.name, 
  resources.name,daily_values.date
  order by date) z1
