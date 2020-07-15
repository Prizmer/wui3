Select z2.date, obj_name as ab_name, water_abons_report.ab_name as meter_name,  z2.meter_name, z2.name_params, z2.value, z2.time
from water_abons_report
LEFT JOIN (
SELECT
  current_values.date,
  obj_name as ab_name,
  abonents.name as meters,
  meters.name as meter_name,
  names_params.name as name_params,
  current_values.value,
  current_values.time,
  abonents.guid,
  water_abons_report.name,
  resources.name as res
FROM
  public.meters,
  public.taken_params,
  public.current_values,
  public.abonents,
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  current_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='Импульс' and
  water_abons_report.name='Подъезд 2 Вода'
  order by obj_name, names_params.name ) z2
  on z2.meters=water_abons_report.ab_name
  where water_abons_report.name='Подъезд 2 Вода'
  order by obj_name, z2.name_params