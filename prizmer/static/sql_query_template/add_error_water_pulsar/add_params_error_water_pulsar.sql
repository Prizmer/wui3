INSERT INTO public.measurement(
	guid, name, comments)
	VALUES ('123b9b71-92e2-4a30-83a9-4bc4b6432b53', 'Текст', 'Для кодов ошибок');

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
	
-- Добавляем запись в params
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES (
'd5417782-4ea5-4bfb-bc3f-21e8e7868aa9',	'Пульсар ГВС ГВС_current_error Суточный -- adress: 0  channel: 0',	0,	0,	'8a9cd773-36d8-46c4-b595-7544d69b67ba',	'a1a349ba-e070-4ec9-975d-9f39e61c34da',	'bb986590-63cb-4b9f-8f4b-1b96335c5441')

INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES (
'649603aa-93a8-44df-ba55-e15e3bf44c0e',	'Пульсар ГВС ГВС_accumulated_error Суточный -- adress: 1  channel: 0',	1,	0,	'186b14a6-dfca-4edb-a4a6-548ba47b2b19',	'a1a349ba-e070-4ec9-975d-9f39e61c34da',	'bb986590-63cb-4b9f-8f4b-1b96335c5441')

INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES (
'6ca83dce-dcc9-4e2d-94ca-e22ec855a65d',	'Пульсар ХВС ХВС_current_error Суточный -- adress: 0  channel: 0',	0,	0,	'ab0d249b-2bbb-4f35-a534-d3a82108ecbc',	'f1789bb7-7fcd-4124-8432-40320559890f',	'bb986590-63cb-4b9f-8f4b-1b96335c5441')

INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES (
'3c066109-31bf-4256-83de-40ccd02e20fd',	'Пульсар ХВС ХВС_accumulated_error Суточный -- adress: 1  channel: 0',	1,	0,	'4dc55400-40c4-4720-a916-45ac920e6a45',	'f1789bb7-7fcd-4124-8432-40320559890f',	'bb986590-63cb-4b9f-8f4b-1b96335c5441')