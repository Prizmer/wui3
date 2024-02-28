-- View: public.danfoss_water_from_heat
DROP VIEW public.danfoss_water_from_heat;

CREATE OR REPLACE VIEW public.danfoss_water_from_heat
AS
SELECT *
FROM(
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents
           FROM comments
          WHERE comments.guid_resources = 'c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3'::uuid
          ORDER BY comments.name, comments.date DESC
        )
 SELECT z1.name_parent,
 z1.ab_guid,
    z1.ab_name,
    z1.obj_name,
    z1.factory_number_manual,
    z1.params_name, 
    z1.type_meter,
	case when z1.params_name = 'Канал 1' then 
                                z1.attr1 else
								z1.attr2 end as num_meter,                                  
	case when z1.params_name = 'Канал 1' then 
                                'ХВС' else
								'ГВС' end as res_name,
	 CASE when z1.params_name = 'Канал 1' then 
	 							'Объём ХВС'::text ELSE 
								'Объём ГВС'::text END AS name_param,
	last_comment.date,
    last_comment.name,
    last_comment.comment,
	z1.a, z1.ktt, z1.ktn, z1.dt_install
   FROM ( SELECT abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            objects.name AS obj_name,
            meters.factory_number_manual,
            meters.attr1,
            meters.attr2,
            types_meters.name AS type_meter,
		     names_params.name as params_name,
		 objects1.name AS name_parent,
		 link_abonents_taken_params.coefficient AS ktt,
            link_abonents_taken_params.coefficient_2 AS ktn,
            link_abonents_taken_params.coefficient_3 AS a,
		 meters.dt_install
           FROM abonents,
            objects,
            link_abonents_taken_params,
            taken_params,
            params,
            meters,
            names_params,
            resources,
            types_meters,
		 objects objects1
          WHERE objects.guid_parent::text = objects1.guid::text and
		 abonents.guid_objects::text = objects.guid::text AND 
		 link_abonents_taken_params.guid_abonents::text = abonents.guid::text AND 
		 link_abonents_taken_params.guid_taken_params::text = taken_params.guid::text AND 
		 taken_params.guid_params::text = params.guid::text AND 
		 taken_params.guid_meters::text = meters.guid::text AND 
		 params.guid_names_params::text = names_params.guid::text AND 
		 names_params.guid_resources::text = resources.guid::text AND 
		 resources.name::text = 'Импульс'::text AND 
		 meters.guid_types_meters = types_meters.guid AND		 
		 (types_meters.name = 'Danfoss SonoSelect' or  types_meters.name = 'Пульсар Теплосчётчик')
		 --AND meters.attr1 <> '' 
	     --and meters.attr2 <> '' 
          GROUP BY  objects1.name , abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name, types_meters.name,
		meters.attr1,
            meters.attr2,
		  names_params.name,
		link_abonents_taken_params.coefficient,
            link_abonents_taken_params.coefficient_2 ,
            link_abonents_taken_params.coefficient_3, 
		 meters.dt_install ) z1	 
     LEFT JOIN last_comment ON last_comment.guid_abonents::text = z1.ab_guid::text	 	 
) z

where num_meter <> ''
order by obj_name, ab_name
--ALTER TABLE public.heat_abons
--    OWNER TO postgres;

