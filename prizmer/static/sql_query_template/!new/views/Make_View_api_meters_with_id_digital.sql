-- View: public.all_res_abons_with_check_params

--DROP VIEW public.all_res_abons_with_check_params;

CREATE OR REPLACE VIEW public.all_res_abons_with_check_params
 AS
 WITH check_params AS (
         SELECT meters.guid,
            meters.name,
            count(names_params.name) AS count,
                CASE
                    WHEN count(names_params.name) < 4 AND meters.name::text ~~ '%М-230%'::text THEN 'irrelevant'::text
                    WHEN count(names_params.name) > 1 AND meters.name::text ~~ '%ВС%'::text THEN 'irrelevant'::text
                    WHEN count(names_params.name) < 4 AND meters.name::text ~~ '%Тепло%'::text THEN 'irrelevant'::text
                    ELSE 'relevant'::text
                END AS status
           FROM taken_params,
            meters,
            params,
            names_params,
            types_params
          WHERE taken_params.guid_meters = meters.guid AND taken_params.guid_params = params.guid AND params.guid_names_params = names_params.guid AND params.guid_types_params = types_params.guid AND types_params.name::text = 'Суточный'::text
          GROUP BY meters.guid, meters.name, types_params.name
        )
 SELECT z1.ab_guid,
    z1.ab_name,
    z1.obj_guid,
    z1.obj_name,
    z1.factory_number_manual,
    z1.name_parent,
    z1.lic_num,
    z1.name_param,
    z1.guid_meters,
    z1.res_name,
    z1.date_verification,
    check_params.status,
	z1.parent_guid
   FROM ( SELECT abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            abonents.account_1 AS lic_num,
            objects.name AS obj_name,
            objects.guid AS obj_guid,
		 	objects.guid_parent as parent_guid,
            meters.factory_number_manual,
            resources.name AS res_name,
            link_abonents_taken_params.coefficient AS ktt,
            link_abonents_taken_params.coefficient_2 AS ktn,
            link_abonents_taken_params.coefficient_3 AS a,
            objects1.name AS name_parent,
            names_params.name AS name_param,
            meters.dt_install,
            meters.attr4 AS date_verification,
            meters.guid AS guid_meters
           FROM objects objects1,
            abonents,
            objects,
            link_abonents_taken_params,
            taken_params,
            params,
            meters,
            names_params,
            resources,
            types_params
          WHERE objects.guid_parent::text = objects1.guid::text AND abonents.guid_objects::text = objects.guid::text AND link_abonents_taken_params.guid_abonents::text = abonents.guid::text AND link_abonents_taken_params.guid_taken_params::text = taken_params.guid::text AND taken_params.guid_params::text = params.guid::text AND taken_params.guid_meters::text = meters.guid::text AND params.guid_names_params::text = names_params.guid::text AND names_params.guid_resources::text = resources.guid::text AND params.guid_types_params = types_params.guid AND types_params.name::text = 'Суточный'::text
          GROUP BY meters.guid, objects.guid, meters.dt_install, names_params.name, abonents.account_1, objects1.name, abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name, link_abonents_taken_params.coefficient, link_abonents_taken_params.coefficient_2, link_abonents_taken_params.coefficient_3
          ORDER BY abonents.name) z1
     LEFT JOIN check_params ON check_params.guid = z1.guid_meters
  GROUP BY z1.parent_guid, z1.ab_guid, z1.guid_meters, check_params.status, z1.ab_name, z1.obj_guid, z1.obj_name, z1.factory_number_manual, z1.name_parent, z1.lic_num, z1.res_name, z1.name_param, z1.date_verification;

--ALTER TABLE public.all_res_abons_with_check_params
 --   OWNER TO postgres;

