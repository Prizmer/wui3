# -*- coding: utf-8 -*-
from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
from . import views

urlpatterns = [
    url(r'^$', views.account, name ='account'),
    url(r'^electric_info', views.electric_info, name ='electric_info'),
    url(r'^heat_info', views.heat_info, name ='heat_info'),
    url(r'^water_info', views.water_info, name ='water_info'),
    url(r'^exit', views.go_out, name ='exit'),

]
