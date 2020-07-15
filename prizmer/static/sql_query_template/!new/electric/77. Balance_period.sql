﻿select balance_name,type,type_abon,sumT,res_name, c_date,
round((z1.sumT-lag(sumT) over (order by date))::numeric,3) as delta,
countAbon,
guid_types_abonents
from
(
Select * 
from(select c_date::date
from
generate_series('18.03.2019'::timestamp without time zone, '26.03.2019'::timestamp without time zone, interval '1 day') as c_date) z4
left join 
(
SELECT
  balance_groups.name as balance_name,
  link_balance_groups_meters.type,
  types_abonents.name as type_abon,
  sum(daily_values.value * link_abonents_taken_params.coefficient) as sumT,
  count(daily_values.value) as countAbon,
  names_params.name as param_name,
  resources.name AS res_name,
  daily_values.date,
  abonents.guid_types_abonents
FROM
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.link_balance_groups_meters,
  public.taken_params,
  public.meters,
  public.balance_groups,
  public.types_abonents,
  public.daily_values,
  public.params,
  public.names_params,
  public.resources
WHERE
  abonents.guid_objects = objects.guid AND
  abonents.guid_types_abonents = types_abonents.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_balance_groups_meters.guid_meters = meters.guid AND
  link_balance_groups_meters.guid_balance_groups = balance_groups.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  balance_groups.name = '2-Лазоревый пр-д, д.1 (к7)' AND
  resources.name='Электричество' and
  daily_values.date between '18.03.2019' and '26.03.2019' AND
  names_params.name = 'T0 A+' and
  types_abonents.guid='878be59d-10a7-4c15-8789-c62ca588771b'
  group by  balance_groups.name,
  link_balance_groups_meters.type,
  types_abonents.name,
  abonents.guid_types_abonents,
  names_params.name,
  resources.name,daily_values.date
  order by types_abonents.name,date)z3
on z4.c_date=z3.date ) z1
order by c_date