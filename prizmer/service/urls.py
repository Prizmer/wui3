# coding -*- coding: utf-8 -*-
from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
from . import views

urlpatterns = [

    url(r'^config/$', views.choose_service, name = 'config'), # Выберите отчет
    url(r'^service_file/$', views.service_file, name = 'service_file'), # форма для загрузки файла на сервер
    url(r'^service_file_loading/$', views.service_file_loading, name = 'service_file_loading'), # загрузка файла на сервер
    url(r'^service_electric/$', views.service_electric, name = 'service_electric'), # электрика, загрузка нужных полей
    url(r'^service_electric_load/$', views.service_electric_load, name = 'service_electric_load'), # электрика прогрузка
    url(r'^load_tcp_ip/$', views.load_port, name = 'load_port'), # загрузка портов по элетрике
    url(r'^make_sheet/$', views.MakeSheet, name = 'make_sheet'), #возвращает список страниц в книге excel
    url(r'^load_electric_objects/$', views.load_electric_objects, name = 'load_electric_objects'), # загрузка объектов и абонентов
    url(r'^load_electric_counters/$', views.load_electric_counters, name = 'load_electric_counters'), # загрузка счётчиков
#    url(r'^electric/$', views.electric),
    url(r'^service_water/$', views.service_water, name = 'service_water'), # электрика, загрузка нужных полей
    url(r'^load_water_objects/$', views.load_water_objects, name = 'load_water_objects'), # вода, загрузка нужных полей
    url(r'^load_water_pulsar/$', views.load_water_pulsar, name = 'load_water_imp'), # вода, загрузка пульсаров и создание связей с абонентами
    url(r'^load_water_port/$', views.load_water_port, name = 'load_water_imp'), # загрузка портов из файла для воды
    
    url(r'^service_change_electric/$', views.change_meters_v2, name = 'change_meters'), # замена одного счётчика на другой
    url(r'^service_replace_electric/$', views.replace_electric_meters_v2, name = 'replace_electric_meters'), # поменять местами счётчики
    url(r'^service_get_info/$', views.get_info, name = 'service_get_info'), # 
    url(r'^get_electric_progruz/$', views.get_electric_progruz, name = 'get_lectric_pasport'), # прогрузочная ведомость в эксель
    url(r'^get_water_progruz/$', views.get_water_progruz, name = 'get_water_pasport'), # прогрузочная ведомость в эксель
    url(r'^get_water_impulse_progruz/$', views.get_water_impulse_progruz, name = 'get_water_imp_pasport'), # прогрузочная ведомость в эксель
    url(r'^get_heat_progruz/$', views.get_heat_progruz, name = 'get_heat_pasport'), # прогрузочная ведомость в эксель
    url(r'^load_balance_group/$', views.load_balance_group, name = 'load_balance_group'), # загрузка портов по электрике
    url(r'^service_balance_load/$', views.service_balance_load, name = 'balance_load'), #загрузка формы для прогрузки балансных групп

    url(r'^add_current_taken_params_pulsar16m/$', views.add_current_taken_params_pulsar16m, name = 'add_curr_taken_params_puls16m'), #загрузка формы для прогрузки балансных групп
    url(r'^get_electric_template/$', views.get_electric_template, name = 'get_electric_template'), #возвращает excel форму образец для прогрузочной ведомости
    url(r'^get_heat_template/$', views.get_heat_template, name = 'get_heat_template'), #возвращает excel форму образец для прогрузочной ведомости
    url(r'^get_water_digital_template/$', views.get_water_digital_template, name = 'get_water_digital_template'), #возвращает excel форму образец для прогрузочной ведомости
    url(r'^get_water_impulse_template/$', views.get_water_impulse_template, name = 'get_water_imp_template'), #возвращает excel форму образец для прогрузочной ведомости
    url(r'^get_balance_template/$', views.get_balance_template, name = 'get_balance_template'), #возвращает excel форму образец для прогрузочной ведомости
    
    url(r'^service_load30_page/$', views.service_load30_page, name = 'load30_page'), # загрузка страницы
    url(r'^service_load30/$', views.service_load30, name = 'load_30_html'), # загрузка получасовок в базу из html

    url(r'^service_user_account/$', views.service_user_account, name = 'service_user_account'), # страница для добавления пользователей личного кабинета
    url(r'^load_user_account/$', views.load_user_account, name = 'load_user_account'), # добавление аккаунтов пользователей личного кабинета
    url(r'^get_users_account_template/$', views.get_users_account_template, name = 'get_user_account_template'), #возвращает excel форму образец для прогрузочной ведомости get_users_account_template
    url(r'^service_del_meters/$', views.service_del_meters, name = 'del_meters'), # удаление приборов через прогрузочную ведомость

    url(r'^load_80020_group/$', views.load_80020_group, name = 'load_80020_group'), # удаление приборов через прогрузочную ведомость
    url(r'^get_80020_template/$', views.get_80020_template, name = 'get_80020_template'), #возвращает excel форму образец для прогрузочной ведомости
    
]
