from django.shortcuts import render
from rest_framework import generics

from general.models import  Objects
from prizmer_api.serializers import ObjectsSerializer

from rest_framework.response import Response
from rest_framework.views import APIView
from django.utils.datastructures import MultiValueDictKeyError

import common_sql
import json
import datetime

class ObjectsAPIView(generics.ListAPIView):
    queryset = Objects.objects.all()
    serializer_class = ObjectsSerializer
    print('Запрос файла')
    with open('api_request.txt', 'a') as f:
        f.write('HHello')
        



class AllMetersDataAPIView(APIView):
    def get(self, request):
        time_start = datetime.datetime.now()
        obj_parent = "Корпус 1"
        #date = "2023-07-11"
        try:
            # print('дата в запросе', request.GET["date"])
            date = request.GET["date"]
        except MultiValueDictKeyError:
            date = datetime.datetime.now().strftime('%Y-%m-%d')
        res = common_sql.get_all_meters_data_api(obj_parent, date)
        # print(res)
        new_res = []
        for item in res:
            new_res.append(list(item))
        
        res_list_of_dicts = []
        for item in new_res:
            temp_dict = {}
            temp_dict["address"] = item[0] +  "," + item[1]
            temp_dict["abonent"] = item[2]
            temp_dict["resourse"] = item[8]
            temp_dict["parametr"] = item[9]
            temp_dict["serial"] = item[7]
            temp_dict["value"]   = item[10]
            temp_dict["date"] = item[6]
            # print(temp_dict)
            res_list_of_dicts.append(temp_dict)



        # json_str = json.dumps(new_res, ensure_ascii=False)
        json_str = json.dumps(res_list_of_dicts, ensure_ascii=False)
        time_delta = datetime.datetime.now() - time_start
        print(time_delta)
        return Response(json.loads(json_str))
    
class AllInactiveParamsAPIView(APIView):
    """Последние считанные данные по параметрам."""
    def get(self, request):
        time_start = datetime.datetime.now()
        obj_parent = "Корпус 1"

        try:
            date = request.GET["date"]
        except MultiValueDictKeyError:
            date = datetime.datetime.now().strftime('%Y-%m-%d')

        inactive_taken_params = common_sql.get_all_taken_params_inactive_api(obj_parent, date)
        #print(inactive_taken_params)
        new_res = []
        for param in inactive_taken_params:
            # print(param[0])
            temp = common_sql.get_last_taken_params_values_api(param[0])
            print(temp)
            if temp:
                new_res.append(list(temp[0]))
        
        # for item in new_res:
        #     print(list(new_res[0][0]))
        #     print('------')

        res_list_of_dicts = []
        for item in new_res:
            temp_dict = {}
            temp_dict["address"] = item[0] +  "," + item[1]
            temp_dict["abonent"] = item[2]
            temp_dict["resourse"] = item[8]
            temp_dict["parametr"] = item[9]
            temp_dict["serial"] = item[7]
            temp_dict["value"]   = item[10]
            temp_dict["date"] = item[6]
            # print(temp_dict)
            res_list_of_dicts.append(temp_dict)



        json_str = json.dumps(res_list_of_dicts, ensure_ascii=False)
        time_delta = datetime.datetime.now() - time_start
        print(time_delta)
        return Response(json.loads(json_str))
    
class AllMetersDataStatusAPIView(APIView):
    def get(self, request):
        time_start = datetime.datetime.now()
        obj_parent = "Корпус 1"
        try:
            # print('дата в запросе', request.GET["date"])
            date = request.GET["date"]
            print(date)
        except MultiValueDictKeyError:
            print(datetime.datetime.now())
            date = datetime.datetime.now().strftime('%Y-%m-%d')
            print('!!!now', date)
        res = common_sql.get_all_meters_data_with_status_api(obj_parent, date)
        # print(res)
        new_res = []
        for item in res:
            new_res.append(list(item))
        
        res_list_of_dicts = []
        for item in new_res:
            temp_dict = {}
            temp_dict["address"] = item[0] +  "," + item[1]
            temp_dict["abonent"] = item[2]
            temp_dict["resourse"] = item[8]
            temp_dict["parametr"] = item[9]
            temp_dict["serial"] = item[7]
            temp_dict["value"]   = item[10]
            temp_dict["date"] = item[6]
            temp_dict["verification"] = item[11]
            temp_dict["status"] = item[12]
            # print(temp_dict)
            res_list_of_dicts.append(temp_dict)



        # json_str = json.dumps(new_res, ensure_ascii=False)
        json_str = json.dumps(res_list_of_dicts, ensure_ascii=False)
        time_delta = datetime.datetime.now() - time_start
        print(time_delta)
        return Response(json.loads(json_str))