-- View: electric_abons_2

-- DROP VIEW electric_abons_2;

CREATE OR REPLACE VIEW electric_abons_2 AS 
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents
           FROM comments
        )
 SELECT z1.ab_guid,
    z1.ab_name,
    z1.obj_name,
    z1.factory_number_manual,
    z1.res_name,
    last_comment.date,
    last_comment.name,
    last_comment.comment,
    last_comment.guid_abonents,
    z1.ktt,
    z1.ktn,
    z1.a,
    z1.name_parent,
    z1.lic_num
   FROM ( SELECT abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            abonents.account_1 as lic_num,
            objects.name AS obj_name,
            meters.factory_number_manual,
            resources.name AS res_name,
            link_abonents_taken_params.coefficient AS ktt,
            link_abonents_taken_params.coefficient_2 AS ktn,
            link_abonents_taken_params.coefficient_3 AS a,
            objects1.name AS name_parent
           FROM objects objects1,
            abonents,
            objects,
            link_abonents_taken_params,
            taken_params,
            params,
            meters,
            names_params,
            resources
          WHERE objects.guid_parent::text = objects1.guid::text AND abonents.guid_objects::text = objects.guid::text AND link_abonents_taken_params.guid_abonents::text = abonents.guid::text AND link_abonents_taken_params.guid_taken_params::text = taken_params.guid::text AND taken_params.guid_params::text = params.guid::text AND taken_params.guid_meters::text = meters.guid::text AND params.guid_names_params::text = names_params.guid::text AND names_params.guid_resources::text = resources.guid::text AND resources.name::text = 'Электричество'::text
          GROUP BY abonents.account_1, objects1.name, abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name, link_abonents_taken_params.coefficient, link_abonents_taken_params.coefficient_2, link_abonents_taken_params.coefficient_3
          ORDER BY abonents.name) z1
     LEFT JOIN last_comment ON last_comment.guid_abonents::text = z1.ab_guid::text;

ALTER TABLE electric_abons_2
  OWNER TO postgres;
