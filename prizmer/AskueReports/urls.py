# -*- coding: utf-8 -*-
from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
from . import views

urlpatterns = [

    url(r'^1/$', views.report_3_tarifa_k, name = '1'),
    url(r'^2/$', views.pokazania, name = '2'),
    url(r'^3/$', views.pokazania_period, name = '3'),
    url(r'^4/$', views.profil_30_min, name = '4'),
    url(r'^6/$', views.report_hour_increment, name = '6'),
    url(r'^7/$', views.report_economic_electric, name = '7'),
    url(r'^8/$', views.report_rejim_day, name = '8'),
    url(r'^9/$', views.report_resources_all, name = '9'),

    url(r'^12/$', views.report_pokazaniya_water_identificators, name = '12'),
    url(r'^14/$', views.report_electric_simple_2_zones_v2, name = '14'), # Электрика. Простой отчет по показаниям на дату. 2 Тарифа
    url(r'^16/$', views.report_electric_simple_3_zones_v2, name = '16'), # Электрика. Простой отчет по показаниям на дату. 3 Тарифа
    url(r'^15/$', views.report_electric_potreblenie_2_zones, name = '15'), # Электрика. Отчет по потреблению за период по двум датам. 2 Тарифа.
    url(r'^17/$', views.report_electric_potreblenie_3_zones_v2, name = '17'), # Электрика. Отчет по потреблению за период по двум датам. 3 Тарифа.

    url(r'^18/$', views.pokazaniya_heat_report_v2, name = '18'), # Тепло. Простой отчет по показаниям на дату.
    url(r'^19/$', views.report_potreblenie_heat_v2, name = '19'), # Тепло. Отчет по потреблению за период.
    url(r'^20/$', views.pokazaniya_heat_current_report_v2, name = '20'), # Тепло. Простой отчет по показаниям. Последние считанные данные.
    url(r'^25/$', views.electric_between_report, name = '25'), # Электрика, показания на даты С date_start ПО date_end
    url(r'^27/$', views.electric_between_2_zones_report, name = '27'), # Электрика, показания на даты С date_start ПО date_end
    url(r'^29/$', views.electric_between_3_zones_report, name = '29'), # Электрика, показания на даты С date_start ПО date_end
    url(r'^26/$', views.pokazaniya_water_current_report, name = '26'),#текущие(последние считанные) показания для Эльфов ГВС и ХВС
    url(r'^28/$', views.pokazaniya_water_daily_report, name = '28'),# показания на дату  для Эльфов ГВС и ХВС
    url(r'^30/$', views.report_pokazaniya_sayany, name = '30'), # показания на дату. Тепло. Саяны
   
    url(r'^31/$', views.report_electric_potreblenie_2_zones_v2, name = '31'), # Электрика. Отчет по потреблению за период по двум датам. 2 Тарифа.
    
    url(r'^32/$', views.report_sayany_last, name = '32'), #показания по теплосчётчикам Саяны последние считанные от требуемой даты
    url(r'^33/$', views.report_heat_potreblenie_sayany, name = '33'), # расход по теплосчётчикам Саяны по двум датам
    
    url(r'^34/$', views.report_water_tekon_hvs, name = '34'), # показжания на дату по теплосчётчикам Текон-хвс
    url(r'^35/$', views.report_water_potreblenie_tekon_hvs, name = '35'), # расход по теплосчётчикам Текон-хвс по двум датам
    url(r'^36/$', views.report_water_tekon_gvs, name = '36'), # показжания на дату по теплосчётчикам Текон-гвс
    url(r'^37/$', views.report_water_potreblenie_tekon_gvs, name = '37'), # расход по теплосчётчикам Текон-гвс по двум датам
    
    url(r'^38/$', views.report_water_by_date, name = '38'), #для Фили, выгрузка данных на дату по воде Импульсные
    url(r'^39/$', views.report_water_potreblenie_pulsar, name = '39'), #для Фили, выгрузка данных за период по воде Импульсные
    url(r'^41/$', views.report_forma_80020_fast, name = '41'), #Выгрузка архива с файлами xml по форме Мосэнергосбыт 80020
    
    url(r'^42/$', views.report_all_res_by_date, name = '42'), #отчёт по всем ресурсам на дату
    url(r'^44/$', views.report_electric_all_by_date, name = '44'), #отчёт электрике ресурсам на дату
    url(r'^46/$', views.report_water_all_by_date, name = '46'), #отчёт воде ресурсам на дату
    url(r'^48/$', views.report_heat_all_by_date, name = '48'), #отчёт по теплу ресурсам на дату

    url(r'^50/$', views.report_tekon_heat_by_date, name = '50'), # показания по теплу -Текон 
    url(r'^51/$', views.report_tekon_heat_potreblenie, name = '51'), # потребление по теплу -Текон 
    
    url(r'^52/$', views.report_elf_hvs_by_date, name = '52'), # показания по хвс -Эльф 
    url(r'^53/$', views.report_elf_hvs_potreblenie, name = '53'), # потребление по хвс -Эльф 
    url(r'^54/$', views.report_elf_gvs_by_date, name = '54'), # показания по гвс -Эльф 
    url(r'^55/$', views.report_elf_gvs_potreblenie, name = '55'), # потребление по гвс -Эльф 
    
    url(r'^56/$', views.report_pulsar_heat_daily, name = '56'), # Показание на дату с теплосчётчиков Пульсар
    url(r'^59/$', views.report_pulsar_heat_period, name = '59'), # Показание на дату с теплосчётчиков Пульсар
    
    url(r'^57/$', views.report_pulsar_water_period, name = '57'), # Показание за период с водосчётчиков Пульсар
    url(r'^58/$', views.report_pulsar_water_daily, name = '58'), # Показание на дату с водосчётчиков Пульсар
    
    url(r'^60/$', views.report_pulsar_water_daily_row, name = '60'),# Показания по стоякам в одну строку на дату с водосчётчиков Пульсар   
    
    url(r'^62/$', views.report_pulsar_heat_daily_2, name = '62'), # Показание на дату с теплосчётчиков Пульсар
    url(r'^61/$', views.report_pulsar_heat_period_2, name = '61'), # Показание за период  с теплосчётчиков Пульсар
    
    url(r'^63/$', views.report_heat_elf_period_2, name = '63'), # Показание за период Эльф-тепло
    url(r'^64/$', views.report_heat_elf_daily, name = '64'), # Показание на дату Эльф-тепло 
    
    url(r'^66/$', views.report_heat_water_elf_daily, name = '66'), # Показание на дату Эльф-тепло и вода
    
    url(r'^67/$', views.report_water_pulsar_potreblenie_skladochnaya, name = '67'), #skladochnaya - otch`t za period
    
    url(r'^68/$', views.report_rejim_electro, name = '68'), #отчёт-режимный день
    url(r'^69/$', views.electric_between_3_zones_report, name = '69'), #отчёт как 29
    url(r'^71/$', views.report_forma_80040, name = '71'), #Выгрузка архива с файлами xml по форме Мосэнергосбыт 80040
   
    url(r'^72/$', views.report_electric_simple_3_zones_v2, name = '72'),

    url(r'^73/$', views.report_pulsar_water_period, name = '73'), # отчёт 57, Показание за период с водосчётчиков Пульсар
    #url(r'^74/$', views.report_current_3_zones_v2), # Электрика. Простой отчет по показаниям на дату. 3 Тарифа   
    url(r'^74/$', views.report_heat_karat_daily, name = '74'), #karat307 pokazaniya
    url(r'^75/$', views.report_heat_karat_potreblenie, name = '75'),#karat307 potreblenie
    
    url(r'^40/$', views.report_empty_alert, name = '40'),

    url(r'^76/$', views.report_all_res_by_date_v2, name = '76'),
    url(r'^77/$', views.report_balance_period_electric, name = '77'),
   
    
    url(r'^79/$', views.report_water_potreblenie_pulsar, name = '79'), #выгрузка данных за период по воде Импульсные
    
    url(r'^81/$', views.report_pulsar_heat_period, name = '81'), # Показание за период с теплосчётчиков Пульсар
    
    url(r'^83/$', views.report_water_elf_potreblenie_monthly_with_delta, name = '83'), # Потребление по месяцам с эльфов хв и гв
    url(r'^84/$', views.report_water_elf_daily, name = '84'), # 
    url(r'^85/$', views.report_water_elf_potreblenie, name = '85'), # Потребление за период с эльфов хв и гв
    
    url(r'^86/$', views.report_electric_res_status, name = '86'),
    url(r'^88/$', views.report_heat_res_status, name = '88'),

    url(r'^89/$', views.report_electric_report_for_c300, name = '89'), #отчёт по потрелениею элеткричества для ботсада в csv

    url(r'^90/$', views.report_water_impulse_res_status, name = '90'),
    
    url(r'^91/$', views.report_electric_potreblenie_3_zones_v2, name = '91'), # отчёт 17, Электрика. Отчет по потреблению за период по двум датам. 3 Тарифа.
    
    url(r'^87/$', views.report_balance_period_water_impulse, name = '87'), 
    url(r'^92/$', views.report_empty_alert, name = '92'), 

    url(r'^93/$', views.report_water_impulse_report_for_c300, name = '93'), #отчёт по потрелениею элеткричества для ботсада в csv

    url(r'^94/$', views.report_water_digital_pulsar_res_status, name = '94'),

    url(r'^95/$', views.electric_period_graphic_activ_reactiv_report, name = '95'), #отчёт профиль r+ a+ за период с дельтами

    url(r'^98/$', views.electric_restored_activ_reactiv_daily_report, name = '98'), #отчёт профиль r+ a+ на дату восстанволеный через получасовки
    
    url(r'^99/$', views.electric_period_30_report, name = '99'), #отчёт по получасовкам за период

    url(r'^97/$', views.heat_danfoss_period_report, name = '97'), #показания по теплу данфосс - доделать
    url(r'^100/$', views.heat_danfoss_daily_report, name = '100'), #показания по теплу данфосс - доделать

    url(r'^101/$', views.water_consumption_impuls_report, name = '101'), # вода, показания за период Импульсные для мантулинской
    
    url(r'^102/$', views.report_electric_3_zones, name = '102'), # *Показания по электричеству на дату. 3 тарифа с комментарием
    url(r'^104/$', views.report_electric_2_zones, name = '104'), # *Показания по электричеству на дату. 2 тарифа с комментарием
    url(r'^106/$', views.report_electric_1_zones, name = '106'), # *Показания по электричеству на дату. 1 тариф с комментарием

    url(r'^103/$', views.report_electric_consumption_2_zones, name = '103'), #*Потребление за период 2 тарифа
    url(r'^105/$', views.report_electric_consumption_1_zone, name = '105'), #*Потребление за период 1 тариф

    url(r'^108/$', views.report_electric_podolsk, name = '108'), # Показания по электричеству на дату. Подольск
    url(r'^107/$', views.report_electric_consumption_podolsk, name = '107'), #Потребление за период 2 тарифа Подольск

    url(r'^109/$', views.report_water_tem104_consumption, name = '109'), #*потребеление по воде ТЭМ-104
    url(r'^110/$', views.report_water_tem104_daily, name = '110'), #*показания по воде ТЭМ-104 на дату
    url(r'^111/$', views.report_heat_tem104_consumption, name = '111'), #*потребеление по теплу ТЭМ-104
    url(r'^112/$', views.report_heat_tem104_daily, name = '112'), #*показания по теплу ТЭМ-104 на дату

    url(r'^113/$', views.report_electric_potreblenie_3_zones_v2, name = '113'), # отчёт - Электрика. Отчет по потреблению за период по двум датам. 3 Тарифа.

    url(r'^114/$', views.report_electric_3_zones_v2, name = '114'), # *Показания по электричеству на дату. 3 тарифа

    url(r'^115/$', views.report_stk_heat_period, name = '115'), # Потребление за период с теплосчётчиков Пульс СТК
    url(r'^116/$', views.report_stk_heat_daily, name = '116'), # Показание на дату с теплосчётчиков Пульс СТК

    url(r'^118/$', views.report_pulsar_frost_daily, name = '118'), # Показание на дату с холодосчётчика Пульсар
    url(r'^117/$', views.report_pulsar_frost_period, name = '117'), # Потребление за период с холодосчётчиков Пульсар

    url(r'^120/$', views.report_electric_by_day_for_year, name = '120'), # Показание на выбранный день за каждый месяц в течении года по электрике'. Цифровые приборы(!)
    url(r'^122/$', views.report_water_by_day_for_year, name = '122'), # Показание на выбранный день за каждый месяц в течении года по всем воде. Цифровые приборы(!)
    url(r'^124/$', views.report_heat_by_day_for_year, name = '124'), # Показание на выбранный день за каждый месяц в течении года по всем теплу. Цифровые приборы(!)

    url(r'^126/$',views.electric_interval_month_hours, name = '126'), # Часовки за месяц по электрике
    url(r'^128/$',views.electric_integral_month_hours, name = '128'), # акт по потреблению за месяц

    url(r'^132/$', views.report_pulsar_water_impulse_daily_row, name = '132'),# Показания по стоякам в одну строку на дату с регистратора импульсов   

    # Наличие в комментарии *, говорит о том, что он реагирует на свойства SHOW_LIC_NUM,SEPARATOR и ROUND_SIZE
]
