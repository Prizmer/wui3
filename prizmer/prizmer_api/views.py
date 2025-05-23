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
    # with open('api_request.txt', 'a') as f:
    #     f.write('HHello')
        



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
    
class AllMetersDataIdAPIView(APIView):
    def get(self, request):
        time_start = datetime.datetime.now()
        try:
            # print('дата в запросе', request.GET["date"])
            date = request.GET["date"]
            #print(date)
        except MultiValueDictKeyError:
            print(datetime.datetime.now())
            date = datetime.datetime.now().strftime('%Y-%m-%d')
            #date = '2025-04-01'
            #print('!!!now', date)
        res = common_sql.get_all_meters_data_with_id_only_digital_api(date)
        #print(res)
        new_res = []
        for item in res:
            new_res.append(list(item))
        
        res_list_of_dicts = []

        if len(new_res) % 7 == 0:
            for x in range(0, len(new_res)-7, 7):
                temp_dict = {}
                temp_dict["address"] = 'Дыбенко 7/1'
                temp_dict["addressType"] = 'flat'
                temp_dict["HouseId"] = new_res[x][0]
                temp_dict["HouseName"] = new_res[x][1]
                temp_dict["FlatId"]  = new_res[x][2]
                temp_dict["FlatName"] = new_res[x][3]
                temp_dict["Counters"] = [{"water_hot":{"resourse":new_res[x][4], "parametr":new_res[x][5], "serial":new_res[x][6], "value": new_res[x][8], "verification":new_res[x][9], "status": new_res[x][10]}},
                                         {"water_cold":{"resourse":new_res[x+2][4], "parametr":new_res[x+2][5], "serial":new_res[x+2][6], "value": new_res[x+2][8], "verification":new_res[x+2][9], "status": new_res[x+2][10]}},
                                         {"heat":{"resourse":new_res[x+1][4], "parametr":new_res[x+1][5], "serial":new_res[x+1][6], "value": new_res[x+1][8], "verification":new_res[x+1][9], "status": new_res[x+1][10]}},
                                         {"electric":{"resourse":new_res[x+3][4], "parametr":new_res[x+3][5], "serial":new_res[x+3][6], "value0": new_res[x+3][8], "value1": new_res[x+4][8], "value2": new_res[x+5][8], "value3": new_res[x+6][8], "verification":new_res[x+3][9], "status": new_res[x+3][10]}}]#,

                res_list_of_dicts.append(temp_dict)

       
        json_str = json.dumps(res_list_of_dicts, ensure_ascii=False)
        time_delta = datetime.datetime.now() - time_start
        print(time_delta)
        return Response(json.loads(json_str))