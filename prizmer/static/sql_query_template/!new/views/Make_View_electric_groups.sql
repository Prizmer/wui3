-- View: electric_groups

-- DROP VIEW electric_groups;

CREATE OR REPLACE VIEW electric_groups AS 
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents
           FROM comments
        )
 SELECT z1.guid,
    z1.ab_guid,
    z1.name_abonents,
    z1.name_group,
    z1.number_manual,
    z1.res_name,
    last_comment.date,
    last_comment.name,
    last_comment.comment,
    last_comment.guid_abonents,
    z1.type,
    z1.ktt,
    z1.ktn,
    z1.a,
    z1.lic_num
   FROM ( SELECT abonents.account_1 as lic_num,
   balance_groups.guid,
            balance_groups.name AS name_group,
            abonents.name AS name_abonents,
            meters.factory_number_manual AS number_manual,
            resources.name AS res_name,
            abonents.guid AS ab_guid,
            link_balance_groups_meters.type,
            link_abonents_taken_params.coefficient AS ktt,
            link_abonents_taken_params.coefficient_2 AS ktn,
            link_abonents_taken_params.coefficient_3 AS a
           FROM abonents,
            link_abonents_taken_params,
            taken_params,
            meters,
            link_balance_groups_meters,
            balance_groups,
            names_params,
            params,
            resources
          WHERE taken_params.guid::text = link_abonents_taken_params.guid_taken_params::text AND abonents.guid::text = link_abonents_taken_params.guid_abonents::text AND taken_params.guid_params::text = params.guid::text AND names_params.guid::text = params.guid_names_params::text AND taken_params.guid_meters::text = meters.guid::text AND meters.guid::text = link_balance_groups_meters.guid_meters::text AND balance_groups.guid::text = link_balance_groups_meters.guid_balance_groups::text AND resources.name::text = 'Электричество'::text
          GROUP BY abonents.account_1, balance_groups.guid, balance_groups.name, abonents.name, meters.factory_number_manual, resources.name, abonents.guid, link_balance_groups_meters.type, link_abonents_taken_params.coefficient, link_abonents_taken_params.coefficient_2, link_abonents_taken_params.coefficient_3
          ORDER BY balance_groups.name, abonents.name) z1
     LEFT JOIN last_comment ON last_comment.guid_abonents::text = z1.ab_guid::text
  GROUP BY z1.lic_num, z1.guid, z1.ab_guid, z1.name_abonents, z1.name_group, z1.number_manual, z1.res_name, last_comment.date, last_comment.name, last_comment.comment, last_comment.guid_abonents, z1.type, z1.ktt, z1.ktn, z1.a;

ALTER TABLE electric_groups
  OWNER TO postgres;
