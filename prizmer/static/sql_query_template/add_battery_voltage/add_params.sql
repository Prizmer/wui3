
-- таблица names_params
-- Напряжение батарейки (возьмем для примера ресурс служебные)
INSERT INTO public.names_params(
	guid, name, guid_measurement, guid_resources)
	VALUES ('06f68849-3e99-4f36-9650-a2687a82f468','battery_voltage', '06f68849-3e99-4f36-9650-a2687a82f465', 'c0534604-4cf3-4286-8428-8b846270e16f');
-----------------------------------------------------------------

-- таблица params
-- Добавляем запись в params для Пульсар ХВС
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('b34e9c13-f8fc-4baa-acaa-4aa2b01e2866', 'Пульсар ХВС battery_voltage Суточный -- adress: 2  channel: 0', 2, 0, '06f68849-3e99-4f36-9650-a2687a82f468', 'f1789bb7-7fcd-4124-8432-40320559890f', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');

-- Добавляем запись в params для Пульсар ГВС
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('82e5717b-a4ec-4f88-9c18-338e5a0f8d30', 'Пульсар ГВС battery_voltage Суточный -- adress: 2  channel: 0', 2, 0, '06f68849-3e99-4f36-9650-a2687a82f468', 'a1a349ba-e070-4ec9-975d-9f39e61c34da', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');

-- Добавляем запись в params для Пульсар Теплосчётчик
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('c1efbc03-04b8-4f6f-abaf-645c25d601b6', 'Пульсар Теплосчётчик battery_voltage Суточный -- adress: 2  channel: 0', 2, 0, '06f68849-3e99-4f36-9650-a2687a82f468', '82b96b1c-31cf-4753-9d64-d22e2f4d036e', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');

-- c0534604-4cf3-4286-8428-8b846270e16f guid resource Служебные