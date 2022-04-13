-- View: public.heat_abons

-- DROP VIEW public.heat_abons;

CREATE OR REPLACE VIEW public.heat_abons
AS
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents
           FROM comments
          WHERE (comments.guid_resources = 'c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3'::uuid)
          ORDER BY comments.name, comments.date DESC
        )
 SELECT z1.ab_guid,
    z1.ab_name,
    z1.obj_name,
    z1.factory_number_manual,
    z1.res_name,
    last_comment.date,
    last_comment.name,
    last_comment.comment,
    z1.account_1,
    z1.account_2,
	type_meter
   FROM (( SELECT abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            objects.name AS obj_name,
            meters.factory_number_manual,
            resources.name AS res_name,
            abonents.account_1,
            abonents.account_2,
		  types_meters.name as type_meter
           FROM abonents,
            objects,
            link_abonents_taken_params,
            taken_params,
            params,
            meters,
            names_params,
            resources,
		    types_meters
          WHERE (((abonents.guid_objects)::text = (objects.guid)::text) AND 
				 ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND 
				 ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND 
				 ((taken_params.guid_params)::text = (params.guid)::text) AND 
				 ((taken_params.guid_meters)::text = (meters.guid)::text) AND 
				 ((params.guid_names_params)::text = (names_params.guid)::text) AND 
				 ((names_params.guid_resources)::text = (resources.guid)::text) AND 
				 ((resources.name)::text = 'Тепло'::text)) AND
		  (meters.guid_types_meters = types_meters.guid)
          GROUP BY abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name, 	  types_meters.name) z1
     LEFT JOIN last_comment ON (((last_comment.guid_abonents)::text = (z1.ab_guid)::text)));

ALTER TABLE public.heat_abons
  OWNER TO postgres;

