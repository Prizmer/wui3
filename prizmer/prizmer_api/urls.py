from django.conf.urls import *

from django.contrib import admin
admin.autodiscover()
# from . import views
from prizmer_api.views import ObjectsAPIView
from prizmer_api.views import AllMetersDataAPIView, AllInactiveParamsAPIView, AllMetersDataStatusAPIView, AllMetersDataIdAPIView

urlpatterns = [

    url(r'^v1/test_api/$', ObjectsAPIView.as_view(), name = 'test_api'), # Ссылка для теста API
    url(r'^v1/all_meters_data/$', AllMetersDataStatusAPIView.as_view(), name = 'all_meters_data_with_status'), # все актуальные данные на дату
    url(r'^v1/all_inactive_meters_data/$', AllInactiveParamsAPIView.as_view(), name = 'all_inactive_meters_data'), # для неактивных параметров. значение и дата последнего опроса.
    url(r'^v1/all_meters_data_with_id_only_digital/$', AllMetersDataIdAPIView.as_view(), name = 'all_meters_data_with_id'), # все актуальные данные на дату с id и единицами измерения


]