Select row_number() over(ORDER BY ab_name) num, 
substring(ab_name from 10)::int,
(case when type_energo='Горячее водоснабжение' then 'ГВС' else 'ХВС' end),
''::text,
''::text,
''::text,
substring(meter_name from (position('№' in meter_name)+1)::int ),
(case when type_energo='Горячее водоснабжение' then 'fhw' else 'fcw' end),
(case when val_start > 0 then val_start::text else '-' end) as val_start, 
(case when val_end > 0 then val_end::text   else '-' end) as val_end, 
(case when val_end > 0 and val_start > 0 then round((val_end-val_start)::numeric, 3)::text else '-' end) as delta 
from
(
Select z_st.ab_name, z_st.account_2,z_st.date, z_st.meter_name,z_st.type_energo, z_st.value as val_start,z_end.value as val_end, z_st.date_install, z_end.date
from 
(Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='Импульс'
  and date='01.10.2018'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='Лазоревый пр-д, д.1а к2 (к6) Вода'
order by account_2, obj_name) z_st,
(
Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='Импульс'
  and date='10.10.2018'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='Лазоревый пр-д, д.1а к2 (к6) Вода'
order by account_2, obj_name) z_end
where z_st.meter_name=z_end.meter_name
and z_st.ab_name like '%Квартира%'
) z
order by ab_name