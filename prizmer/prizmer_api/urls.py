from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
# from . import views
from prizmer_api.views import ObjectsAPIView
from prizmer_api.views import AllMetersDataAPIView

urlpatterns = [

    url(r'^v1/test_api/$', ObjectsAPIView.as_view(), name = 'test_api'), # Ссылка для теста API
    url(r'^v1/all_meters_data/$', AllMetersDataAPIView.as_view(), name = 'all_meters_data'), # Ссылка для теста API

]