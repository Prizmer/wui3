-- View: public.heat_impulse_report

DROP VIEW public.heat_impulse_report;

CREATE OR REPLACE VIEW public.heat_impulse_report
AS
 WITH korp AS (
         SELECT objects_1.name,
            objects_1.guid_parent,
            objects_1.guid
           FROM objects objects_1
          WHERE ((objects_1.name)::text ~~ '%Вода%'::text)
        )
 SELECT korp.name,
    abonents.account_1,
    abonents.account_2,
    abonents.name AS ab_name,
        '2015-01-01'::date AS date_install,
    objects.name AS obj_name,
    meters.name AS meter_name,
    names_params.name AS channel,
	substring(abonents.name from position('№' in abonents.name)+1 for 100) as factory_number_manual,
	
    meters.attr1,
	meters.attr2,
	meters.attr3,
	meters.attr4

   FROM korp,
    meters,
    abonents,
    objects,
    taken_params,
    link_abonents_taken_params,
    types_meters,
    params,
    names_params,
    types_params,
    resources
  WHERE (((params.guid)::text = (taken_params.guid_params)::text) AND 
		 ((names_params.guid)::text = (params.guid_names_params)::text) AND 
		 ((meters.guid_types_meters)::text = (types_meters.guid)::text) AND 
		 ((abonents.guid_objects)::text = (objects.guid)::text) AND 
		 ((objects.guid_parent)::text = (korp.guid)::text) AND 
		 ((taken_params.guid_meters)::text = (meters.guid)::text) AND 
		 ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND 
		 ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND 
		 (resources.guid = names_params.guid_resources) AND 
		 ((resources.name)::text = 'Импульс'::text) AND 
		 ((types_params.guid)::text = (params.guid_types_params)::text)
		 AND ((abonents.name like 'ТЕПЛО%') or (abonents.name like '%Тепло%') or (abonents.name like '%тепло%')))
  GROUP BY korp.name, abonents.account_1, abonents.account_2, abonents.name, objects.name, meters.name, names_params.name, meters.factory_number_manual, meters.attr1,meters.attr2,
	meters.attr3,
	meters.attr4
  ORDER BY korp.name, objects.name, abonents.name;

--ALTER TABLE public.water_abons_report
 --   OWNER TO postgres;

