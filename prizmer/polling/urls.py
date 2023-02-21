# coding -*- coding: utf-8 -*-
from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
from . import views

urlpatterns = [

    url(r'^current_m230/$', views.current_m230, name = 'current_m230'), #Чтение текущих с 230
    url(r'^set_power_on/$', views.power_on, name = 'power_on'), #Включение нагрузки
    url(r'^set_power_off/$', views.power_off, name = 'current_power_off'), #Выключение нагрузки
    url(r'^set_active_power_limit_value/$', views.set_active_power_limit_value, name = 'set_active_power_limit_value'), #Установка значения на ограничение мощности
    url(r'^get_active_power_limit_value/$', views.get_active_power_limit_value, name = 'get_active_power_limit_value'), #Чтение значения на ограничение мощности
]
