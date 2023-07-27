-- View: public.all_res_abons

-- DROP VIEW public.all_res_abons;

CREATE OR REPLACE VIEW public.all_res_abons
 AS
 SELECT z1.ab_guid,
    z1.ab_name,
    z1.obj_name,
    z1.factory_number_manual,
    z1.res_name,
    z1.ktt,
    z1.ktn,
    z1.a,
    z1.name_parent,
    z1.lic_num,
    z1.name_param,
    z1.dt_install
   FROM ( SELECT abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            abonents.account_1 AS lic_num,
            objects.name AS obj_name,
            meters.factory_number_manual,
            resources.name AS res_name,
            link_abonents_taken_params.coefficient AS ktt,
            link_abonents_taken_params.coefficient_2 AS ktn,
            link_abonents_taken_params.coefficient_3 AS a,
            objects1.name AS name_parent,
            names_params.name AS name_param,
            meters.dt_install
           FROM objects objects1,
            abonents,
            objects,
            link_abonents_taken_params,
            taken_params,
            params,
            meters,
            names_params,
            resources
          WHERE objects.guid_parent::text = objects1.guid::text AND abonents.guid_objects::text = objects.guid::text AND link_abonents_taken_params.guid_abonents::text = abonents.guid::text AND link_abonents_taken_params.guid_taken_params::text = taken_params.guid::text AND taken_params.guid_params::text = params.guid::text AND taken_params.guid_meters::text = meters.guid::text AND params.guid_names_params::text = names_params.guid::text AND names_params.guid_resources::text = resources.guid::text AND names_params.name::text !~~ '%Профиль%'::text
          GROUP BY meters.dt_install, names_params.name, abonents.account_1, objects1.name, abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name, link_abonents_taken_params.coefficient, link_abonents_taken_params.coefficient_2, link_abonents_taken_params.coefficient_3
          ORDER BY abonents.name) z1;

ALTER TABLE public.all_res_abons
    OWNER TO postgres;

