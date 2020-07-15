 Select c_date,daily_date,obj_name,ab_name,factory_number_manual,t0, tr0,ktn,ktt,a, 
round((z3.t0-lag(t0) over (order by c_date))::numeric,3) as delta_a,

round((z3.tr0-lag(tr0) over (order by c_date))::numeric,3) as delta_r

from
(select c_date::date
from
generate_series('18.12.2018'::timestamp without time zone, '21.12.2018'::timestamp without time zone, interval '1 day') as c_date) z4
left join 
(Select  z2.daily_date,
  electric_abons.obj_name, electric_abons.ab_name, 
    electric_abons.factory_number_manual, z2.t0,  z2.ktn, z2.ktt, z2.a, z2.tr0
from electric_abons
LEFT JOIN 
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = 'T0 A+' then z1.value_daily  end) as t0,

sum(Case when z1.params_name = 'T0 R+' then z1.value_daily  end) as tr0,

z1.ktn, z1.ktt, z1.a 
                        FROM
                        (SELECT daily_values.date as daily_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        daily_values.value as value_daily, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources			
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = daily_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='Электричество' and
                        abonents.name = 'КТП_1' AND 
                        objects.name = 'БКТП' AND                      
                        daily_values.date between '18.12.2018' and '21.12.2018'
                        ) z1                      
group by z1.name_objects, z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktn, z1.ktt, z1.a 
) z2
on electric_abons.ab_name=z2.name_abonents
where electric_abons.ab_name = 'КТП_1' AND electric_abons.obj_name='БКТП'
ORDER BY electric_abons.ab_name, z2.daily_date  ASC) z3
on z4.c_date=z3.daily_date 
order by z4.c_date