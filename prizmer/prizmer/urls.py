"""prizmer URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
#from django.conf.urls import patterns, include, url
from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from django.views.generic import RedirectView

import general.views


urlpatterns =[ 
    url(r'^$', general.views.default, name = 'default'),
    url(r'^admin/', admin.site.urls, name = 'admin'),
    url(r'^auth/' , include('loginsys.urls'), name = 'auth'),
    url(r'^askue/' , include('general.urls'), name = 'askue'),
    url(r'^report/', include('AskueReports.urls'), name = 'report'),
    #url(r'^viz/', 'AskueViz.urls')),
    url(r'^exit/$', general.views.go_out, name = 'exit'),
    url(r'^service/', include('service.urls'), name = 'service'),
    url(r'^account/', include('account_prizmer.urls'), name = 'account'),
    url(r'polling/', include('polling.urls'), name = 'polling'),
    url(r'api/', include('prizmer_api.urls'), name = 'api'),

    url(r'^favicon\.ico$',RedirectView.as_view(url='/static/images/favicon.ico')),
]

urlpatterns += staticfiles_urlpatterns()
