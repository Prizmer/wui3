-- sql/fill_report_configs.sql

-- Электричество
INSERT INTO report_configs (guid, number, name, guid_resources, show_lic_num, separator, round_size, comment_to_excel, show_stoyak, show_floors, num_is_string, null_field, order_fields, order_direction, is_active)
VALUES
(gen_random_uuid(), 1,  'Потребление за период по T0 A+ и T0 R+',           (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 2,  'Простой отчёт',                                    (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 3,  'Показания за период. 3 тарифа',                    (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 4,  'Получасовки',                                      (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 6,  'Часовые приращения энергии',                       (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 7,  'Удельный расход электроэнергии',                   (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 8,  'Режимный день',                                    (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 14, 'Показания по электричеству на дату. 2 тарифа',     (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 16, 'Показания по электричеству на дату. 3 тарифа',     (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 17, 'Потребление по электричеству за период. 3 тарифа', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 25, 'Срез показаний электричество',                     (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 27, 'Срез показаний электричество 2 зоны',              (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 29, 'Срез показаний электричество 3 зоны',              (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 31, 'Потребление по электричеству за период. 2 тарифа', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 40, 'Сверка заводских номеров приборов',                (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 41, 'Отчёт по форме 80020',                             (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 44, 'Отчёт по электричеству на дату',                   (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 68, 'Режимный день электричество',                      (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 69, 'График потребления электроэнергии по дням',        (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 71, 'Отчёт по форме 80040',                             (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 72, 'Показания по электричеству на дату. 3 тарифа v3',  (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 77, 'Потребление за период электричество баланс',       (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 86, 'Статистика опросов. Электричество',                (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 89, 'Отчёт по потреблению электричества для ботсада',   (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 91, 'Потребление по электричеству за период. 3 тарифа (с графиком)', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 95, 'График потребления электроэнергии по дням 3 тарифа R+ A+', (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 98, 'Восстановленный суточный срез из получасовок',     (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 99, 'Вывод всех получасовок за период',                 (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 102, 'Показания по электричеству на дату. 3 тарифа с комментарием', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, true,  false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 103, 'Потребление по электричеству 2 зоны',            (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 104, 'Показания по электричеству на дату. 2 тарифа с комментарием', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, true,  false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 105, 'Потребление по электричеству 1 зона',            (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 106, 'Показания по электричеству на дату. 1 зона с комментарием', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, true,  false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 107, 'Потребление по электричеству для Подольска',     (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 108, 'Показания по электричеству на дату для Подольска', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 113, 'Потребление за период. 3 тарифа', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 114, 'Показания на дату. 3 тарифа', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, true,  false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 120, 'Показания на выбранный день за год по электричеству', (SELECT guid FROM resources WHERE name = 'Электричество'), true,  ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 126, 'Часовки за месяц по электричеству. Интервальный акт', (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 128, 'Часовки за месяц по электричеству. Интегральный акт', (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 143, 'Анализ потребления по получасовкам за период',   (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 148, 'Отчёт по потреблению для мос.электрики на Дискавери', (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 172, 'Электричество интегральный из шаблона',          (SELECT guid FROM resources WHERE name = 'Электричество'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false)
ON CONFLICT (number) DO NOTHING;


-- ХВС (все водные отчёты, кроме импульсных и холодосчётчиков)
INSERT INTO report_configs (guid, number, name, guid_resources, show_lic_num, separator, round_size, comment_to_excel, show_stoyak, show_floors, num_is_string, null_field, order_fields, order_direction, is_active)
VALUES
-- Общие водные отчёты
(gen_random_uuid(), 9,  'Отчёт по всем ресурсам за период',                 (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 10, 'Показания по воде',                                (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 11, 'Потребление по воде',                              (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 12, 'Потребление по воде с идентификаторами',           (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 26, 'Показания по ГВС и ХВС последние считанные',       (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 28, 'Показания по ГВС и ХВС',                           (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 42, 'Отчёт по всем ресурсам на дату',                   (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 46, 'Отчёт по воде на дату',                            (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 76, 'Все ресурсы на дату',                              (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 79, 'Потребление по воде за период импульсные (с графиком)', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 92, 'Статус всех ресурсов за месяц',                    (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 93, 'Отчёт по потреблению воды для ботсада',            (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 101, 'Потребление по воде за период импульсные для Мантулинской', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
-- Текон
(gen_random_uuid(), 34, 'Показания по ХВС Текон',                           (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 35, 'Потребление по ХВС Текон за период',               (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
-- Эльф
(gen_random_uuid(), 52, 'Показания по ХВС Эльф',                            (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 53, 'Потребление по ХВС Эльф',                          (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
-- ТЭМ-104
(gen_random_uuid(), 109, 'Потребление по воде ТЭМ-104',                      (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 110, 'Показания по воде ТЭМ-104 на дату',                (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
-- Пульсар вода
(gen_random_uuid(), 57, 'Потребление за период с водосчётчиков Пульсар',    (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 58, 'Показания на дату с водосчётчиков Пульсар',        (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 60, 'Показания по стоякам в одну строку с водосчётчиков Пульсар', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, true,  false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 66, 'Показания на дату по Эльф-тепло и вода',           (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 67, 'Потребление по стоякам в одну строку с водосчётчика Пульсар', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 73, 'Потребление за период с водосчётчиков Пульсар (с графиком)', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 83, 'Потребление по месяцам с эльфов ХВ и ГВ',          (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 84, 'Показания по воде Эльф',                           (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 85, 'Потребление за период с эльфов ХВ и ГВ',           (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 94, 'Статистика опросов. Вода цифровая',                (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 132, 'Показания по стоякам в одну строку на дату с регистраторов Пульсар (импульс)', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, true,  false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 137, 'Потребление за период с водосчётчиков Пульсар (копия 73)', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 138, 'Показания на дату с водосчётчиков Пульсар (копия 58)', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 139, 'Отчёт по потреблению для мосводоканала на Пресня-Сити', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 140, 'Вода батарейка Пульсар',                           (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 141, 'Потребление за период с водосчётчиков Эконом',     (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 142, 'Показания на дату с водосчётчиков Эконом',         (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 145, 'Отчёт по потреблению для мосводоканала на Дискавери', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 146, 'Отчёт по потреблению для мосводоканала на Дискавери из шаблона', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 147, 'Анализ потребления воды',                          (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 151, 'Показания на 2 даты ГВС и ХВС',                    (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 152, 'Показания на дату с водосчётчиков Пульсар (с этажами)', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, true,  false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 157, 'Потребление воды с приборов iot',                  (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 158, 'Показания воды с приборов iot',                    (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 173, 'Отчёт по воде по шаблону на 2 даты',               (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 176, 'Отчёт об ошибках и батарейке водосчётчика Пульсар', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
-- Ридан
(gen_random_uuid(), 166, 'Показания воды с приборов Ридан',                  (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 167, 'Потребление воды с приборов Ридан',                (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
-- Vzlet
(gen_random_uuid(), 170, 'Показания воды с приборов Vzlet',                  (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 171, 'Потребление воды с приборов Vzlet',                (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false)
ON CONFLICT (number) DO NOTHING;


-- ГВС
INSERT INTO report_configs (guid, number, name, guid_resources, show_lic_num, separator, round_size, comment_to_excel, show_stoyak, show_floors, num_is_string, null_field, order_fields, order_direction, is_active)
VALUES
(gen_random_uuid(), 36, 'Показания по ГВС Текон',                           (SELECT guid FROM resources WHERE name = 'ГВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 37, 'Потребление по ГВС Текон за период',               (SELECT guid FROM resources WHERE name = 'ГВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 54, 'Показания по ГВС Эльф',                            (SELECT guid FROM resources WHERE name = 'ГВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 55, 'Потребление по ГВС Эльф',                          (SELECT guid FROM resources WHERE name = 'ГВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false)
ON CONFLICT (number) DO NOTHING;


-- Холод (только холодосчётчики)
INSERT INTO report_configs (guid, number, name, guid_resources, show_lic_num, separator, round_size, comment_to_excel, show_stoyak, show_floors, num_is_string, null_field, order_fields, order_direction, is_active)
VALUES
(gen_random_uuid(), 117, 'Потребление за период с холодосчётчиков Пульсар', (SELECT guid FROM resources WHERE name = 'Холод'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 118, 'Показания на дату с холодосчётчиков Пульсар',     (SELECT guid FROM resources WHERE name = 'Холод'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 154, 'Показания с холодосчётчиков Пульсар',             (SELECT guid FROM resources WHERE name = 'Холод'), false, ',', 3, false, true,  false, false, 'Н/Д', '', 'asc', true)
ON CONFLICT (number) DO NOTHING;


-- Тепло
INSERT INTO report_configs (guid, number, name, guid_resources, show_lic_num, separator, round_size, comment_to_excel, show_stoyak, show_floors, num_is_string, null_field, order_fields, order_direction, is_active)
VALUES
(gen_random_uuid(), 18, 'Показания по теплу',                               (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 19, 'Потребление по теплу',                             (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 20, 'Текущие показания по теплу',                       (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 30, 'Показания по теплосчётчикам Саяны',                (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 32, 'Показания по теплосчётчикам Саяны последние считанные', (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 33, 'Потребление по теплосчётчикам Саяны за период',    (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 48, 'Отчёт по теплу за последнюю дату для бухгалтерии', (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 50, 'Показания по теплу Текон',                         (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 51, 'Потребление по теплу Текон',                       (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 56, 'Показания с теплосчётчиков Пульсар',               (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 59, 'Потребление за период с теплосчётчиков Пульсар',   (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 61, 'Показания на дату с теплосчётчиков Пульсар (копия 59)', (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 62, 'Показания на дату с теплосчётчиков Пульсар (копия 56)', (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 63, 'Потребление за период Эльф-тепло',                 (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 64, 'Показания на дату Эльф-тепло',                     (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 74, 'Показания по теплу Карат',                         (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false),
(gen_random_uuid(), 75, 'Потребление по теплу Карат',                       (SELECT guid FROM resources WHERE name = 'Тепло'), false, ',', 2, false, false, false, false, 'Н/Д', '', 'asc', false)
ON CONFLICT (number) DO NOTHING;


-- Экономика (статистика опросов)
INSERT INTO report_configs (guid, number, name, guid_resources, show_lic_num, separator, round_size, comment_to_excel, show_stoyak, show_floors, num_is_string, null_field, order_fields, order_direction, is_active)
VALUES
(gen_random_uuid(), 86, 'Статистика опросов. Электричество',                (SELECT guid FROM resources WHERE name = 'Служебные'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 88, 'Статистика опросов. Тепло',                        (SELECT guid FROM resources WHERE name = 'Служебные'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 94, 'Статистика опросов. Вода цифровая',                (SELECT guid FROM resources WHERE name = 'Служебные'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 90, 'Статистика опросов. Вода импульсная',              (SELECT guid FROM resources WHERE name = 'Служебные'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true)
ON CONFLICT (number) DO NOTHING;


-- Импульсная вода (отчёты с регистраторов импульсов)
INSERT INTO report_configs (guid, number, name, guid_resources, show_lic_num, separator, round_size, comment_to_excel, show_stoyak, show_floors, num_is_string, null_field, order_fields, order_direction, is_active)
VALUES
(gen_random_uuid(), 38, 'Показания по воде на дату с регистратора импульсов', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true),
(gen_random_uuid(), 39, 'Потребление по воде за период с регистратора импульсов', (SELECT guid FROM resources WHERE name = 'ХВС'), false, ',', 3, false, false, false, false, 'Н/Д', '', 'asc', true)
ON CONFLICT (number) DO NOTHING;

