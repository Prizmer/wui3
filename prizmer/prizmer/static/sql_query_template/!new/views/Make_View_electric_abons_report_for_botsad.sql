CREATE OR REPLACE VIEW electric_abons_report_for_botsad AS 
 SELECT abonents.account_2,
 abonents.account_1,
    '2015-01-01'::date AS date_install,
    meters.name AS name_meter,
        CASE
            WHEN names_params.name::text ~~ '%T0%'::text THEN 'Электричество Сумма'::text
            WHEN names_params.name::text ~~ '%T1%'::text THEN 'ЭЛ1'::text
            WHEN names_params.name::text ~~ '%T2%'::text THEN 'ЭЛ2'::text
            WHEN names_params.name::text ~~ '%T3%'::text THEN 'ЭЛ3'::text
            ELSE 'ЭЛ'::text
        END AS type_energo,
    abonents.name AS ab_name,
    objects.name AS obj_name,
    names_params.name AS name_params,
    meters.factory_number_manual,
        CASE           
            WHEN names_params.name::text ~~ '%T1%'::text THEN 'fe1'::text
            WHEN names_params.name::text ~~ '%T2%'::text THEN 'fe2'::text
            WHEN names_params.name::text ~~ '%T3%'::text THEN 'fe3'::text
            ELSE 'fe'::text
        END AS type_energo2
   FROM abonents,
    objects,
    link_abonents_taken_params,
    taken_params,
    meters,
    params,
    names_params
  WHERE abonents.guid_objects::text = objects.guid::text AND link_abonents_taken_params.guid_abonents::text = abonents.guid::text AND link_abonents_taken_params.guid_taken_params::text = taken_params.guid::text AND taken_params.guid_meters::text = meters.guid::text AND taken_params.guid_params::text = params.guid::text AND params.guid_names_params::text = names_params.guid::text AND meters.name::text ~~ '%М-230%'::text
  And names_params.name not like '%T0%'
  GROUP BY abonents.account_2,abonents.account_1, meters.name, abonents.name, objects.name, names_params.name, meters.factory_number_manual
  ORDER BY objects.name, abonents.name, abonents.account_1;

ALTER TABLE electric_abons_report
  OWNER TO postgres;
