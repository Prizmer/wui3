-- ЭкоНом ХВС Объем ХВС Суточный
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('4ff80736-bcc7-47e6-9314-e505b837191d', 'ЭкоНом ХВС Объем ХВС Суточный -- adress: 1  channel: 1', 1, 1, 'a49db310-391f-4479-b57d-aa7ac84dc2d8', '50098019-7418-4661-baa9-b913de3596da', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');
	
-- ЭкоНом ГВС Объем ГВС Суточный
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('9f280064-b8c7-4037-8a3c-617301221427', 'ЭкоНом ГВС Объем ГВС Суточный -- adress: 1  channel: 1', 1, 1, '1068fe5c-6de1-455e-8700-abd5ce98039c', 'e2e6c4c5-636a-432a-bdbf-6a5ab4b1fdee', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');
	
	
-- ЭкоНом Тепслосчётчик
-- Тепловая энергия
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('b22a28d0-9cb1-45eb-baba-5bb696ceb50d', 'ЭкоНом Теплосчётчик Энергия Суточный -- adress: 7  channel: 1', 7, 1, '64f9b17d-d599-428d-8849-5db3d37c7b0e', 'aefa5648-2240-42b4-88cf-04b093a60187', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');
	
-- Объем
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('4400f32c-9074-4838-93cf-7c7066f088f5', 'ЭкоНом Теплосчётчик Объем Суточный -- adress: 8  channel: 1', 8, 1, '092c67af-25ce-41ca-85ce-cb96953c930d', 'aefa5648-2240-42b4-88cf-04b093a60187', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');
	
-- Ti
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('5d9407e9-8ff7-4d8b-937e-d47edfe27e31', 'ЭкоНом Теплосчётчик Ti Суточный -- adress: 3  channel: 1', 3, 1, 'bb56b908-a67d-48f3-95c5-4c8eec379056', 'aefa5648-2240-42b4-88cf-04b093a60187', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');
	
-- To
INSERT INTO public.params(
	guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params)
	VALUES ('3c4bf80c-1a62-41ef-8bdd-9e9593ee0c56', 'ЭкоНом Теплосчётчик To Суточный -- adress: 4  channel: 1', 4, 1, '62bb153e-a48f-49c4-8628-39d0a3574aa4', 'aefa5648-2240-42b4-88cf-04b093a60187', 'bb986590-63cb-4b9f-8f4b-1b96335c5441');