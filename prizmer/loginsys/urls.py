# -*- coding: utf-8 -*-

from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()

from django.contrib.staticfiles.urls import staticfiles_urlpatterns
import loginsys.views

urlpatterns = [
    # Examples:
   url(r'^login/$', loginsys.views.login, name = 'login'),
   url(r'^logout/$', loginsys.views.logout, name = 'logout'),
]

urlpatterns += staticfiles_urlpatterns()