-- таблица names_params
-- ошибки текущие
INSERT INTO public.names_params(
	guid, name, guid_measurement, guid_resources)
	VALUES ('8a9cd773-36d8-46c4-b595-7544d69b67ba','ГВС_current_error', '123b9b71-92e2-4a30-83a9-4bc4b6432b53', 'c0534604-4cf3-4286-8428-8b846270e16f');
	
INSERT INTO public.names_params(
	guid, name, guid_measurement, guid_resources)
	VALUES ('ab0d249b-2bbb-4f35-a534-d3a82108ecbc','ХВС_current_error', '123b9b71-92e2-4a30-83a9-4bc4b6432b53', 'c0534604-4cf3-4286-8428-8b846270e16f');
	
-- ошибки накопленные
INSERT INTO public.names_params(
	guid, name, guid_measurement, guid_resources)
	VALUES ('186b14a6-dfca-4edb-a4a6-548ba47b2b19','ГВС_accumulated_error', '123b9b71-92e2-4a30-83a9-4bc4b6432b53', 'c0534604-4cf3-4286-8428-8b846270e16f');
	
INSERT INTO public.names_params(
	guid, name, guid_measurement, guid_resources)
	VALUES ('4dc55400-40c4-4720-a916-45ac920e6a45','ХВС_accumulated_error', '123b9b71-92e2-4a30-83a9-4bc4b6432b53', 'c0534604-4cf3-4286-8428-8b846270e16f');