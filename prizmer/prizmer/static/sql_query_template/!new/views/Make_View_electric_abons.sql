-- View: public.electric_abons

-- DROP VIEW public.electric_abons;

CREATE OR REPLACE VIEW public.electric_abons
 AS
 SELECT abonents.guid AS ab_guid,
    abonents.name AS ab_name,
    objects.name AS obj_name,
    meters.factory_number_manual,
    resources.name,
	meters.address, 
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port,
  types_meters.name as type_meter
   FROM abonents,
    objects,
    link_abonents_taken_params,
    taken_params,
    params,
    meters,
    names_params,
    resources,	
		   link_meters_tcpip_settings, 
           tcpip_settings,
		   types_meters
  WHERE meters.guid_types_meters = types_meters.guid and 
  (link_meters_tcpip_settings.guid_meters = meters.guid AND
  link_meters_tcpip_settings.guid_tcpip_settings = tcpip_settings.guid AND
	  ((abonents.guid_objects)::text = (objects.guid)::text) AND ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND ((taken_params.guid_params)::text = (params.guid)::text) AND ((taken_params.guid_meters)::text = (meters.guid)::text) AND ((params.guid_names_params)::text = (names_params.guid)::text) AND ((names_params.guid_resources)::text = (resources.guid)::text) AND ((resources.name)::text = 'Электричество'::text))
  GROUP BY  meters.address, 
  tcpip_settings.ip_address, 
  types_meters.name,
  tcpip_settings.ip_port, abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name
  ORDER BY abonents.name;

ALTER TABLE public.electric_abons
    OWNER TO postgres;

