# coding -*- coding: utf-8 -*-
from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
from . import views
 

urlpatterns = [
    url(r'^$', views.default, name = 'default'),
    url(r'^tree_data/$', views.tree_data_json_v2, name = 'tree_data'),
    url(r'^get_object_title/$', views.get_object_title, name = 'get_obj_title'),
    url(r'^get_object_key/$', views.get_object_key, name = 'get_obj_key'),
    url(r'^get_data_table/$', views.get_data_table, name = 'get_data_table'),
    #url(r'^export_excel_electric/$', views.export_excel_electric, name = 'export_excel_electric'),
    url(r'^electric/$', views.electric, name = 'electric'),
    url(r'^economic/$', views.economic, name = 'economic'),
    url(r'^water/$', views.water, name = 'water'),
    url(r'^heat/$', views.heat, name = 'heat'),
    url(r'^gas/$', views.gas, name = 'gas'),
    url(r'^comment/$', views.comment, name = 'comment'),
    url(r'^add_comment/$', views.add_comment, name = 'add_comment'),
    url(r'^load_comment/$', views.load_comment, name = 'load_comment'),
    url(r'^del_comment/$', views.del_comment, name = 'del_comment'),
    url(r'^instruction_user/$', views.instruction_user, name = 'instruction_user'),
    url(r'^instruction_admin/$', views.instruction_admin, name = 'instruction_admin'),
    url(r'^exit/$', views.go_out, name = 'exit'),
    url(r'^meter_info/$', views.meter_info, name = 'meter_info'), #При нажатии на прибор выводится подробная информация по нему
    url(r'^extended_info/$', views.extended_info, name = 'extended_info'), #Расширенная информация по потреблению прибора за период


    # Отчеты. Чётные - один календарь. Нечётные - два календаря.
    url(r'^0/$', views.choose_report, name = 'choose_report'), # Выберите отчет
    url(r'^1/$', views.data_table_3_tarifa_k, name = 'dt_3tarifa'), # Потребление за период по T0 A+ и T0 R+ с учётом коэфф.-не переделывала
    url(r'^2/$', views.report_2, name = 'old_rep'), # Простой отчёт-не переделывала
    url(r'^3/$', views.data_table_period_3_tarifa, name = 'dt_period_3tarifa'), # показания за период. 3 тарифа-не переделывала

    url(r'^4/$', views.profil_30_aplus, name = 'profil_20_a_plus'), #получасовки-не переделывала
    url(r'^6/$', views.hour_increment, name = 'hour_increment'), #часовые приращения энергии-не переделывала
    url(r'^7/$', views.economic_electric, name = 'economic_electric'), #удельный расход электроэнергии-не переделывала
    url(r'^8/$', views.rejim_day, name = 'rejim_day'), #режимный день-не переделывала
    url(r'^9/$', views.resources_all, name = 'resources_all'), #для ФилиГрад, отчёт по всем ресурсам за период
    url(r'^10/$', views.pokazaniya_water, name = 'water'), # показания по воде-не переделывала
    url(r'^11/$', views.potreblenie_water, name = 'period_water'), # потребление по воде-не переделывала
    url(r'^12/$', views.pokazaniya_water_identificators, name = 'water_identificators'), # потребление по воде с идентификаторами-не переделывала
    url(r'^26/$', views.pokazaniya_water_gvs_hvs_current, name = 'water_hvs_gvs_current'), # показания по ГВС и ХВС последние считанные 
    url(r'^28/$', views.pokazaniya_water_gvs_hvs_daily, name = 'water_hvs_gvs_daily'), # показания по ГВС и ХВС
    
    url(r'^24/$', views.load_balance_groups, name = 'load_balance_group'), # прогрузка балансных групп

    url(r'^14/$', views.electric_simple_2_zones_v2, name = 'electric_2zone'), # Показания по электричеству на дату. 2 тарифа
    url(r'^16/$', views.electric_simple_3_zones_v2, name = 'electric_3zone'), # Показания по электричеству на дату. 3 тарифа
    url(r'^17/$', views.electric_potreblenie_3_zones_v2, name = 'electric_period_3zone'), # Потребление по электричеству за период. 3 тарифа
    
    url(r'^18/$', views.pokazaniya_heat_v2, name = 'heat'), # показания по теплу
    url(r'^19/$', views.potreblenie_heat_v2, name = 'period_heat'), # потребление по теплу
    url(r'^20/$', views.pokazaniya_heat_current_v2, name = 'heat_current'), # текущие показания по теплу

    url(r'^22/$', views.pokazaniya_spg, name = 'spg'), #показания суточные по СПГ
    #url(r'^23/$', views.test_test, name = 'test'),

    url(r'^25/$', views.electric_between, name = 'electric_between'), #срез показаний С date_start ПО date_end
    url(r'^27/$', views.electric_between_2_zones, name = 'electric_between_2zone'), #срез показаний С date_start ПО date_end
    url(r'^29/$', views.electric_between_3_zones, name = 'electric_between_3zone'), #срез показаний С date_start ПО date_end
    url(r'^30/$', views.pokazaniya_sayany_v2, name = 'sayany'), #показания по теплосчётчикам Саяны
    
    url(r'^31/$', views.electric_potreblenie_2_zones_v2, name = 'period_electric_2zone'), # Потребление по электричеству за период. 3 тарифа
    
    url(r'^32/$', views.pokazaniya_sayany_last, name = 'sayany_last'), #показания по теплосчётчикам Саяны последние считанные от требуемой даты
    url(r'^33/$', views.heat_potreblenie_sayany, name = 'period_sayany'), #потребление по теплосчётчикам Саяны за период
    
    url(r'^34/$', views.pokazaniya_water_hvs_tekon, name = 'water_hvs_tekon'), # показания по ХВС -Текон
    url(r'^35/$', views.water_potreblenie_hvs_tekon, name = 'period_water_hvs_tekon'), # потребление по ХВС -Текон за период
    url(r'^36/$', views.pokazaniya_water_gvs_tekon, name = 'water_gvs_tekon'), # показания по ХВС -Текон
    url(r'^37/$', views.water_potreblenie_gvs_tekon, name = 'period_water_gvs_tekon'), # потребление по ХВС -Текон за период
    
    url(r'^38/$', views.water_by_date, name = 'water_by_date'), # вода, показания на дату
    url(r'^39/$', views.water_potreblenie_pulsar, name = 'period_water_pulsar_imp'), # вода, показания за период Импульсные 
    
    url(r'^40/$', views.electric_check_factory_numbers, name = 'electric_chec_factory_numbers'), # Сверка заводских номеров приборов
    url(r'^41/$', views.forma_80020_v2, name = 'report_80020'), # Отчёт по форме 80020
    
    url(r'^42/$', views.resources_all_by_date, name = 'res_all_by_date'), # Отчёт по всем ресурсам на дату
    url(r'^44/$', views.resources_electric_by_date, name = 'res_electric_by_date'), # Отчёт по электрике
    url(r'^46/$', views.resources_water_by_date, name = 'res_water_by_date'), # Отчёт по воде
    url(r'^48/$', views.resources_heat_by_date_2, name = 'res_heat_by_date2'), # Отчёт по теплу за последнюю дату для бухгалтерии
    
    url(r'^50/$', views.tekon_heat_by_date, name = 'heat_tekon'), # показания по теплу -Текон 
    url(r'^51/$', views.tekon_heat_potreblenie, name = 'period_heat_tekon'), # потребление по теплу -Текон 
    
    url(r'^52/$', views.water_elf_hvs_by_date, name = 'water_elf_hvs'), # показания по хвс -Эльф 
    url(r'^53/$', views.water_elf_hvs_potreblenie, name = 'period_water_elf_hvs'), # потребление по хвс -Эльф 
    url(r'^54/$', views.water_elf_gvs_by_date, name = 'water_elf_gvs'), # показания по гвс -Эльф 
    url(r'^55/$', views.water_elf_gvs_potreblenie, name = 'period_water_elf_gvs'), # потребление по гвс -Эльф

    url(r'^56/$', views.pulsar_heat_daily, name = 'heat_pulsar'), # Показание на дату с теплосчётчиков Пульсар
    url(r'^59/$', views.pulsar_heat_period, name = 'period_heat_pulsar'), # Потребление за период с теплосчётчиков Пульсар
    url(r'^62/$', views.pulsar_heat_daily_2, name = 'heat_pulsar2'), # Показание на дату с теплосчётчиков Пульсар
    url(r'^61/$', views.pulsar_heat_period_2, name = 'period_heat_pulsar'), # Показание на дату с теплосчётчиков Пульсар
    
    url(r'^57/$', views.pulsar_water_period, name = 'period_water_pulsar'), # Показание за период с водосчётчиков Пульсар
    url(r'^58/$', views.pulsar_water_daily, name = 'water_pulsar'), # Показание на дату с водосчётчиков Пульсар
    
    url(r'^60/$', views.pulsar_water_daily_row, name = 'water_pulsar_row'), # Показания по стоякам в одну строку на дату с водосчётчиков Пульсар  
    
    url(r'^63/$', views.heat_elf_period, name = 'period_heat_elf'), # Показание за период Эльф-тепло
    url(r'^64/$', views.heat_elf_daily, name = 'heat_elf'), # Показание на дату Эльф-тепло 
    
    url(r'^66/$', views.heat_water_elf_daily, name = 'heat_water_elf'), # Показание на дату по Эльф-тепло и вода
    
    url(r'^67/$', views.water_pulsar_potreblenie_skladochnaya, name = 'period_water_pulsar_castom'),#67. Складочная. Потребление ХВС, ГВС (с водосчётчика Пульсар)
    
    url(r'^68/$', views.rejim_day, name = 'electric_rejim_day'), #режимный день
    
    url(r'^69/$', views.electric_daily_graphic, name = 'electric_daily_graphic'), #график потребления электроэнергии по дням
    url(r'^71/$', views.forma_80040, name = 'report_80040'), # Отчёт по форме 80040

   
    url(r'^72/$', views.electric_simple_3_zones_v3, name = 'electric_3zone_v3'), # Показания по электричеству на дату. 3 тарифа
    url(r'^73/$', views.pulsar_water_period_2, name = 'period_water_pulsar_graphic'), # отчёт 57, но с графиком!  Показание за период с водосчётчиков Пульсар
    #url(r'^74/$', views.electric_current_3_zones_v2), # Показания текущие для М-200 по электричеству на дату. 3 тарифа
    
    url(r'^74/$', views.heat_karat_daily, name = 'heat_karat'),
    url(r'^75/$', views.heat_karat_potreblenie, name = 'period_heat_karat'),

    url(r'^76/$', views.all_res_by_date, name = 'all_res_by_date'), 
    url(r'^77/$', views.balance_period_electric_2, name = 'period_electric_balance'),

    url(r'^79/$', views.water_potreblenie_pulsar_with_graphic, name = 'period_water_pulsar_imp_graphic'), # вода, показания за период Импульсные, отчёт как 39
    
    url(r'^81/$', views.pulsar_heat_period_with_graphic, name = 'period_heat_pulsar_graphic'), # Показание на дату с теплосчётчиков Пульсар, отчёт как 59
    url(r'^83/$', views.water_elf_potreblenie_monthly_with_delta, name = 'period_water_elf_monthly_with_delta'), # Потребление по месяцам с эльфов хв и гв
    url(r'^84/$', views.water_elf_daily, name = 'water_elf'), # 
    url(r'^85/$', views.water_elf_potreblenie, name = 'period_water_elf'), # Потребление за период с эльфов хв и гв    
    
    url(r'^86/$', views.electric_res_status, name = 'electric_res_status'),

    url(r'^87/$', views.balance_period_water_impulse, name = 'period_balance_water_imp'),

    url(r'^88/$', views.heat_digital_res_status, name = 'heat_res_status'),
    url(r'^89/$', views.electric_report_for_c300, name = 'electric_report_for_c300'), #отчёт по потрелениею элеткричества для ботсада
    url(r'^90/$', views.water_impulse_res_status, name = 'water_imp_res_status'),
    
    url(r'^91/$', views.electric_potreblenie_3_zones_v3, name = 'period_electric_3zone_graphic'), # отчёт 17, но с графиком!! Потребление по электричеству за период. 3 тарифа

    url(r'^92/$', views.all_res_status_monthly, name = 'all_res_status_monthly'),

    url(r'^93/$', views.water_impulse_report_for_c300, name = 'water_impulse_report_for_c300'), #отчёт по потрелению воды для ботсада

    url(r'^94/$', views.water_digital_pulsar_res_status, name = 'water_pulsar_res_status'), 

    url(r'^95/$', views.electric_period_graphic_activ_reactiv, name = 'period_electric_activ_reactiv_graphic'), #график потребления электроэнергии по дням 3 тарифа R+ A+
    url(r'^96/$', views.water_current_impulse, name = 'water_imp_current'), #текущие по воде-импульсные ПУ
    
    url(r'^97/$', views.heat_danfoss_period, name = 'period_heat_danfoss'), #потребление по теплу данфосс -доделать

    url(r'^98/$', views.electric_restored_activ_reactiv_daily, name = 'electric_restored_activ_reactive_daily'), #восстановленый суточный срез из получасовок
    
    url(r'^99/$', views.electric_period_30, name = 'electric_period_30'), #вывод всех получасовок за период

    url(r'^100/$', views.heat_danfoss_daily, name = 'heat_danfoss'), #показания по теплу данфосс -
   #---- Test urls
    url(r'^addnum/$', views.add_numbers, name = 'add_numbers'),

    url(r'^101/$', views.water_consumption_impuls, name = 'period_water_imp_castom'), # вода, показания за период Импульсные для мантулинской

    url(r'^102/$', views.electric_3_zones, name = 'electric_3_zones'), # Показания по электричеству на дату. 3 тарифа с комментарием
    url(r'^104/$', views.electric_2_zones, name = 'electric_2_zones'), # Показания по электричеству на дату. 2 тарифа с комментарием
    url(r'^106/$', views.electric_1_zones, name = 'electric_1_zones'), # Показания по электричеству на дату. сумма с комментарием
    
    url(r'^103/$', views.electric_consumption_2_zones, name = 'electric_consumption_2_zones'), 
    url(r'^105/$', views.electric_consumption_1_zone, name = 'electric_consumption_1_zone'),

    url(r'^108/$', views.electric_by_date_podolsk, name = 'electric_by_date_podolsk'), #отчёт для Подольска по электрике на дату
    url(r'^107/$', views.electric_consumption_podolsk, name = 'electric_consumption_podolsk'),#отчёт для Подольска по электрике за период

    url(r'^109/$', views.water_tem104_consumption, name = 'water_tem104_consumption'), #потребеление по воде ТЭМ-104
    url(r'^110/$', views.water_tem104_daily, name = 'water_tem104_daily'), #показания по воде ТЭМ-104 на дату
    url(r'^111/$', views.heat_tem104_consumption, name = 'heat_tem104_consumption'), #потребеление по теплу ТЭМ-104
    url(r'^112/$', views.heat_tem104_daily, name = 'heat_tem104_daily'), #показания по теплу ТЭМ-104 на дату

    url(r'^113/$', views.electric_consumption_3_zones_with_limit, name = 'electric_consumption_with_limit'), # Потребление по электричеству за период. 3 тарифа с выделением строк, где потребление было меньше порога

    url(r'^114/$', views.electric_3_zones_v2, name = 'electric_3_zones_v2'), # Показания по электричеству на дату. 3 тарифа с комментарием + выгрузка в эксель с именем объекта

    url(r'^115/$', views.stk_heat_period, name = 'period_heat_stk'), # Потребление за период с теплосчётчиков Пульс СТК
    url(r'^116/$', views.stk_heat_daily, name = 'heat_stk'), # Показания на дату теплосчётчиков Пульс СТК

    url(r'^118/$', views.pulsar_frost_daily, name = 'frost_pulsar'), # Показание на дату с холодосчётчиков Пульсар
    url(r'^117/$', views.pulsar_frost_period, name = 'period_frost_pulsar'), # Потребление за период с холодосчётчиков Пульсар

    url(r'^120/$', views.all_res_by_day_for_year, name = 'all_res_by_day_for_year'), # Показание на выбранный день за каждый месяц в течении года по электрике Цифровые приборы(!)
    url(r'^122/$', views.all_res_by_day_for_year, name = 'all_res_by_day_for_year'), # Показание на выбранный день за каждый месяц в течении года по воде. Цифровые приборы(!)
    url(r'^124/$', views.all_res_by_day_for_year, name = 'all_res_by_day_for_year'), # Показание на выбранный день за каждый месяц в течении года по теплу. Цифровые приборы(!)

    url(r'^126/$', views.electric_interval_month_hours, name = 'electric_interval_month_hours'), # Часовки за месяц по электрике. Интервальный акт = дубининская
    url(r'^128/$', views.electric_integral_month_hours, name = 'electric_integral_month_hours'), # Часовки за месяц по электрике. Интегральный акт = дубининская

    url(r'^130/$', views.pulsar_heat_error_code, name = 'pulsar_heat_error_code'), # Коды ошибок с теплосчётчиков Пульсар

    url(r'^132/$', views.pulsar_water_impulse_daily_row, name = 'water_impulse_pulsar_row'), # Показания по стоякам в одну строку на дату с регистраторов Пульсар (аналог отчёта60, но импульс)

    url(r'^133/$', views.danfoss_water_impulse_consumption, name = 'danfoss_water_impulse_consumption'), # Потребеление по водосчётчикам импульсным с каналов теплосчётчика Danfoss
    url(r'^134/$', views.danfoss_water_impulse_daily, name = 'danfoss_water_impulse_daily'), # показания по водосчётчикам импульсным с каналов теплосчётчика Danfoss

    url(r'^136/$', views.pulsar_water_from_heat_daily_row, name = 'water_from_heat_row'), # Показания по стоякам в одну строку на дату с Теплосчётчиков Пульсар (аналог отчётов 60,132)

    url(r'^137/$', views.pulsar_water_period_2_desc, name = 'period_water_pulsar_graphic_desc'), # Показание за период с водосчётчиков Пульсар, копия 73, но изменена сортировка ХВ-ГВ
    url(r'^138/$', views.pulsar_water_daily_desc, name = 'water_pulsar'), # Показание на дату с водосчётчиков Пульсар, копия 58, но изменена сортировка ХВ-ГВ
    
    url(r'^140/$', views.pulsar_water_battery, name = 'water_pulsar_battery'), # Вода, батарейка

    url(r'^141/$', views.econom_water_period, name = 'period_water_econom'), # Показание за период с водосчётчиков Эконом
    url(r'^142/$', views.econom_water_daily, name = 'water_econom'), # Показание на дату с водосчётчиков ЭкоНом
   
]
