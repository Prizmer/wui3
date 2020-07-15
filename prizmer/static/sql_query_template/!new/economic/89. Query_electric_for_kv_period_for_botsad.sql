Select row_number() over(ORDER BY z_start.account_1, z_start.type_energo) num, 
z_start.account_1::numeric,
z_start.type_energo, 
''::text,
''::text,
''::text,
z_start.factory_number_manual, 
z_start.type_energo2, 
(case when z_start.value_daily > 0 then z_start.value_daily::text else '-' end) as val_start, 
(case when z_end.value_daily > 0 then z_end.value_daily::text   else '-' end) as val_end, 
(case when z_end.value_daily > 0 and z_start.value_daily > 0 then round((z_end.value_daily-z_start.value_daily)::numeric, 3)::text else '-' end) as delta

from
(Select account_1, type_energo,  
    electric_abons_report_for_botsad.factory_number_manual, type_energo2,
    name_params, value_daily,
    ktt,ktn, electric_abons_report_for_botsad.obj_name, electric_abons_report_for_botsad.ab_name
from electric_abons_report_for_botsad
LEFT JOIN
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
                        objects.name = 'Лазоревый пр-д, д.1а к1 (к5)' AND
                        daily_values.date ='01.09.2018' 
                        and names_params.name!='T0 A+'
                        
) z2
on z2.number_manual=electric_abons_report_for_botsad.factory_number_manual and electric_abons_report_for_botsad.name_params=z2.params_name
where 
 electric_abons_report_for_botsad.obj_name='Лазоревый пр-д, д.1а к1 (к5)'  
 ) z_start,

(Select account_1, type_energo,  
    electric_abons_report_for_botsad.factory_number_manual, type_energo2,
    name_params, value_daily,
    ktt,ktn, electric_abons_report_for_botsad.obj_name, electric_abons_report_for_botsad.ab_name
from electric_abons_report_for_botsad
LEFT JOIN
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
                        objects.name = 'Лазоревый пр-д, д.1а к1 (к5)' AND
                        daily_values.date ='04.09.2018' 
                        and names_params.name!='T0 A+'
                        
) z2
on z2.number_manual=electric_abons_report_for_botsad.factory_number_manual and electric_abons_report_for_botsad.name_params=z2.params_name
where 
 electric_abons_report_for_botsad.obj_name='Лазоревый пр-д, д.1а к1 (к5)'  
 ) z_end

where z_start.factory_number_manual=z_end.factory_number_manual and z_start.type_energo=z_end.type_energo
 order by num, z_start.type_energo, z_start.type_energo2, z_start.account_1::numeric
