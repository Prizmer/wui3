# coding -*- coding: utf-8 -*-
from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
from . import views

urlpatterns = [

    url(r'^current_m230/$', views.current_m230, name = 'current_m230'), #Удаление приборов из БД по прогрузочной ведомости
    
]
