-- Добавляем тип прибора ЭкоНом ХВС
INSERT INTO public.types_meters(
	guid, name, driver_name)
	VALUES ('50098019-7418-4661-baa9-b913de3596da', 'ЭкоНом ХВС', 'econom');

-- Добавляем тип прибора ЭкоНом ГВС
INSERT INTO public.types_meters(
	guid, name, driver_name)
	VALUES ('e2e6c4c5-636a-432a-bdbf-6a5ab4b1fdee', 'ЭкоНом ГВС', 'econom');
	
-- Добавляем тип прибора ЭкоНом Теплосчётчик
INSERT INTO public.types_meters(
	guid, name, driver_name)
	VALUES ('aefa5648-2240-42b4-88cf-04b093a60187', 'ЭкоНом Теплосчётчик', 'econom');