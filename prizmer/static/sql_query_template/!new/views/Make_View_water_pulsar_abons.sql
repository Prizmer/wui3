-- View: public.water_pulsar_abons

DROP VIEW public.water_pulsar_abons;
CREATE OR REPLACE VIEW public.water_pulsar_abons
 AS
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents,
            comments.date AS date_comment,
            comments.guid_resources
           FROM comments
          WHERE comments.guid_resources = '47f0b64c-2bf6-45b4-972b-601f473a3752'::uuid OR comments.guid_resources = '57ec8f42-69c6-4f79-81bb-8ea139407aa9'::uuid
          ORDER BY comments.name, comments.date DESC
        )
 SELECT z1.obj_guid,
    z1.obj_name,
    z1.ab_guid,
    z1.ab_name,
    z1.meter_name,
    z1.factory_number_manual,
    z1.name,
    z1.type_meter,
    z1.attr1,
	z1.attr2,
	z1.attr3,
	z1.attr4,
    last_comment.name AS comment_name,
    last_comment.comment,
    last_comment.guid_abonents,
    last_comment.date_comment,
    last_comment.guid_resources
   FROM ( SELECT objects.guid AS obj_guid,
            objects.name AS obj_name,
            abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            meters.name AS meter_name,
            meters.factory_number_manual,
            types_meters.name,
                CASE
                    WHEN types_meters.name::text = 'Пульс СТК ХВС'::text OR types_meters.name::text = 'Пульс СТК ГВС'::text THEN "substring"(types_meters.name::text, 11, 13)
                    ELSE "substring"(types_meters.name::text, 9, 11)
                END AS type_meter,
            meters.attr1,
		    meters.attr2,
		 	meters.attr3,
		 	meters.attr4
           FROM abonents,
            objects,
            link_abonents_taken_params,
            taken_params,
            meters,
            types_meters
          WHERE abonents.guid_objects::text = objects.guid::text AND link_abonents_taken_params.guid_abonents::text = abonents.guid::text AND link_abonents_taken_params.guid_taken_params::text = taken_params.guid::text AND taken_params.guid_meters::text = meters.guid::text AND meters.guid_types_meters::text = types_meters.guid::text AND (types_meters.name::text ~~ 'Пульс%ГВС'::text OR types_meters.name::text ~~ 'Пульс%ХВС'::text OR types_meters.name::text ~~ 'Декаст%ВС'::text)
          GROUP BY objects.guid, objects.name, abonents.guid, abonents.name, meters.name, meters.factory_number_manual, types_meters.name, meters.attr1,
		    meters.attr2,
		 	meters.attr3,
		 	meters.attr4) z1
     LEFT JOIN last_comment ON last_comment.guid_abonents::text = z1.ab_guid::text;

--ALTER TABLE public.water_pulsar_abons
--    OWNER TO postgres;

