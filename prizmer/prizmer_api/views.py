from django.shortcuts import render
from rest_framework import generics

from general.models import  Objects
from prizmer_api.serializers import ObjectsSerializer

from rest_framework.response import Response
from rest_framework.views import APIView

import common_sql
import json
import datetime

class ObjectsAPIView(generics.ListAPIView):
    queryset = Objects.objects.all()
    serializer_class = ObjectsSerializer

class AllMetersDataAPIView(APIView):
    def get(self, request):
        obj_parent = "Корпус 1"
        date = "2023-07-11"
        res = common_sql.get_all_meters_data_api(obj_parent, date)
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
        return Response(json.loads(json_str))