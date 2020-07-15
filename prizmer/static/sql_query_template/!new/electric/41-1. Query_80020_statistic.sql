Select z_info.name_sender, 
                         z_info.inn_sender, 
                         z_info.dogovor_number, 
                         z_info.factory_number_manual, 
                         z_info.measuringpoint_name, 
                         z_info.measuringpoint_code, 
                         z_info.dt_last_read,
                         z_info.val_start,
                         z_info.val_end,
                         z_info.delta,
                         round(z_count.sum_30::numeric,2),
                         z_count.percent
from
(Select z_start.name_sender, 
                         z_start.inn_sender, 
                         z_start.dogovor_number, 
                         z_start.factory_number_manual, 
                         z_start.measuringpoint_name, 
                          z_start.measuringpoint_code, 
                          z_start.dt_last_read,
                          z_start.value as val_start,
                          z_end.value as val_end,
                          round((z_end.value-z_start.value)::numeric,2) as delta
from
(Select report_80020.name_sender, 
                         report_80020.inn_sender, 
                          report_80020.dogovor_number, 
                         report_80020.factory_number_manual, 
                         report_80020.measuringpoint_name, 
                          report_80020.measuringpoint_code, 
                          report_80020.dt_last_read,
                          z1.value
from
report_80020
Left Join
(SELECT 
  meters.name, 
  meters.factory_number_manual, 
  daily_values.date, 
  daily_values.value, 
  groups_80020.name, 
  names_params.name
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.groups_80020, 
  public.link_groups_80020_meters, 
  public.params, 
  public.names_params
WHERE 
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  params.guid_names_params = names_params.guid AND
  daily_values.date = '01.09.2018' AND 
  names_params.name = 'T0 A+') z1
on z1.factory_number_manual=report_80020.factory_number_manual
where report_80020.group_name='80020') z_start,

(Select report_80020.name_sender, 
                         report_80020.inn_sender, 
                          report_80020.dogovor_number, 
                         report_80020.factory_number_manual, 
                         report_80020.measuringpoint_name, 
                          report_80020.measuringpoint_code, 
                          report_80020.dt_last_read,
                          z1.value 
from
report_80020
Left Join
(SELECT 
  meters.name, 
  meters.factory_number_manual, 
  daily_values.date, 
  daily_values.value, 
  groups_80020.name, 
  names_params.name
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.groups_80020, 
  public.link_groups_80020_meters, 
  public.params, 
  public.names_params
WHERE 
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  params.guid_names_params = names_params.guid AND
  daily_values.date = '03.09.2018' AND 
  names_params.name = 'T0 A+') z1
on z1.factory_number_manual=report_80020.factory_number_manual
where report_80020.group_name='80020') z_end
where z_start.factory_number_manual=z_end.factory_number_manual ) z_info
left join
(Select 
sum(z.summa) as sum_30 ,
z.factory_number_manual,
round( (
        100 -((((SELECT count(dd)
          FROM generate_series
        ( '01.09.2018'::timestamp 
        , '04.09.2018'::timestamp
        , '1 day'::interval) dd) *48)-sum(z.count_48))/((SELECT count(dd)
          FROM generate_series
        ( '01.09.2018'::timestamp 
        , '04.09.2018'::timestamp
        , '1 day'::interval) dd) *48)) *100)::numeric,1) as percent
from
(SELECT 
  names_params.name, 
  various_values.date, 
  sum (various_values.value) as summa, 
  count(meters.factory_number_manual) as count_48,
  meters.factory_number_manual, 
  groups_80020.name
FROM 
  public.meters, 
  public.groups_80020, 
  public.link_groups_80020_meters, 
  public.taken_params, 
  public.various_values, 
  public.params, 
  public.names_params
WHERE 
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  various_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.name = 'A+ Профиль' AND 
  various_values.date BETWEEN '01.09.2018' and '04.09.2018'
  group by names_params.name, 
  various_values.date,  
  meters.factory_number_manual, 
  groups_80020.name 
  order by factory_number_manual, date ) z
  group by z.factory_number_manual
) z_count
on z_count.factory_number_manual=z_info.factory_number_manual

