Select z_start.obj_name, z_start.ab_name, z_start.account_1, z_start.account_2, z_start.ab_guid, z_start.factory_number_manual, z_start.address, 
z_start.q1, z_end.q1, round((z_end.q1-z_start.q1)::numeric, 4),
z_start.q2, z_end.q2, round((z_end.q2-z_start.q2)::numeric, 4),
z_start.v_1, z_end.v_1, round((z_end.v_1-z_start.v_1)::numeric, 4),
z_start.v_2, z_end.v_2, round((z_end.v_2-z_start.v_2)::numeric, 4)
FROM
(Select heat_abons.obj_name,
heat_abons.ab_name,
heat_abons.account_1,
heat_abons.account_2,
heat_abons.ab_guid,
heat_abons.factory_number_manual,
z.address,
z.date,
z.res_name,
round(p_in1::numeric,4) as p_in1,
round(p_in2::numeric,4) as p_in2,
round(p_out1::numeric,4) as p_out1,
round(p_out2::numeric,4) as p_out2,
round(q1::numeric,4) as q1,
round(q2::numeric,4) as q2,
round(t_in1::numeric,4)as t_in1,
round(t_in2::numeric,4) as t_in2,
round(t_nar1::numeric,4) as t_nar1,
round(t_nar2::numeric,4) as t_nar2,
round(t_out1::numeric,4) as t_out1,
round(t_out2::numeric,4) as t_out2,
round(v_1::numeric,4) as v_1,
round(v_2::numeric,4) as v_2
from heat_abons
LEFT JOIN
(SELECT
  objects.name as obj_name,
  abonents.name as ab_name,
  abonents.account_1,
  abonents.account_2,
  abonents.guid as ab_guid,
  meters.name as meters_name,
  meters.address,
  daily_values.date,
  resources.name as res_name,
  sum(Case when params.name = 'ТЭМ-104 P_in Система1 Суточный -- adress: 46  channel: 0' then daily_values.value  end) as p_in1,
  sum(Case when params.name = 'ТЭМ-104 P_in Система2 Суточный -- adress: 49  channel: 0' then daily_values.value  end) as p_in2,
  sum(Case when params.name = 'ТЭМ-104 P_out Система1 Суточный -- adress: 47  channel: 0' then daily_values.value  end) as p_out1,
  sum(Case when params.name = 'ТЭМ-104 P_out Система2 Суточный -- adress: 50  channel: 0' then daily_values.value  end) as p_out2,
  sum(Case when params.name = 'ТЭМ-104 Q Система1 Суточный -- adress: 9  channel: 0' then daily_values.value  end) as q1,
  sum(Case when params.name = 'ТЭМ-104 Q Система2 Суточный -- adress: 10  channel: 0' then daily_values.value  end) as q2,
  sum(Case when params.name = 'ТЭМ-104 Ti Система1 Суточный -- adress: 34  channel: 0' then daily_values.value  end) as t_in1,
  sum(Case when params.name = 'ТЭМ-104 Ti Система2 Суточный -- adress: 37  channel: 0' then daily_values.value  end) as t_in2,
  sum(Case when params.name = 'ТЭМ-104 Tnar Система2 Суточный -- adress: 15  channel: 0' then daily_values.value  end) as t_nar2,
  sum(Case when params.name = 'ТЭМ-104 Tnar Система1 Суточный -- adress: 14  channel: 0' then daily_values.value  end) as t_nar1,
  sum(Case when params.name = 'ТЭМ-104 To Система2 Суточный -- adress: 38  channel: 0' then daily_values.value  end) as t_out2,
  sum(Case when params.name = 'ТЭМ-104 To Система1 Суточный -- adress: 35  channel: 0' then daily_values.value  end) as t_out1,
  sum(Case when params.name = 'ТЭМ-104 Объем Система1 Суточный -- adress: 1  channel: 0' then daily_values.value  end) as v_1,
  sum(Case when params.name = 'ТЭМ-104 Объем Система2 Суточный -- adress: 2  channel: 0' then daily_values.value  end) as v_2
FROM
  public.objects,
  public.abonents,
  public.link_abonents_taken_params,
  public.taken_params,
  public.meters,
  public.daily_values,
  public.params,
  public.resources,
  public.names_params
WHERE
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '05.11.2020' AND
  meters.name like '%ТЭМ-104%' AND
  abonents.name like '%%ВС%%' AND
  objects.name = 'Дом 3' AND
  abonents.name = 'Ввод ГВС ТЭМ-104 № 1245908' 
  GROUP by
  objects.name,
  abonents.name,
  abonents.account_1,
  abonents.account_2,
  abonents.guid,
  meters.name,
  meters.address,
  daily_values.date,
  resources.name ) as z
  on z.ab_guid = heat_abons.ab_guid
  WHERE heat_abons.ab_name like '%%ВС%%' AND
  heat_abons.ab_name = 'Ввод ГВС ТЭМ-104 № 1245908'  AND
  heat_abons.obj_name = 'Дом 3') as z_start,
  (
    Select heat_abons.obj_name,
heat_abons.ab_name,
heat_abons.account_1,
heat_abons.account_2,
heat_abons.ab_guid,
heat_abons.factory_number_manual,
z.address,
z.date,
z.res_name,
round(p_in1::numeric,4) as p_in1,
round(p_in2::numeric,4) as p_in2,
round(p_out1::numeric,4) as p_out1,
round(p_out2::numeric,4) as p_out2,
round(q1::numeric,4) as q1,
round(q2::numeric,4) as q2,
round(t_in1::numeric,4)as t_in1,
round(t_in2::numeric,4) as t_in2,
round(t_nar1::numeric,4) as t_nar1,
round(t_nar2::numeric,4) as t_nar2,
round(t_out1::numeric,4) as t_out1,
round(t_out2::numeric,4) as t_out2,
round(v_1::numeric,4) as v_1,
round(v_2::numeric,4) as v_2
from heat_abons
LEFT JOIN
(SELECT
  objects.name as obj_name,
  abonents.name as ab_name,
  abonents.account_1,
  abonents.account_2,
  abonents.guid as ab_guid,
  meters.name as meters_name,
  meters.address,
  daily_values.date,
  resources.name as res_name,
  sum(Case when params.name = 'ТЭМ-104 P_in Система1 Суточный -- adress: 46  channel: 0' then daily_values.value  end) as p_in1,
  sum(Case when params.name = 'ТЭМ-104 P_in Система2 Суточный -- adress: 49  channel: 0' then daily_values.value  end) as p_in2,
  sum(Case when params.name = 'ТЭМ-104 P_out Система1 Суточный -- adress: 47  channel: 0' then daily_values.value  end) as p_out1,
  sum(Case when params.name = 'ТЭМ-104 P_out Система2 Суточный -- adress: 50  channel: 0' then daily_values.value  end) as p_out2,
  sum(Case when params.name = 'ТЭМ-104 Q Система1 Суточный -- adress: 9  channel: 0' then daily_values.value  end) as q1,
  sum(Case when params.name = 'ТЭМ-104 Q Система2 Суточный -- adress: 10  channel: 0' then daily_values.value  end) as q2,
  sum(Case when params.name = 'ТЭМ-104 Ti Система1 Суточный -- adress: 34  channel: 0' then daily_values.value  end) as t_in1,
  sum(Case when params.name = 'ТЭМ-104 Ti Система2 Суточный -- adress: 37  channel: 0' then daily_values.value  end) as t_in2,
  sum(Case when params.name = 'ТЭМ-104 Tnar Система2 Суточный -- adress: 15  channel: 0' then daily_values.value  end) as t_nar2,
  sum(Case when params.name = 'ТЭМ-104 Tnar Система1 Суточный -- adress: 14  channel: 0' then daily_values.value  end) as t_nar1,
  sum(Case when params.name = 'ТЭМ-104 To Система2 Суточный -- adress: 38  channel: 0' then daily_values.value  end) as t_out2,
  sum(Case when params.name = 'ТЭМ-104 To Система1 Суточный -- adress: 35  channel: 0' then daily_values.value  end) as t_out1,
  sum(Case when params.name = 'ТЭМ-104 Объем Система1 Суточный -- adress: 1  channel: 0' then daily_values.value  end) as v_1,
  sum(Case when params.name = 'ТЭМ-104 Объем Система2 Суточный -- adress: 2  channel: 0' then daily_values.value  end) as v_2
FROM
  public.objects,
  public.abonents,
  public.link_abonents_taken_params,
  public.taken_params,
  public.meters,
  public.daily_values,
  public.params,
  public.resources,
  public.names_params
WHERE
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '05.11.2020' AND
  meters.name like '%ТЭМ-104%' AND
  abonents.name like '%%ВС%%' AND
  objects.name = 'Дом 3' AND
  abonents.name = 'Ввод ГВС ТЭМ-104 № 1245908'  AND  abonents.name = 'Ввод ГВС ТЭМ-104 № 1245908'
  GROUP by
  objects.name,
  abonents.name,
  abonents.account_1,
  abonents.account_2,
  abonents.guid,
  meters.name,
  meters.address,
  daily_values.date,
  resources.name ) as z
  on z.ab_guid = heat_abons.ab_guid
  WHERE heat_abons.ab_name like '%%ВС%%' AND
  heat_abons.ab_name = 'Ввод ГВС ТЭМ-104 № 1245908'  AND
  heat_abons.obj_name = 'Дом 3'
) as z_end
where z_start.ab_guid=z_end.ab_guid