Select dd::date,
(case when count_48>1 then count_48 else 0 end),
factory_number_manual
FROM generate_series
        ( '01.09.2018'::timestamp
        , '04.09.2018'::timestamp
        , '1 day'::interval) dd
        left join
        (
SELECT
  names_params.name as name_param,
  various_values.date,
  count(meters.factory_number_manual) as count_48,
  meters.factory_number_manual
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
  factory_number_manual='28642349' and
  various_values.date BETWEEN '01.09.2018' and '03.09.2018'
  and names_params.name = 'R+ Профиль'

  group by names_params.name,
  various_values.date,
  meters.factory_number_manual,
  groups_80020.name
  order by factory_number_manual, date) z
  on z.date=dd
  group by dd,
  factory_number_manual,
  count_48
  order by  dd