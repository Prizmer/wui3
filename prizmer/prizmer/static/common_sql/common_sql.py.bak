# -*- coding: utf-8 -*-
"""
Created on Thu Aug 11 13:01:37 2016
Общие ф-ции из general и AskueReport
@author: Елена
"""
from __future__ import unicode_literals
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response, HttpResponse
from django.core.context_processors import csrf
import simplejson as json
from django.db.models import Max
from django.db import connection
import re
from excel_response import ExcelResponse
import datetime
#---------
import calendar


def daterange(start, stop, step=datetime.timedelta(days=1), inclusive=True):
    # inclusive=False to behave like range by default
    if step.days > 0:
        while start < stop:
            yield start
            start = start + step
    elif step.days < 0:
        while start > stop:
            yield start
            start = start + step
    if inclusive and start == stop:
        yield start

def get_data_table_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, type_of_meter ):
    """Функция для получения одного параметра по теплу с указанием типа прибора. Более общий вариант"""
    cursor = connection.cursor()
    cursor.execute("""SELECT 
                          daily_values.date, 
                          objects.name, 
                          abonents.name, 
                          meters.factory_number_manual, 
                          daily_values.value
                        FROM 
                          public.abonents, 
                          public.objects, 
                          public.daily_values, 
                          public.taken_params, 
                          public.link_abonents_taken_params, 
                          public.names_params, 
                          public.params, 
                          public.meters, 
                          public.types_meters
                        WHERE 
                          daily_values.id_taken_params = taken_params.id AND
                          taken_params.guid_params = params.guid AND
                          taken_params.guid_meters = meters.guid AND
                          link_abonents_taken_params.guid_abonents = abonents.guid AND
                          link_abonents_taken_params.guid_taken_params = taken_params.guid AND
                          params.guid_names_params = names_params.guid AND
                          types_meters.guid = meters.guid_types_meters AND
                          abonents.name = %s AND 
                          objects.name = %s AND 
                          names_params.name = %s AND 
                          daily_values.date = %s AND 
                          types_meters.name LIKE %s 
                        ORDER BY
                        objects.name ASC
                        LIMIT 1;""",[obj_title, obj_parent_title, my_parametr, electric_data, type_of_meter])
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table

def get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, type_of_meter ):
    """Функция для получения одного параметра по теплу с указанием типа прибора"""
    cursor = connection.cursor()
    cursor.execute("""SELECT 
                      daily_values.date,
                      objects.name, 
                      abonents.name, 
                      meters.factory_number_manual, 
                      daily_values.value
                    FROM 
                      public.taken_params, 
                      public.meters, 
                      public.abonents, 
                      public.objects, 
                      public.daily_values, 
                      public.link_abonents_taken_params, 
                      public.names_params, 
                      public.params, 
                      public.types_meters
                    WHERE 
                      taken_params.guid_meters = meters.guid AND
                      meters.guid_types_meters = types_meters.guid AND
                      abonents.guid_objects = objects.guid AND
                      daily_values.id_taken_params = taken_params.id AND
                      link_abonents_taken_params.guid_abonents = abonents.guid AND
                      link_abonents_taken_params.guid_taken_params = taken_params.guid AND
                      params.guid = taken_params.guid_params AND
                      params.guid_names_params = names_params.guid AND
                      abonents.name = %s AND
                      objects.name = %s AND
                      names_params.name = %s AND
                      daily_values.date = %s AND  
                      types_meters.name = %s
                    ORDER BY
                      objects.name ASC
                    LIMIT 1;""",[obj_title, obj_parent_title, my_parametr, electric_data, type_of_meter])
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table

#Отчет по теплу на начало суток
def get_data_table_by_date_heat(obj_title, obj_parent_title, electric_data):
    data_table = []
    
    my_parametr = "Энергия"    
    data_table_heat_energy      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Эльф 1.08")
    
    my_parametr = 'Объем'               
    data_table_heat_water_delta      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Эльф 1.08")

    my_parametr = 'ElfTon'               
    data_table_heat_time_on      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Эльф 1.08")

              
    for x in range(len(data_table_heat_energy)):
        data_table_temp = []
        try:
            data_table_temp.append(data_table_heat_energy[x][0]) # дата
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_energy[x][2]) # имя абонента
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_energy[x][3]) # заводской номер
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_energy[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_water_delta[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_time_on[x][4]) # время работы
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")

        data_table.append(data_table_temp)
    return data_table

#------------

def makeSqlQuery_heat_parametr_for_period_for_abon_daily(obj_title, obj_parent_title , electric_data_start,electric_data_end,my_params):
    sQuery="""
Select z_start.obj_name, z_start.ab_name, z_start.factory_number_manual, 
z_start.energy_start/100, z_end.energy_end/100, round(((z_end.energy_end-z_start.energy_start)/100)::numeric, 2) as energy_delta,
z_start.volume_start, z_end.volume_end, round((z_end.volume_end-z_start.volume_start)::numeric, 2) as volume_delta,
z_start.ton_start, z_end.ton_end, z_end.ton_end-z_start.ton_start as ton_delta
 
from
(Select heat_abons.obj_name, heat_abons.ab_name, z1.energy_start,z1.volume_start, z1.ton_start, heat_abons.factory_number_manual
from
heat_abons
Left Join 
(SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name,  
  daily_values.date as date_start,    
  resources.name,
  sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy_start,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume_start,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as ton_start,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as terr_start   
FROM 
  public.abonents, 
  public.daily_values, 
  public.link_abonents_taken_params, 
  public.objects, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  resources.name = '%s' AND 
  objects.name = '%s'
  and abonents.name='%s'
  group by objects.name, 
  abonents.name,  
  daily_values.date,     
  resources.name
) as z1
on heat_abons.ab_name=z1.ab_name and heat_abons.obj_name=z1.obj_name
where heat_abons.obj_name='%s' and heat_abons.ab_name='%s') as z_start,
(Select heat_abons.obj_name, heat_abons.ab_name, z1.energy_end,z1.volume_end, z1.ton_end, heat_abons.factory_number_manual
from
heat_abons
Left Join 
(SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name,  
  daily_values.date as date_start,    
  resources.name,
  sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy_end,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume_end,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as ton_end,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as terr_end   
FROM 
  public.abonents, 
  public.daily_values, 
  public.link_abonents_taken_params, 
  public.objects, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  resources.name = '%s' AND 
  objects.name = '%s'
  and abonents.name='%s'
  group by objects.name, 
  abonents.name,  
  daily_values.date,     
  resources.name
) as z1
on heat_abons.ab_name=z1.ab_name and heat_abons.obj_name=z1.obj_name
where heat_abons.obj_name='%s'  and heat_abons.ab_name='%s') as z_end

where z_start.ab_name=z_end.ab_name
order by z_start.ab_name
"""%(my_params[0], my_params[1], my_params[2], my_params[3], electric_data_start, my_params[4], obj_parent_title,obj_title,obj_parent_title, obj_title,
         my_params[0], my_params[1], my_params[2], my_params[3], electric_data_end, my_params[4], obj_parent_title,obj_title,obj_parent_title, obj_title)
    return sQuery

#def get_data_table_heat_parametr_for_period_for_abon_v2(obj_title, obj_parent_title, electric_data_start,electric_data_end, my_params):
#    cursor = connection.cursor()
#    cursor.execute(makeSqlQuery_heat_parametr_for_period_for_abon_daily(obj_title, obj_parent_title , electric_data_start,electric_data_end,my_params))
#    data_table = cursor.fetchall()
#    return data_table

def makeSqlQuery_heat_by_date_daily_for_abon(obj_title, obj_parent_title, electric_data_end,my_params):
    sQuery="""SELECT abonents.name,
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                          
                          sum(Case when names_params.name = '%s' then daily_values.value/100 else null end) as energy,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as elfTon                                
FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  abonents.name = '%s' AND 
  objects.name = '%s' AND 
  daily_values.date= '%s' AND 
  types_meters.name = '%s'
  group by   abonents.name, meters.factory_number_manual;"""%(my_params[0],my_params[1],my_params[2],obj_title, obj_parent_title, electric_data_end,my_params[3])
    return sQuery

def makeSqlQuery_heat_by_date_daily_for_obj(obj_title, electric_data_end,my_params):
    sQuery="""
    select heat_abons.ab_name, heat_abons.ab_name, heat_abons.factory_number_manual, z1.energy, z1.volume,z1.elfTon
from heat_abons
left join
(SELECT 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value/100 else null end) as energy,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as elfTon                                
FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  daily_values.date= '%s' AND 
  types_meters.name = '%s'
  group by   abonents.name, meters.factory_number_manual
  ) z1
on heat_abons.ab_name=z1.ab_name
where heat_abons.obj_name='%s'
order by heat_abons.ab_name"""%(my_params[0],my_params[1],my_params[2],obj_title, electric_data_end,my_params[3],obj_title)
    return sQuery

def get_data_table_heat_parametr_by_date_daily_v2(obj_title, obj_parent_title,electric_data_end, my_params, isAbon):
    cursor = connection.cursor()
    if isAbon:
        cursor.execute(makeSqlQuery_heat_by_date_daily_for_abon(obj_title, obj_parent_title, electric_data_end,my_params))
    else:
        cursor.execute(makeSqlQuery_heat_by_date_daily_for_obj(obj_title, electric_data_end,my_params))
    data_table = cursor.fetchall()
    return data_table

def makeSqlQuery_heat_parametr_for_period_for_all(obj_title, electric_data_start,electric_data_end,my_params):
    
    sQuery="""
   Select z_start.obj_name, z_start.ab_name, z_start.factory_number_manual, 
z_start.energy_start/100, z_end.energy_end/100, round(((z_end.energy_end-z_start.energy_start)/100)::numeric, 2) as energy_delta,
z_start.volume_start, z_end.volume_end, round((z_end.volume_end-z_start.volume_start)::numeric, 2) as volume_delta,
z_start.ton_start, z_end.ton_end, z_end.ton_end-z_start.ton_start as ton_delta
 
from
(Select heat_abons.obj_name, heat_abons.ab_name, z1.energy_start,z1.volume_start, z1.ton_start, heat_abons.factory_number_manual
from
heat_abons
Left Join 
(SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name,  
  daily_values.date as date_start,    
  resources.name,
  sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy_start,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume_start,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as ton_start,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as terr_start   
FROM 
  public.abonents, 
  public.daily_values, 
  public.link_abonents_taken_params, 
  public.objects, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  resources.name = '%s' AND 
  objects.name = '%s'
  group by objects.name, 
  abonents.name,  
  daily_values.date,     
  resources.name
) as z1
on heat_abons.ab_name=z1.ab_name and heat_abons.obj_name=z1.obj_name
where heat_abons.obj_name='%s') as z_start,
(Select heat_abons.obj_name, heat_abons.ab_name, z1.energy_end,z1.volume_end, z1.ton_end, heat_abons.factory_number_manual
from
heat_abons
Left Join 
(SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name,  
  daily_values.date as date_start,    
  resources.name,
  sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy_end,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume_end,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as ton_end,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as terr_end   
FROM 
  public.abonents, 
  public.daily_values, 
  public.link_abonents_taken_params, 
  public.objects, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  resources.name = '%s' AND 
  objects.name = '%s'
  group by objects.name, 
  abonents.name,  
  daily_values.date,     
  resources.name
) as z1
on heat_abons.ab_name=z1.ab_name and heat_abons.obj_name=z1.obj_name
where heat_abons.obj_name='%s') as z_end

where z_start.ab_name=z_end.ab_name
order by z_start.ab_name
    """%(my_params[0], my_params[1], my_params[2], my_params[3], electric_data_start, my_params[4], obj_title ,obj_title,
         my_params[0], my_params[1], my_params[2], my_params[3], electric_data_end, my_params[4], obj_title ,obj_title)
    #print sQuery
    #my_params = [u'Энергия', u'Объем', 'ElfTon', 'ElfErr', 'Тепло']
    return sQuery

#def get_data_table_heat_parametr_for_period_v2(obj_title, electric_data_start,electric_data_end, my_params):
#    cursor = connection.cursor()
#    cursor.execute(makeSqlQuery_heat_parametr_for_period_for_all(obj_title, electric_data_start,electric_data_end,my_params))
#    data_table = cursor.fetchall()
#    return data_table

def get_data_table_by_date_heat_v2(obj_title, obj_parent_title, electric_data_end, isAbon):
    data_table = []
    my_parametr = [u'Энергия',u'Объем',u'ElfTon',u'Эльф 1.08']
    data_table= get_data_table_heat_parametr_by_date_daily_v2(obj_title, obj_parent_title,electric_data_end, my_parametr, isAbon)
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table

def get_data_table_for_period_v3(obj_title, obj_parent_title, electric_data_start, electric_data_end, isAbon):
    cursor = connection.cursor()
    my_params = [u'Энергия', u'Объем', 'ElfTon', 'ElfErr', 'Тепло']
    data_table=[]    
    if isAbon:
        cursor.execute(makeSqlQuery_heat_parametr_for_period_for_abon_daily(obj_title, obj_parent_title , electric_data_start,electric_data_end,my_params))
    else:
        cursor.execute(makeSqlQuery_heat_parametr_for_period_for_all(obj_title, electric_data_start,electric_data_end,my_params))
    data_table = cursor.fetchall()
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table

def get_data_table_for_period_for_abon_heat_v2(obj_title, obj_parent_title, electric_data_start, electric_data_end):
    data_table = []
    my_parametr = [u'Энергия'] #если будут проблемы,то возможно передлать в sql выборку на Эльф 1.08
    
    data_table= get_data_table_heat_parametr_for_period_for_abon_v2(obj_title, obj_parent_title, electric_data_start,electric_data_end, my_parametr)
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table

def get_data_table_for_period_heat_v2(obj_title, obj_parent_title, electric_data_start, electric_data_end):
    data_table = []
    my_parametr = [u'Энергия']#если будут проблемы,то возможно передлать в sql выборку на Эльф 1.08
    data_table= get_data_table_heat_parametr_for_period_v2(obj_title, electric_data_start,electric_data_end, my_parametr)
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table

def get_data_table_heat_parametr_current(obj_title, obj_parent_title, my_parametr, type_of_meter ):
    """Функция для получения одного параметра по теплу с указанием типа прибора"""
    cursor = connection.cursor()
    cursor.execute("""SELECT 
                          current_values.date,
                          current_values.time, 
                          objects.name, 
                          abonents.name, 
                          meters.factory_number_manual, 
                          current_values.value
                        FROM 
                          public.abonents, 
                          public.objects, 
                          public.current_values, 
                          public.taken_params, 
                          public.link_abonents_taken_params, 
                          public.names_params, 
                          public.params, 
                          public.meters, 
                          public.types_meters
                        WHERE 
                          current_values.id_taken_params = taken_params.id AND
                          taken_params.guid_params = params.guid AND
                          taken_params.guid_meters = meters.guid AND
                          link_abonents_taken_params.guid_abonents = abonents.guid AND
                          link_abonents_taken_params.guid_taken_params = taken_params.guid AND
                          params.guid_names_params = names_params.guid AND
                          types_meters.guid = meters.guid_types_meters AND
                          abonents.name = %s AND 
                          objects.name = %s AND 
                          names_params.name = %s AND 
                          types_meters.name = %s 
                        ORDER BY
                        objects.name ASC
                        LIMIT 1;""",[obj_title, obj_parent_title, my_parametr, type_of_meter])
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Время  2 - Имя объекта, 3 - Имя абонента, 4 - заводской номер, 5 - значение
    return data_table
    
def get_data_table_current_heat(obj_title, obj_parent_title):

    data_table = []
    
    my_parametr = "Энергия"    
    data_table_heat_energy_current       = get_data_table_heat_parametr_current(obj_title, obj_parent_title, my_parametr, u"Эльф 1.08")
    
    my_parametr = 'Объем'               
    data_table_heat_water_delta_current  = get_data_table_heat_parametr_current(obj_title, obj_parent_title, my_parametr, u"Эльф 1.08")

    my_parametr = 'ElfTon'               
    data_table_heat_time_on_current      = get_data_table_heat_parametr_current(obj_title, obj_parent_title, my_parametr, u"Эльф 1.08")

    my_parametr = "Ti"    
    data_table_heat_temp_in_current       = get_data_table_heat_parametr_current(obj_title, obj_parent_title, my_parametr, u"Эльф 1.08")
    
    my_parametr = 'To'               
    data_table_heat_temp_out_current  = get_data_table_heat_parametr_current(obj_title, obj_parent_title, my_parametr, u"Эльф 1.08")

    my_parametr = 'ElfErr'               
    data_table_heat_error_current      = get_data_table_heat_parametr_current(obj_title, obj_parent_title, my_parametr, u"Эльф 1.08")
              
    for x in range(len(data_table_heat_energy_current)):
        data_table_temp = []
        try:
            data_table_temp.append(data_table_heat_energy_current[x][0]) # дата
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_energy_current[x][1]) # время
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_energy_current[x][3]) # имя абонента
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_energy_current[x][4]) # заводской номер
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_energy_current[x][5]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_water_delta_current[x][5]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_time_on_current[x][5]) # время работы
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_temp_in_current[x][5]) # значение температуры входа
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_temp_out_current[x][5]) # значение температуры выхода
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_temp_in_current[x][5] - data_table_heat_temp_out_current[x][5]) # значение температуры выхода
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_error_current[x][5]) # код ошибки
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        data_table.append(data_table_temp)
    return data_table
    

def makeSqlQuery_heat_parametr_current(obj_title, obj_parent_title ,params, res):

    sQuery="""
Select z1.date,  z2.time_ask, z1.ab_name, z1.factory_number_manual,z1.energy, z1.volume, z1.elfTon, z1.ti,z1.t0, z1.t0-z1.ti as deltaT ,z1.elfErr
From
(SELECT 
current_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as energy,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as volume,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as elfTon,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as ti,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as t0,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as elfErr
FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.current_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  current_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  abonents.name = '%s' AND 
  objects.name = '%s' AND 
  types_meters.name = '%s'
  group by current_values.date, objects.name,abonents.name, meters.factory_number_manual) z1,
  (
SELECT 
current_values.date, current_values.time as time_ask,objects.name, abonents.name, meters.factory_number_manual
FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.current_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  current_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  abonents.name = '%s' AND 
  objects.name = '%s' AND 
  types_meters.name = '%s'
  order by current_values.time DESC
  Limit 1
  ) z2;"""%(params[0],params[1],params[2],params[3],params[4],params[5], obj_title, obj_parent_title , res, obj_title, obj_parent_title , res)

    return sQuery

def makeSqlQuery_heat_parametr_current_for_all(obj_title, params, res):
    sQuery="""
Select z3.date,  z3.time_ask, z4.ab_name, z3.factory_number_manual, z3.energy, z3.volume, z3.elfTon, z3.ti,z3.t0, z3.deltaT ,z3.elfErr
from
(SELECT 
  abonents.name as ab_name, 
  objects.name, 
  types_meters.name, 
  meters.factory_number_manual
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  meters.guid_types_meters = types_meters.guid AND
  types_meters.name = '%s' and
  objects.name='%s'
  group by   abonents.name, 
  objects.name, 
  types_meters.name, 
  meters.factory_number_manual
  order by abonents.name ASC) z4
left join
(Select z1.date,  z2.time_ask, z1.ab_name, z1.factory_number_manual,z1.energy, z1.volume, z1.elfTon, z1.ti,z1.t0, z1.t0-z1.ti as deltaT ,z1.elfErr
From
(SELECT 
current_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as energy,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as volume,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as elfTon,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as ti,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as t0,
                          sum(Case when names_params.name = '%s' then current_values.value else null end) as elfErr
FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.current_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  current_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s'
  group by current_values.date, objects.name,abonents.name, meters.factory_number_manual) z1,
  (
SELECT 
current_values.date,    
current_values."time" as time_ask,                       
                          objects.name, 
                          abonents.name, 
                          meters.factory_number_manual
FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.current_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  current_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s'
  order by current_values."time" DESC
  Limit 1
  ) z2
  order by ab_name ASC) z3
  on z4.ab_name=z3.ab_name
  group by z3.date, z3.time_ask, z3.ab_name, z4.ab_name, z3.factory_number_manual, z3.energy, z3.volume, z3.elfTon, z3.ti,z3.t0, z3.deltaT ,z3.elfErr
  order by z4.ab_name ASC;"""%(res, obj_title, params[0],params[1],params[2],params[3],params[4],params[5], obj_title,  res, obj_title, res)
    return sQuery

def get_data_table_heat_parametr_current_v2(obj_title, obj_parent_title, my_params, res, isAbon):
    cursor = connection.cursor()
    data_table=[]
    if isAbon:
        cursor.execute(makeSqlQuery_heat_parametr_current(obj_title, obj_parent_title ,my_params, res))
    else:
        cursor.execute(makeSqlQuery_heat_parametr_current_for_all(obj_title ,my_params, res))
    data_table = cursor.fetchall()
    return data_table

def get_data_table_current_heat_v2(obj_title, obj_parent_title, isAbon):
    data_table = []
    my_params=[u'Энергия' ,u'Объем',u'ElfTon',u'Ti',u'To',u'ElfErr']
    data_table= get_data_table_heat_parametr_current_v2(obj_title, obj_parent_title, my_params, u'Эльф 1.08', isAbon)
    date=None
    for x in data_table:
        if x[0] != None:
            date=x[0]
            break
    if len(data_table)>0:
        data_table=ChangeNull(data_table, date)
    return data_table

def get_data_table_electric_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr ):
    cursor = connection.cursor()
    cursor.execute("""SELECT 
                        daily_values.date, objects.name, abonents.name, meters.factory_number_manual, daily_values.value 
                        FROM
                         public.daily_values, public.link_abonents_taken_params, public.taken_params, public.abonents, public.objects, public.names_params, public.params, public.meters 
                        WHERE
                         taken_params.guid = link_abonents_taken_params.guid_taken_params AND taken_params.id = daily_values.id_taken_params AND taken_params.guid_params = params.guid AND taken_params.guid_meters = meters.guid AND abonents.guid = link_abonents_taken_params.guid_abonents AND objects.guid = abonents.guid_objects AND names_params.guid = params.guid_names_params AND
                        abonents.name = %s AND 
                        objects.name = %s AND 
                        names_params.name = %s AND 
                        daily_values.date = %s 
                        ORDER BY
                        objects.name ASC;""",[obj_title, obj_parent_title, my_parametr, electric_data])
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table

def get_data_table_electric_parametr_daily_by_meters_number(meters_number, electric_data, my_parametr):
    cursor = connection.cursor()
    cursor.execute("""SELECT 
                          daily_values.value
                        FROM 
                          public.daily_values, 
                          public.taken_params, 
                          public.meters, 
                          public.params, 
                          public.names_params
                        WHERE 
                          daily_values.id_taken_params = taken_params.id AND
                          taken_params.guid_meters = meters.guid AND
                          taken_params.guid_params = params.guid AND
                          params.guid_names_params = names_params.guid AND
                          meters.factory_number_manual = %s AND 
                          names_params.name = %s AND 
                          daily_values.date = %s
                          LIMIT 1;""",[meters_number, my_parametr, electric_data])
    data_table = cursor.fetchall()
    return data_table
    

def makeSqlQuery_electric_by_daily_or_monthly_for_group_v3(obj_title, electric_data, params, dm):
    sQuery="""select z2.monthly_date,
 z3.name_abonents, z2.number_manual,
      round((z3.znak*z2.t0)::numeric,3), 
      round((z3.znak*z2.t1::numeric,3), 
      round((z3.znak*z2.t2::numeric,3), 
      round((z3.znak*z2.t3::numeric,3)
from 
(SELECT  
 abonents.name as name_abonents,
  (Case when link_balance_groups_meters.type = 'True' then 1 else -1 end)  as znak
FROM 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params,
  public.meters, 
  public.link_balance_groups_meters, 
  public.balance_groups,
  public.names_params,
  public.params
WHERE 
  taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
  abonents.guid = link_abonents_taken_params.guid_abonents  AND 
  taken_params.guid_params = params.guid AND 
  names_params.guid = params.guid_names_params AND
  taken_params.guid_meters = meters.guid AND 
  meters.guid=link_balance_groups_meters.guid_meters AND
  balance_groups.guid=link_balance_groups_meters.guid_balance_groups AND
  balance_groups.name='%s' 
  GROUP BY abonents.name, link_balance_groups_meters.type) z3
Left join
(SELECT z1.guid,z1.monthly_date, z1.name_group, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t3
FROM
                        (SELECT 
                        balance_groups.guid,
 monthly_values.date as monthly_date, 
 balance_groups.name as name_group, 
 abonents.name as name_abonents, 
 meters.factory_number_manual as number_manual, 
 monthly_values.value as value_monthly, 
 names_params.name as params_name
FROM 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params,
  public.monthly_values, 
  public.meters, 
  public.link_balance_groups_meters, 
  public.balance_groups,
  public.names_params,
  public.params
WHERE 
  taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
  abonents.guid = link_abonents_taken_params.guid_abonents  AND 
  taken_params.id = monthly_values.id_taken_params AND 
  taken_params.guid_params = params.guid AND 
  names_params.guid = params.guid_names_params AND
  taken_params.guid_meters = meters.guid AND 
  meters.guid=link_balance_groups_meters.guid_meters AND
  balance_groups.guid=link_balance_groups_meters.guid_balance_groups AND
  balance_groups.name='%s' AND
  monthly_values.date = '%s') z1
group by z1.name_group, z1.monthly_date, z1.name_abonents, z1.number_manual, z1.guid
order by name_abonents ASC) z2
on z3.name_abonents=z2.name_abonents
group by z2.monthly_date,
      z2.name_group, z3.name_abonents,
      z2.number_manual, z2.t0, z2.t1, z2.t2, z2.t3, z3.znak
ORDER BY z3.name_abonents ASC;    """%(obj_title, params[0],params[1],params[2],params[3], obj_title, electric_data)
    
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('monthly',dm)
        #print sQuery
        return sQuery
    else: return """Select 'Н/Д'"""

def get_data_table_electric_parametr_by_date_for_group_v3(obj_title, electric_data, params, dm):
    cursor = connection.cursor()
    #dm - строка, содержащая monthly or daily для sql-запроса или current
    cursor.execute(makeSqlQuery_electric_by_daily_or_monthly_for_group_v3(obj_title, electric_data, params, dm))
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table

def makeSqlQuery_water_for_abon_gvs_hvs_daily(obj_title, obj_parent_title, electric_data, params, dm):
    sQuery="""
SELECT 
  daily_values.date,
  abonents.name, 
  meters.factory_number_manual,  
   sum(Case when names_params.name = '%s' then daily_values.value else null end) as hvs,
   sum(Case when names_params.name = '%s' then daily_values.value else null end) as gvs,
  objects.name
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.meters, 
  public.types_meters,
  daily_values
WHERE 
daily_values.id_taken_params=taken_params.id and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  meters.guid_types_meters = types_meters.guid and
  resources.name='%s' and
  objects.name='%s' and
  abonents.name='%s' 
  group by   objects.name, 
  abonents.name, 
  meters.factory_number_manual, 
  daily_values.date 
  order by daily_values.date ASC
  Limit 1"""%(params[0],params[1],params[2], obj_parent_title,obj_title)
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('daily',dm)
        #print sQuery
        return sQuery
    else: return """Select 'Н/Д'"""

def makeSqlQuery_water_for_obj_gvs_hvs_daily(obj_title, obj_parent_title, electric_data, params, dm):
    sQuery="""
Select z1.date,water_abons.ab_name, water_abons.factory_number_manual, z1.hvs,z1.gvs
from water_abons
left join
(SELECT
  objects.name as obj_name, 
  abonents.name as ab_name, 
  meters.factory_number_manual,  
   sum(Case when names_params.name = '%s' then current_values.value else null end) as hvs,
   sum(Case when names_params.name = '%s' then current_values.value else null end) as gvs,
   current_values.date
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.meters, 
  public.types_meters,
  current_values
WHERE 
current_values.id_taken_params=taken_params.id and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  meters.guid_types_meters = types_meters.guid and
  resources.name='%s' and
  objects.name='%s' and
  current_values.date='%s'
  group by   objects.name, 
  abonents.name, 
  meters.factory_number_manual, 
  current_values.date
  order by objects.name,  abonents.name) z1
  on water_abons.ab_name=z1.ab_name and water_abons.obj_name=z1.obj_name
  where water_abons.obj_name='%s'
  order by water_abons.ab_name

    """%(params[0],params[1],params[2], obj_title, electric_data, obj_title)
    
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('current',dm)
        return sQuery
    else: return """Select 'Н/Д'"""

def makeSqlQuery_water_for_abon_gvs_hvs_current(obj_title, obj_parent_title, electric_data, params):
    sQuery="""
    SELECT 
    current_values.date,
   current_values.time,
  abonents.name, 
  meters.factory_number_manual,  
   sum(Case when names_params.name = '%s' then current_values.value else null end) as hvs,
   sum(Case when names_params.name = '%s' then current_values.value else null end) as gvs,    
  objects.name 
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.meters, 
  public.types_meters,
  current_values
WHERE 
current_values.id_taken_params=taken_params.id and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  meters.guid_types_meters = types_meters.guid and
  resources.name='%s' and
  objects.name='%s' and
  abonents.name='%s' 
  group by   objects.name, 
  abonents.name, 
  meters.factory_number_manual, 
  current_values.date,
   current_values.time
  order by current_values.date ASC
  Limit 1;
    """%(params[0],params[1],params[2],  obj_parent_title,obj_title)

    return sQuery

def makeSqlQuery_water_for_obj_gvs_hvs_current(obj_title, obj_parent_title, electric_data, params):
    sQuery="""
Select z1.date, z1.time,water_abons.ab_name, water_abons.factory_number_manual, z1.hvs,z1.gvs, water_abons.obj_name
from water_abons
left join
(SELECT
  objects.name as obj_name, 
  abonents.name as ab_name, 
  meters.factory_number_manual,  
   sum(Case when names_params.name = '%s' then current_values.value else null end) as hvs,
   sum(Case when names_params.name = '%s' then current_values.value else null end) as gvs,
   current_values.date,
   current_values.time
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.meters, 
  public.types_meters,
  current_values
WHERE 
current_values.id_taken_params=taken_params.id and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  meters.guid_types_meters = types_meters.guid and
  resources.name='%s' and
  objects.name='%s' and
  current_values.date='%s'
  group by   objects.name, 
  abonents.name, 
  meters.factory_number_manual, 
  current_values.date,
   current_values.time
  order by objects.name,  abonents.name) z1
  on water_abons.ab_name=z1.ab_name and water_abons.obj_name=z1.obj_name
  where water_abons.obj_name='%s'
  order by water_abons.ab_name

    """%(params[0],params[1],params[2], obj_title, electric_data, obj_title)
    
    return sQuery



def get_daily_water_gvs_hvs(obj_title, obj_parent_title , electric_data, dm, isAbon):
    params=[u'Канал 1',u'Канал 2', u'Импульс']
    #dm - строка, содержащая monthly or daily для sql-запроса или current
    cursor = connection.cursor()
    if isAbon:
        cursor.execute(makeSqlQuery_water_for_abon_gvs_hvs_daily(obj_title, obj_parent_title, electric_data, params, dm))
    else: 
        cursor.execute(makeSqlQuery_water_for_obj_gvs_hvs_daily(obj_title, obj_parent_title, electric_data, params, dm))
    data_table = cursor.fetchall()
    
    if len(data_table)>0: 
        if isAbon:
            data_table=ChangeNull(data_table, None)
        else:
            data_table=ChangeNull(data_table, electric_data)
    return data_table


def get_current_water_gvs_hvs(obj_title, obj_parent_title , electric_data, isAbon):
    params=[u'Канал 1',u'Канал 2', u'Импульс']
    #dm - строка, содержащая monthly or daily для sql-запроса или current
    cursor = connection.cursor()
    if isAbon:
        cursor.execute(makeSqlQuery_water_for_abon_gvs_hvs_current(obj_title, obj_parent_title, electric_data, params))
    else: 
        cursor.execute(makeSqlQuery_water_for_obj_gvs_hvs_current(obj_title, obj_parent_title, electric_data, params))
    data_table = cursor.fetchall()
    
    if len(data_table)>0: 
        if isAbon:
            data_table=ChangeNull(data_table, None)
        else:
            data_table=ChangeNull(data_table, electric_data)
    return data_table

def makeSqlQuery_water_for_obj_gvs_hvs_elf_for_period(obj_title, electric_data_end, electric_data_start,channel,attr):
    sQuery="""
    Select z_end.ab_name, z_end.factory_number_manual, z_end.%s,z_end.val_end, z_start.val_start, z_end.val_end-z_start.val_start as delta
from
(Select ab_name, water_abons.factory_number_manual, z1.%s,z1.val_end
from water_abons
left join 
(SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.%s, 
  daily_values.value as val_end, 
  taken_params.id,   
  params.channel,
  abonents.guid as ab_guid,
   meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = %s AND 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z1
  on z1.factory_number_manual=water_abons.factory_number_manual 
  where water_abons.obj_name='%s') as z_end,

  (Select ab_name, water_abons.factory_number_manual, z2.%s,z2.val_start
from water_abons
left join 
(SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.%s, 
  daily_values.value as val_start, 
  taken_params.id,   
  params.channel,
  abonents.guid as ab_guid,
   meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = %s AND 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z2
  on z2.factory_number_manual=water_abons.factory_number_manual
  where water_abons.obj_name='%s') as z_start
  where z_end.factory_number_manual=z_start.factory_number_manual
  order by z_end.ab_name

    """%(attr,attr,attr, obj_title,channel,electric_data_end,obj_title, attr, attr, obj_title,channel, electric_data_start,obj_title)
    #print sQuery
    #print '!!!!!!!!!!!!!attention'
    return sQuery

def makeSqlQuery_water_for_abon_gvs_hvs_elf_for_period(abon, obj_title, electric_data_end, electric_data_start, channel,attr):
    sQuery="""
    Select z_end.ab_name, z_end.factory_number_manual, z_end.%s,z_end.val_end, z_start.val_start, z_end.val_end-z_start.val_start as delta
from
(Select ab_name, water_abons.factory_number_manual, z1.%s,z1.val_end
from water_abons
left join 
(SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.%s, 
  daily_values.value as val_end, 
  taken_params.id,   
  params.channel,
  abonents.guid as ab_guid,
   meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = %s AND 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z1
  on z1.factory_number_manual=water_abons.factory_number_manual 
  where water_abons.obj_name='%s') as z_end,

  (Select ab_name, water_abons.factory_number_manual, z2.%s,z2.val_start
from water_abons
left join 
(SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.%s, 
  daily_values.value as val_start, 
  taken_params.id,   
  params.channel,
  abonents.guid as ab_guid,
   meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = %s AND 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z2
  on z2.factory_number_manual=water_abons.factory_number_manual
  where water_abons.obj_name='%s') as z_start
  where z_end.factory_number_manual=z_start.factory_number_manual
  and  z_end.ab_name='%s'
  order by z_end.ab_name

    """%(attr,attr,attr, obj_title,channel,electric_data_end,obj_title, attr, attr, obj_title,channel, electric_data_start,obj_title,abon)
    
    return sQuery

def get_daily_water_elf_period(obj_title, obj_parent_title , electric_data_end,electric_data_start, channel,attr, isAbon):
    cursor = connection.cursor()
    if isAbon:
        #print attr
        cursor.execute(makeSqlQuery_water_for_abon_gvs_hvs_elf_for_period(obj_title, obj_parent_title, electric_data_end, electric_data_start, channel,attr))
    else: 
        cursor.execute(makeSqlQuery_water_for_obj_gvs_hvs_elf_for_period(obj_title, electric_data_end, electric_data_start,channel,attr))
    data_table = cursor.fetchall()

    data_table=ChangeNull(data_table, None)
    return data_table

def makeSqlQuery_water_for_abon_gvs_hvs_elf(obj_title, obj_parent_title , electric_data_end, channel, attr):
    sQuery="""
    SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.%s, 
  daily_values.value, 
  taken_params.id, 
  params.channel,
  abonents.guid,
   meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = %s AND 
  abonents.name = '%s' and
  daily_values.date='%s'
ORDER BY
  abonents.name ASC;"""%(attr,obj_parent_title,channel,obj_title,electric_data_end)
    return sQuery

def makeSqlQuery_water_for_obj_gvs_hvs_elf(obj_title, obj_parent_title , electric_data_end, channel,attr):
    sQuery="""
    Select z1.date,ab_name,water_abons.factory_number_manual, z1.%s, z1.value
from water_abons
left join
(
SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.%s, 
  daily_values.value, 
  taken_params.id,   
  params.channel,
  abonents.guid as ab_guid,
  meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = %s and 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z1
  on z1.ab_guid=water_abons.ab_guid
  where water_abons.obj_name = '%s' """%(attr, attr,obj_title,channel,electric_data_end,obj_title)
    return sQuery

def get_daily_water_elf(obj_title, obj_parent_title , electric_data_end, channel,attr, isAbon):
    cursor = connection.cursor()
    if isAbon:
        cursor.execute(makeSqlQuery_water_for_abon_gvs_hvs_elf(obj_title, obj_parent_title , electric_data_end, channel,attr))
    else: 
        cursor.execute(makeSqlQuery_water_for_obj_gvs_hvs_elf(obj_title, obj_parent_title , electric_data_end, channel,attr))
    data_table = cursor.fetchall()
    
    if len(data_table)>0: 
        if isAbon:
            data_table=ChangeNull(data_table, None)
        else:
            data_table=ChangeNull(data_table, electric_data_end)
    return data_table


def makeSqlQuery_check_numbers(params):
    sQuery="""
    SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name, 
  meters.name as meter_name, 
  meters.factory_number_manual, 
  meters.factory_number_readed, 
  meters.is_factory_numbers_equal, 
  meters.dt_last_read, 
  resources.name as res_name
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid and
  is_factory_numbers_equal= False and
  resources.name='%s'
group by     
objects.name, 
  abonents.name, 
  meters.name, 
  meters.factory_number_manual, 
  meters.factory_number_readed, 
  meters.is_factory_numbers_equal, 
  meters.dt_last_read, 
  resources.name"""%(params[0])
    return sQuery
def get_data_table_diferent_numbers():
    params=[u'Электричество']
    cursor = connection.cursor()
    cursor.execute(makeSqlQuery_check_numbers(params))
    data_table = cursor.fetchall()
    
    return data_table

def makeSqlQuery_electric_by_daily_or_monthly_for_object_v3(obj_title, electric_data, params, dm, res):
    sQuery="""Select  z2.monthly_date,
    electric_abons_2.ab_name, 
    electric_abons_2.factory_number_manual, 
    round(z2.t0::numeric,3), 
    round(z2.t1::numeric,3), 
    round(z2.t2::numeric,3), 
    round(z2.t3::numeric,3),electric_abons_2.obj_name, z2.ktt,z2.ktn,z2.a, 
    electric_abons_2.comment, electric_abons_2.date, electric_abons_2.ab_guid
from electric_abons_2
LEFT JOIN 
(SELECT z1.monthly_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t3,
z1.ktt,z1.ktn,z1.a

                        FROM
                        (SELECT monthly_values.date as monthly_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        monthly_values.value as value_monthly, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                         link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.monthly_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources			
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = monthly_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and
                 objects.name = '%s' AND                      
                        monthly_values.date = '%s' 
                         group by 
                        monthly_values.date,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        monthly_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3
                        ) z1                  
group by z1.name_objects, z1.monthly_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktt,z1.ktn,z1.a
) z2
on electric_abons_2.factory_number_manual=z2.number_manual
where electric_abons_2.obj_name='%s'
ORDER BY electric_abons_2.ab_name ASC;
"""%(params[0],params[1],params[2],params[3], res,obj_title, electric_data, obj_title)
    #print sQuery
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('monthly',dm)
        
        return sQuery    
    else: return """Select 'Н/Д'"""
    



def makeSqlQuery_electric_between(obj_title, obj_parent_title,data_start, data_end, params):

    sQuery="""
    Select c_date,daily_date,obj_name,ab_name,factory_number_manual,t0,t1,t2,t3,ktn,ktt,a, 
z3.t0-lag(t0) over (order by c_date) as delta,
z3.t1-lag(t1) over (order by c_date) as delta_t1,
z3.t2-lag(t2) over (order by c_date) as delta_t2,
z3.t3-lag(t3) over (order by c_date) as delta_t3
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z4
left join 
(Select  z2.daily_date,
  electric_abons.obj_name, electric_abons.ab_name, 
    electric_abons.factory_number_manual, z2.t0, z2.t1, z2.t2, z2.t3, z2.ktn, z2.ktt, z2.a 
from electric_abons
LEFT JOIN 
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t3,
z1.ktn, z1.ktt, z1.a 
                        FROM
                        (SELECT daily_values.date as daily_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        daily_values.value as value_daily, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources			
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = daily_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and
                        abonents.name = '%s' AND 
                        objects.name = '%s' AND                      
                        daily_values.date between '%s' and '%s'
                         group by
                    daily_values.date,
                        daily_values.id_taken_params,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3,
                          resources.name
                        ) z1                      
group by z1.name_objects, z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktn, z1.ktt, z1.a 
) z2
on electric_abons.factory_number_manual=z2.number_manual
where electric_abons.ab_name = '%s' AND electric_abons.obj_name='%s'
ORDER BY electric_abons.ab_name, z2.daily_date  ASC) z3
on z4.c_date=z3.daily_date 
order by z4.c_date""" % (data_start,data_end,params[0],params[1],params[2],params[3],unicode(params[4]),unicode(obj_title), unicode(obj_parent_title), data_start,data_end,unicode(obj_title), unicode(obj_parent_title))
    #print sQuery
    return sQuery


def makeSqlQuery_electric_between_activ_reactiv(obj_title, obj_parent_title,data_start, data_end, params):

    sQuery="""
    Select c_date,daily_date,obj_name,ab_name,factory_number_manual,t0,tr0,ktn,ktt,a, 
round((z3.t0-lag(t0) over (order by c_date))::numeric,3) as delta_a,
round((z3.tr0-lag(tr0) over (order by c_date))::numeric,3) as delta_r
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z4
left join 
(Select  z2.daily_date,
  electric_abons.obj_name, electric_abons.ab_name, 
    electric_abons.factory_number_manual, z2.t0, z2.tr0, z2.ktn, z2.ktt, z2.a 
from electric_abons
LEFT JOIN 
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as tr0,

z1.ktn, z1.ktt, z1.a 
                        FROM
                        (SELECT daily_values.date as daily_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        daily_values.value as value_daily, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources			
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = daily_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and
                        abonents.name = '%s' AND 
                        objects.name = '%s' AND                      
                        daily_values.date between '%s' and '%s'
                        ) z1                      
group by z1.name_objects, z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktn, z1.ktt, z1.a 
) z2
on electric_abons.ab_name=z2.name_abonents
where electric_abons.ab_name = '%s' AND electric_abons.obj_name='%s'
ORDER BY electric_abons.ab_name, z2.daily_date  ASC) z3
on z4.c_date=z3.daily_date 
order by z4.c_date""" % (data_start,data_end,params[0],params[1],unicode(params[2]),unicode(obj_title), unicode(obj_parent_title), data_start,data_end,unicode(obj_title), unicode(obj_parent_title))
    #print sQuery
    return sQuery


def get_data_table_electric_between(obj_title, obj_parent_title,data_start, data_end, params):
    data_table = []
    #params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+', u'Электричество']
    cursor = connection.cursor()
    if len(params) == 3:
      cursor.execute(makeSqlQuery_electric_between_activ_reactiv(obj_title, obj_parent_title,data_start, data_end, params))
    else:
        cursor.execute(makeSqlQuery_electric_between(obj_title, obj_parent_title,data_start, data_end, params))
    data_table = cursor.fetchall()
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table



def makeSqlQuery_electric_between_for_obj(obj_title, obj_parent_title,data_start, data_end, params):
    sQuery="""
    Select c_date,daily_date,obj_name,obj_name, 1,t0,t1,t2,t3,1,1,1,
z3.t0-lag(t0) over (order by c_date) as delta,
z3.t1-lag(t1) over (order by c_date) as delta_t1,
z3.t2-lag(t2) over (order by c_date) as delta_t2,
z3.t3-lag(t3) over (order by c_date) as delta_t3
from
(
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) as z4
left join
(
SELECT z1.daily_date, z1.name_objects as obj_name,  
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t3

                        FROM
                        (SELECT daily_values.date as daily_date,
                        objects.name as name_objects,
                        abonents.name as name_abonents,
                        meters.factory_number_manual as number_manual,
                        daily_values.value as value_daily,
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values,
                         public.link_abonents_taken_params,
                         public.taken_params,
                         public.abonents,
                         public.objects,
                         public.names_params,
                         public.params,
                         public.meters,
                         public.types_meters,
                         public.resources
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                        taken_params.id = daily_values.id_taken_params AND
                        taken_params.guid_params = params.guid AND
                        taken_params.guid_meters = meters.guid AND
                        abonents.guid = link_abonents_taken_params.guid_abonents AND
                        objects.guid = abonents.guid_objects AND
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and
                        
                        objects.name = '%s' AND
                        daily_values.date between '%s' and '%s'
                         group by
                    daily_values.date,
                        daily_values.id_taken_params,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3,
                          resources.name
                        ) z1
group by z1.name_objects, z1.daily_date, z1.name_objects
) z2
on z4.c_date=z2.daily_date
) z3
order by c_date
    """%(data_start, data_end,params[0],params[1],params[2],params[3],params[4],obj_title,data_start, data_end )
    #print sQuery
    return sQuery
def get_data_table_electric_between_for_obj(obj_title, obj_parent_title,data_start, data_end):
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+', u'Электричество']
    cursor = connection.cursor()
    cursor.execute(makeSqlQuery_electric_between_for_obj(obj_title, obj_parent_title,data_start, data_end, params))
    data_table = cursor.fetchall()
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table

def makeSqlQuery_electric_by_daily_or_monthly_v3(obj_title, obj_parent_title, electric_data, params, dm):
    sQuery="""
   Select  z2.daily_date,
   electric_abons.ab_name, 
   electric_abons.factory_number_manual, z2.t0, z2.t1, z2.t2, z2.t3, electric_abons.obj_name,  z2.ktt, z2.ktn, z2.a , electric_abons.comment, electric_abons.date, electric_abons.ab_guid
from electric_abons
LEFT JOIN 
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t3,
z1.ktn, z1.ktt, z1.a 
                        FROM
                        (SELECT daily_values.date as daily_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        daily_values.value as value_daily, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = daily_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='Электричество' and
                 abonents.name = '%s' AND objects.name = '%s' AND                      
                        daily_values.date = '%s' 
                        ) z1                      
group by z1.name_objects, z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktn, z1.ktt, z1.a 
) z2
on electric_abons.ab_name=z2.name_abonents
where electric_abons.ab_name = '%s' AND electric_abons.obj_name='%s'
ORDER BY electric_abons.ab_name ASC;""" % (params[0],params[1],params[2],params[3],obj_title, obj_parent_title, electric_data, obj_title,obj_parent_title )
    #print sQuery    
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('daily',dm)
        return sQuery
    else: return """Select 'Н/Д'"""
    


def makeSqlQuery_electric_by_period(obj_title, obj_parent_title, date_start, date_end, params,res, dm):
    sQuery="""
Select z3.ab_name, z3.factory_number_manual,
z3.t0_start, z3.t1_start, z3.t2_start, z3.t3_start, z3.t4_start, 
z4.t0_end, z4.t1_end, z4.t2_end, z4.t3_end, z4.t4_end,  
z4.t0_end-z3.t0_start as delta_t0, z4.t1_end-z3.t1_start as delta_t1, z4.t2_end-z3.t2_start as delta_t2, z4.t3_end-z3.t3_start as delta_t3, z4.t4_end-z3.t4_start as delta_t4,
z3.t0R_start, z4.t0R_end,  z4.t0R_end-z3.t0R_start as delta_t0R, z4.ktt,
z4.ktt*z4.ktn*(z4.t0_end-z3.t0_start), z4.ktt*z4.ktn*(z4.t0R_end-z3.t0R_start), z4.ktn, z4.a
from
(Select z2.ktt, z2.ktn, z2.a,z2.date as date_start, electric_abons.obj_name, electric_abons.ab_name, electric_abons.factory_number_manual, z2.name_res, z2.t0 as t0_end, z2.t1 as t1_end, z2.t2 as t2_end, z2.t3 as t3_end, z2.t4 as t4_end, z2.t0r as t0r_end
from electric_abons
Left join
(SELECT z1.ktt, z1.ktn,z1.a,z1.date, z1.name_objects, z1.name as name_abonent, z1.num_manual, z1.name_res,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t1,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t2,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t3,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t4,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0R
                        FROM
                        (
                                SELECT 
                                  link_abonents_taken_params.coefficient_2 as ktn,
                                  link_abonents_taken_params.coefficient as ktt,
                                  link_abonents_taken_params.coefficient_3 as a,
                                  daily_values.date,    
                                  daily_values.value,                            
                                  abonents.name, 
                                  daily_values.id_taken_params, 
                                  objects.name as name_objects,
                                  names_params.name as params_name,
                                  meters.factory_number_manual as num_manual, 
                                  resources.name as name_res
                                FROM 
                                  public.daily_values, 
                                  public.link_abonents_taken_params, 
                                  public.taken_params, 
                                  public.abonents, 
                                  public.objects, 
                                  public.names_params, 
                                  public.params, 
                                  public.meters, 
                                  public.resources
                                WHERE 
                                  taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                                  taken_params.id = daily_values.id_taken_params AND
                                  taken_params.guid_params = params.guid AND
                                  taken_params.guid_meters = meters.guid AND
                                  abonents.guid = link_abonents_taken_params.guid_abonents AND
                                  objects.guid = abonents.guid_objects AND
                                  names_params.guid = params.guid_names_params AND
                                  resources.guid = names_params.guid_resources AND                                  
                                  objects.name = '%s' AND 
                                  abonents.name='%s' and
                                  daily_values.date = '%s' AND 
                                  resources.name = '%s'
                                   group by 
                         daily_values.date,
                        daily_values.id_taken_params,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3,
                          resources.name
                                  ) z1                       
                      group by z1.name, z1.date, z1.name_objects, z1.name, z1.num_manual, z1.name_res, z1.ktt, z1.ktn, z1.a
                      order by z1.name) z2
on electric_abons.factory_number_manual=z2.num_manual
where electric_abons.obj_name='%s') z4, 

(Select z2.date as date_start, electric_abons.obj_name, electric_abons.ab_name, electric_abons.factory_number_manual, z2.name_res, z2.t0 as t0_start, z2.t1 as t1_start, z2.t2 as t2_start, z2.t3 as t3_start, z2.t4 as t4_start, z2.t0r as t0r_start
from electric_abons
Left join
(SELECT z1.date, z1.name_objects, z1.name as name_abonent, z1.num_manual, z1.name_res,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t1,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t2,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t3,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t4,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0R

                        FROM
                        (
SELECT 
                                  daily_values.date,    
                                  daily_values.value,                            
                                  abonents.name, 
                                  daily_values.id_taken_params, 
                                  objects.name as name_objects,
                                  names_params.name as params_name,
                                  meters.factory_number_manual as num_manual, 
                                  resources.name as name_res
                                FROM 
                                  public.daily_values, 
                                  public.link_abonents_taken_params, 
                                  public.taken_params, 
                                  public.abonents, 
                                  public.objects, 
                                  public.names_params, 
                                  public.params, 
                                  public.meters, 
                                  public.resources
                                WHERE 
                                  taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                                  taken_params.id = daily_values.id_taken_params AND
                                  taken_params.guid_params = params.guid AND
                                  taken_params.guid_meters = meters.guid AND
                                  abonents.guid = link_abonents_taken_params.guid_abonents AND
                                  objects.guid = abonents.guid_objects AND
                                  names_params.guid = params.guid_names_params AND
                                  resources.guid = names_params.guid_resources AND                                  
                                  objects.name = '%s' AND 
                                  abonents.name='%s' and
                                  daily_values.date = '%s' AND 
                                  resources.name = '%s'
                                   group by 
                         daily_values.date,
                        daily_values.id_taken_params,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3,
                          resources.name
                                  ) z1                       
                      group by z1.name, z1.date, z1.name_objects, z1.name, z1.num_manual, z1.name_res
                      order by z1.name) z2
on electric_abons.factory_number_manual=z2.num_manual
where electric_abons.obj_name='%s') z3
where z3.ab_name=z4.ab_name and z3.ab_name='%s' and z3.factory_number_manual=z4.factory_number_manual """ % (params[0],params[1],params[2],params[3], params[4], params[5],  obj_parent_title, obj_title, date_end, res, obj_parent_title, 
                            params[0],params[1],params[2],params[3], params[4], params[5],obj_parent_title, obj_title, date_start, res,obj_parent_title, obj_title)
    #
    # print sQuery
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('daily',dm)    
    return sQuery

def makeSqlQuery_electric_by_period_for_all(obj_title, obj_parent_title, date_start, date_end,params, res,dm):
    sQuery="""
Select z3.ab_name, z3.factory_number_manual,
z3.t0_start, z3.t1_start, z3.t2_start, z3.t3_start, z3.t4_start, 
z4.t0_end, z4.t1_end, z4.t2_end, z4.t3_end, z4.t4_end,  
z4.t0_end-z3.t0_start as delta_t0, z4.t1_end-z3.t1_start as delta_t1, z4.t2_end-z3.t2_start as delta_t2, z4.t3_end-z3.t3_start as delta_t3, z4.t4_end-z3.t4_start as delta_t4,
z3.t0R_start, z4.t0R_end,  z4.t0R_end-z3.t0R_start as delta_t0R, z4.ktt,  
z4.ktt*z4.ktn*(z4.t0_end-z3.t0_start), z4.ktt*z4.ktn*(z4.t0R_end-z3.t0R_start),z4.ktn,z4.a
from
(Select z2.ktt, z2.ktn, z2.a, z2.date as date_end, electric_abons.obj_name, electric_abons.ab_name, electric_abons.factory_number_manual, z2.name_res, z2.t0 as t0_end, z2.t1 as t1_end, z2.t2 as t2_end, z2.t3 as t3_end, z2.t4 as t4_end, z2.t0r as t0r_end
from electric_abons
Left join
(SELECT z1.ktt, z1.ktn, z1.a,z1.date, z1.name_objects, z1.name as name_abonent, z1.num_manual, z1.name_res,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t1,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t2,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t3,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t4,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0R

                        FROM
                        (
SELECT 
                                  link_abonents_taken_params.coefficient_2 as ktn,
                                  link_abonents_taken_params.coefficient as ktt,
                                  link_abonents_taken_params.coefficient_3 as a,
                                  daily_values.date,    
                                  daily_values.value,                            
                                  abonents.name, 
                                  daily_values.id_taken_params, 
                                  objects.name as name_objects,
                                  names_params.name as params_name,
                                  meters.factory_number_manual as num_manual, 
                                  resources.name as name_res
                                FROM 
                                  public.daily_values, 
                                  public.link_abonents_taken_params, 
                                  public.taken_params, 
                                  public.abonents, 
                                  public.objects, 
                                  public.names_params, 
                                  public.params, 
                                  public.meters, 
                                  public.resources
                                WHERE 
                                  taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                                  taken_params.id = daily_values.id_taken_params AND
                                  taken_params.guid_params = params.guid AND
                                  taken_params.guid_meters = meters.guid AND
                                  abonents.guid = link_abonents_taken_params.guid_abonents AND
                                  objects.guid = abonents.guid_objects AND
                                  names_params.guid = params.guid_names_params AND
                                  resources.guid = names_params.guid_resources AND                                  
                                  objects.name = '%s' AND 
                                  daily_values.date = '%s' AND 
                                  resources.name = '%s'
                                   group by 
                         daily_values.date,
                        daily_values.id_taken_params,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3,
                          resources.name
                                  ) z1                       
                      group by z1.name, z1.date, z1.name_objects, z1.name, z1.num_manual, z1.name_res, z1.ktt, z1.ktn,z1.a
                      order by z1.name) z2
on electric_abons.factory_number_manual=z2.num_manual
where electric_abons.obj_name='%s') z4, 


(Select z2.date as date_start, electric_abons.obj_name, electric_abons.ab_name, electric_abons.factory_number_manual, z2.name_res, z2.t0 as t0_start, z2.t1 as t1_start, z2.t2 as t2_start, z2.t3 as t3_start, z2.t4 as t4_start, z2.t0r as t0r_start
from electric_abons
Left join
(SELECT z1.date, z1.name_objects, z1.name as name_abonent, z1.num_manual, z1.name_res,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t1,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t2,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t3,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t4,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0R

                        FROM
                        (
SELECT 
                                  daily_values.date,    
                                  daily_values.value,                            
                                  abonents.name, 
                                  daily_values.id_taken_params, 
                                  objects.name as name_objects,
                                  names_params.name as params_name,
                                  meters.factory_number_manual as num_manual, 
                                  resources.name as name_res
                                FROM 
                                  public.daily_values, 
                                  public.link_abonents_taken_params, 
                                  public.taken_params, 
                                  public.abonents, 
                                  public.objects, 
                                  public.names_params, 
                                  public.params, 
                                  public.meters, 
                                  public.resources
                                WHERE 
                                  taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                                  taken_params.id = daily_values.id_taken_params AND
                                  taken_params.guid_params = params.guid AND
                                  taken_params.guid_meters = meters.guid AND
                                  abonents.guid = link_abonents_taken_params.guid_abonents AND
                                  objects.guid = abonents.guid_objects AND
                                  names_params.guid = params.guid_names_params AND
                                  resources.guid = names_params.guid_resources AND                                  
                                  objects.name = '%s' AND 
                                  daily_values.date = '%s' AND 
                                  resources.name = '%s'
                                   group by 
                         daily_values.date,
                        daily_values.id_taken_params,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3,
                          resources.name
                                  ) z1                       
                      group by z1.name, z1.date, z1.name_objects, z1.name, z1.num_manual, z1.name_res
                      order by z1.name) z2
on electric_abons.factory_number_manual=z2.num_manual
where electric_abons.obj_name='%s') z3
where z3.ab_name=z4.ab_name and z3.factory_number_manual=z4.factory_number_manual
order by z3.ab_name ASC""" % (params[0],params[1],params[2],params[3], params[4], params[5], obj_title, date_end, res, obj_title, 
                            params[0],params[1],params[2],params[3], params[4], params[5],obj_title,  date_start, res,obj_title)
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('daily',dm)
    #
    # print sQuery
    return sQuery

def get_data_table_electric_parametr_by_period_v2(isAbon,obj_title, obj_parent_title, electric_data_start, electric_data_end, params, res, dm):
    cursor = connection.cursor()
    #isAbon - запрос для абонента или для корпуса
    if isAbon:
        cursor.execute(makeSqlQuery_electric_by_period(obj_title, obj_parent_title, electric_data_start, electric_data_end,params, res, dm))
    else:
        cursor.execute(makeSqlQuery_electric_by_period_for_all(obj_title, obj_parent_title, electric_data_start, electric_data_end,params, res, dm))
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table

def makeSqlQuery_electric_by_period_for_group(obj_title, date_start, date_end,params, res):
    sQuery="""
    Select  z3.name_abonents, z3.number_manual,
round(z3.t0_start::numeric,3), 
round(z3.t1_start::numeric,3), 
round(z3.t2_start::numeric,3), 
round(z3.t3_start::numeric,3), 
round(z3.t4_start::numeric,3), 
round(z4.t0_end::numeric,3), 
round(z4.t1_end::numeric,3), 
round(z4.t2_end::numeric,3), 
round(z4.t3_end::numeric,3), 
round(z4.t4_end::numeric,3),  
round((z4.t0_end-z3.t0_start)::numeric,3) as delta_t0, 
round((z4.t1_end-z3.t1_start)::numeric,3) as delta_t1, 
round((z4.t2_end-z3.t2_start)::numeric,3) as delta_t2, 
round((z4.t3_end-z3.t3_start)::numeric,3) as delta_t3, 
round((z4.t4_end-z3.t4_start)::numeric,3) as delta_t4,
round(z3.t0R_start::numeric,3), 
round(z4.t0R_end::numeric,3),  
round((z4.t0R_end-z3.t0R_start)::numeric,3) as delta_t0R, z4.ktt, z4.ktn, 
round((z4.ktt*z4.ktn*(z4.t0_end-z3.t0_start))::numeric,3), 
round((z4.ktt*z4.ktn*(z4.t0R_end-z3.t0R_start))::numeric,3)
from
(Select z2.group_name, z2.ktt, z2.ktn, z2.date as date_end, electric_groups.name_group, electric_groups.name_abonents, electric_groups.number_manual, z2.name_res, z2.t0 as t0_end, z2.t1 as t1_end, z2.t2 as t2_end, z2.t3 as t3_end, z2.t4 as t4_end, z2.t0r as t0r_end
from electric_groups
Left join
(SELECT z1.group_name,z1.ktt, z1.ktn, z1.date, z1.name_objects, z1.name as name_abonent, z1.num_manual, z1.name_res,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t1,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t2,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t3,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t4,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0R

                        FROM
                        (
SELECT 
                                  link_abonents_taken_params.coefficient_2 as ktt,
                                  link_abonents_taken_params.coefficient as ktn,
                                  daily_values.date,    
                                  daily_values.value,                            
                                  abonents.name, 
                                  daily_values.id_taken_params, 
                                  objects.name as name_objects,
                                  names_params.name as params_name,
                                  meters.factory_number_manual as num_manual, 
                                  resources.name as name_res,
                                  balance_groups.name as group_name
                                  
                                FROM 
                                  public.balance_groups,
                                  public.link_balance_groups_meters,
                                  public.daily_values, 
                                  public.link_abonents_taken_params, 
                                  public.taken_params, 
                                  public.abonents, 
                                  public.objects, 
                                  public.names_params, 
                                  public.params, 
                                  public.meters, 
                                  public.resources
                                WHERE 
                                  balance_groups.guid= link_balance_groups_meters.guid_balance_groups and
                                  link_balance_groups_meters.guid_meters=meters.guid and
                                  taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                                  taken_params.id = daily_values.id_taken_params AND
                                  taken_params.guid_params = params.guid AND
                                  taken_params.guid_meters = meters.guid AND
                                  abonents.guid = link_abonents_taken_params.guid_abonents AND
                                  objects.guid = abonents.guid_objects AND
                                  names_params.guid = params.guid_names_params AND
                                  resources.guid = names_params.guid_resources AND                                  
                                  balance_groups.name = '%s' AND 
                                  daily_values.date = '%s' AND 
                                  resources.name = '%s'
                                  group by 
                         daily_values.date,
                        daily_values.id_taken_params,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3,
                          resources.name,
                           balance_groups.name
                                  ) z1                       
                      group by z1.name, z1.date, z1.name_objects, z1.name, z1.num_manual, z1.name_res, z1.ktt, z1.ktn, z1.group_name
                      order by z1.name) z2
on electric_groups.name_abonents=z2.name_abonent
where z2.group_name= '%s' ) z4, 


(Select z2.group_name,  z2.date as date_start, electric_groups.name_group, electric_groups.name_abonents, electric_groups.number_manual, z2.name_res, z2.t0 as t0_start, z2.t1 as t1_start, z2.t2 as t2_start, z2.t3 as t3_start, z2.t4 as t4_start, z2.t0r as t0r_start
from electric_groups
Left join
(SELECT z1.group_name,z1.date, z1.name_objects, z1.name as name_abonent, z1.num_manual, z1.name_res,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t1,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t2,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t3,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t4,
sum(Case when z1.params_name = '%s' then z1.value else null end) as t0R
                        FROM
                        (
SELECT 
                                  daily_values.date,    
                                  daily_values.value,                            
                                  abonents.name, 
                                  daily_values.id_taken_params, 
                                  objects.name as name_objects,
                                  names_params.name as params_name,
                                  meters.factory_number_manual as num_manual, 
                                  resources.name as name_res,
                                  balance_groups.name as group_name
                                FROM 
                                  public.balance_groups,
                                  public.link_balance_groups_meters,
                                  public.daily_values, 
                                  public.link_abonents_taken_params, 
                                  public.taken_params, 
                                  public.abonents, 
                                  public.objects, 
                                  public.names_params, 
                                  public.params, 
                                  public.meters, 
                                  public.resources
                                WHERE 
                                  balance_groups.guid= link_balance_groups_meters.guid_balance_groups and
                                  link_balance_groups_meters.guid_meters=meters.guid and
                                  taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                                  taken_params.id = daily_values.id_taken_params AND
                                  taken_params.guid_params = params.guid AND
                                  taken_params.guid_meters = meters.guid AND
                                  abonents.guid = link_abonents_taken_params.guid_abonents AND
                                  objects.guid = abonents.guid_objects AND
                                  names_params.guid = params.guid_names_params AND
                                  resources.guid = names_params.guid_resources AND                                  
                                  balance_groups.name = '%s' AND 
                                  daily_values.date = '%s' AND 
                                  resources.name = '%s'
                                  group by 
                         daily_values.date,
                        daily_values.id_taken_params,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3,
                          resources.name,
                           balance_groups.name
                                  ) z1                       
                      group by z1.name, z1.date, z1.name_objects, z1.name, z1.num_manual, z1.name_res, z1.group_name
                      order by z1.name) z2
on electric_groups.name_abonents=z2.name_abonent
where z2.group_name = '%s') z3
where z3.name_abonents=z4.name_abonents

order by z3.name_abonents ASC
    """%(params[0],params[1],params[2],params[3], params[4], params[5], obj_title, date_end, res, obj_title, 
                            params[0],params[1],params[2],params[3], params[4], params[5],obj_title,  date_start, res,obj_title)
    #print sQuery
    return sQuery

def get_data_table_electric_parametr_by_period_for_group_v2(obj_title, electric_data_start, electric_data_end, params, res):
    cursor = connection.cursor()
    cursor.execute(makeSqlQuery_electric_by_period_for_group(obj_title, electric_data_start, electric_data_end,params, res))
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table


def get_data_table_electric_parametr_by_date_monthly(obj_title, obj_parent_title, electric_data, my_parametr ):
    cursor = connection.cursor()
    cursor.execute("""SELECT 
                        monthly_values.date, objects.name, abonents.name, meters.factory_number_manual, monthly_values.value 
                        FROM
                         public.monthly_values, public.link_abonents_taken_params, public.taken_params, public.abonents, public.objects, public.names_params, public.params, public.meters 
                        WHERE
                         taken_params.guid = link_abonents_taken_params.guid_taken_params AND taken_params.id = monthly_values.id_taken_params AND taken_params.guid_params = params.guid AND taken_params.guid_meters = meters.guid AND abonents.guid = link_abonents_taken_params.guid_abonents AND objects.guid = abonents.guid_objects AND names_params.guid = params.guid_names_params AND
                        abonents.name = %s AND 
                        objects.name = %s AND 
                        names_params.name = %s AND 
                        monthly_values.date = %s 
                        ORDER BY
                        objects.name ASC
                        ;""",[obj_title, obj_parent_title, my_parametr, electric_data])
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table
    


def get_data_table_by_date_daily_2_zones(obj_title, obj_parent_title, electric_data):
    data_table = []
    
    my_parametr = "T0 A+"    
    data_table_t0_aplus = get_data_table_electric_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr)
    
    my_parametr = "T1 A+"                
    data_table_t1_aplus = get_data_table_electric_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr)

    my_parametr = "T2 A+"                
    data_table_t2_aplus = get_data_table_electric_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr)
              
    for x in range(len(data_table_t0_aplus)):
        data_table_temp = []
        try:
            data_table_temp.append(data_table_t0_aplus[x][0]) # дата
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][2]) # имя абонента
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][3]) # заводской номер
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t1_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t2_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
            
        data_table.append(data_table_temp)
    return data_table
    
    
def get_data_table_by_date_daily_3_zones(obj_title, obj_parent_title, electric_data):
    data_table = []
    
    my_parametr = "T0 A+"    
    data_table_t0_aplus = get_data_table_electric_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr)
    
    my_parametr = "T1 A+"                
    data_table_t1_aplus = get_data_table_electric_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr)

    my_parametr = "T2 A+"                
    data_table_t2_aplus = get_data_table_electric_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr)
    
    my_parametr = "T3 A+"                
    data_table_t3_aplus = get_data_table_electric_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr)
              
    for x in range(len(data_table_t0_aplus)):
        data_table_temp = []
        try:
            data_table_temp.append(data_table_t0_aplus[x][0]) # дата
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][2]) # имя абонента
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][3]) # заводской номер
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t1_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t2_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")            
        try:
            data_table_temp.append(data_table_t3_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
            
        data_table.append(data_table_temp)
    return data_table
    
def get_data_table_by_date_monthly_2_zones(obj_title, obj_parent_title, electric_data):
    data_table = []
    
    my_parametr = "T0 A+"    
    data_table_t0_aplus = get_data_table_electric_parametr_by_date_monthly(obj_title, obj_parent_title, electric_data, my_parametr)
    
    my_parametr = "T1 A+"                
    data_table_t1_aplus = get_data_table_electric_parametr_by_date_monthly(obj_title, obj_parent_title, electric_data, my_parametr)

    my_parametr = "T2 A+"                
    data_table_t2_aplus = get_data_table_electric_parametr_by_date_monthly(obj_title, obj_parent_title, electric_data, my_parametr)
              
    for x in range(len(data_table_t0_aplus)):
        data_table_temp = []
        try:
            data_table_temp.append(data_table_t0_aplus[x][0]) # дата
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][2]) # имя абонента
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][3]) # заводской номер
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t1_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t2_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
            
        data_table.append(data_table_temp)
    return data_table
    
def get_data_table_by_date_monthly_3_zones(obj_title, obj_parent_title, electric_data):
    data_table = []
    
    my_parametr = "T0 A+"    
    data_table_t0_aplus = get_data_table_electric_parametr_by_date_monthly(obj_title, obj_parent_title, electric_data, my_parametr)
    
    my_parametr = "T1 A+"                
    data_table_t1_aplus = get_data_table_electric_parametr_by_date_monthly(obj_title, obj_parent_title, electric_data, my_parametr)

    my_parametr = "T2 A+"                
    data_table_t2_aplus = get_data_table_electric_parametr_by_date_monthly(obj_title, obj_parent_title, electric_data, my_parametr)
    
    my_parametr = "T3 A+"                
    data_table_t3_aplus = get_data_table_electric_parametr_by_date_monthly(obj_title, obj_parent_title, electric_data, my_parametr)
              
    for x in range(len(data_table_t0_aplus)):
        data_table_temp = []
        try:
            data_table_temp.append(data_table_t0_aplus[x][0]) # дата
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][2]) # имя абонента
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][3]) # заводской номер
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t0_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t1_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t2_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_t3_aplus[x][4]) # значение
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
            
        data_table.append(data_table_temp)
    return data_table

def ChangeNull(data_table, electric_data):
    #обойти в цикле все строки и добавить "Н/Д" в ячейки, где null
    if data_table == None: return []
    for i in range(len(data_table)):
        data_table[i]=list(data_table[i])
        #if i<10: print data_table[i]
        for j in range(1,len(data_table[i])):
            #print data_table[i][j]
            if (data_table[i][j] == None) or (data_table[i][j] is None) or (data_table[i][j] == "None"):
                data_table[i][j]=u'Н/Д'
                #print data_table[i][j]
        if (electric_data is not None):
            data_table[i][0]=electric_data
        data_table[i]=tuple(data_table[i])
    return data_table

def ChangeNull_and_LeaveEmptyCol(data_table, electric_data, numColEmpty):
    #обойти в цикле все строки и добавить "Н/Д" в ячейки, где null
    for i in range(len(data_table)):
        data_table[i]=list(data_table[i])
        #if i<10: print data_table[i]
        for j in range(1,len(data_table[i])):            
            if (data_table[i][j] == None) or (data_table[i][j] is None):
                if j==numColEmpty:
                    data_table[i][j]=u''
                else:
                    data_table[i][j]=u'Н/Д'
                #print data_table[i][j]
        if (electric_data is not None):
            data_table[i][0]=electric_data
        data_table[i]=tuple(data_table[i])
    return data_table

def ChangeNull_for_pulsar(data_table):
    for i in range(len(data_table)):
        data_table[i]=list(data_table[i])
        if (data_table[i][3] == 0):
            data_table[i][3]=u'Н/Д'
        if (data_table[i][5] == 0):
            data_table[i][5]=u'Н/Д'
        if (data_table[i][7] == 0):
            data_table[i][7]=u'Н/Д'
        if (data_table[i][9] == 0):
            data_table[i][9]=u'Н/Д'
        if (data_table[i][11] == 0):
            data_table[i][11]=u'Н/Д'
        if (data_table[i][13] == 0):
            data_table[i][13]=u'Н/Д'
        if (data_table[i][14] == 0):
            data_table[i][14]=u'Н/Д'
        if (data_table[i][15] == 0):
            data_table[i][15]=u'Н/Д'
            
        if (data_table[i][2] == None) or (data_table[i][2] is None):
            data_table[i][3]=u'-'            
            data_table[i][2]=u'нет'
        if (data_table[i][4] == None) or (data_table[i][4] is None):
            data_table[i][5]=u'-'  
            data_table[i][4]=u'нет'
        if (data_table[i][6] == None) or (data_table[i][6] is None):
            data_table[i][7]=u'-'  
            data_table[i][6]=u'нет'
        if (data_table[i][8] == None) or (data_table[i][8] is None):
            data_table[i][9]=u'-'  
            data_table[i][8]=u'нет'
        if (data_table[i][10] == None) or (data_table[i][10] is None):
            data_table[i][11]=u'-'  
            data_table[i][10]=u'нет'
        if (data_table[i][12] == None) or (data_table[i][12] is None):
            data_table[i][13]=u'-'  
            data_table[i][12]=u'нет'
        data_table[i]=tuple(data_table[i])
    return data_table

def get_data_table_by_date_for_group_3_zones_v3(obj_title, electric_data, dm):
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+']
    data_table=get_data_table_electric_parametr_by_date_for_group_v3(obj_title, electric_data, params, dm)
    if len(data_table)>0:
        data_table=ChangeNull(data_table, electric_data)
    return data_table

def get_data_table_by_date_for_object_3_zones_v3(obj_title, electric_data, dm):
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+']
    res=u'Электричество'
    cursor = connection.cursor()
    #dm - строка, содержащая monthly or daily для sql-запроса
    cursor.execute(makeSqlQuery_electric_by_daily_or_monthly_for_object_v3(obj_title, electric_data, params, dm, res))
    data_table = cursor.fetchall()    
    if len(data_table)>0: data_table=ChangeNull_and_LeaveEmptyCol(data_table, electric_data, 11)
    return data_table

def makeSqlQuery_electric_by_daily_or_monthly_for_group(obj_title, electric_data, params, dm):
    sQuery="""select z2.monthly_date,
 z3.name_abonents, z2.number_manual,
      z3.znak*z2.t0, z3.znak*z2.t1, z3.znak*z2.t2, z3.znak*z2.t3
from 
(SELECT  
 abonents.name as name_abonents,
  (Case when link_balance_groups_meters.type = 'True' then 1 else -1 end)  as znak
FROM 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params,
  public.meters, 
  public.link_balance_groups_meters, 
  public.balance_groups,
  public.names_params,
  public.params
WHERE 
  taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
  abonents.guid = link_abonents_taken_params.guid_abonents  AND 
  taken_params.guid_params = params.guid AND 
  names_params.guid = params.guid_names_params AND
  taken_params.guid_meters = meters.guid AND 
  meters.guid=link_balance_groups_meters.guid_meters AND
  balance_groups.guid=link_balance_groups_meters.guid_balance_groups AND
  balance_groups.name='%s' 
  GROUP BY abonents.name, link_balance_groups_meters.type) z3
Left join
(SELECT z1.guid,z1.monthly_date, z1.name_group, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t3
FROM
                        (SELECT 
                        balance_groups.guid,
 monthly_values.date as monthly_date, 
 balance_groups.name as name_group, 
 abonents.name as name_abonents, 
 meters.factory_number_manual as number_manual, 
 monthly_values.value as value_monthly, 
 names_params.name as params_name
FROM 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params,
  public.monthly_values, 
  public.meters, 
  public.link_balance_groups_meters, 
  public.balance_groups,
  public.names_params,
  public.params
WHERE 
  taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
  abonents.guid = link_abonents_taken_params.guid_abonents  AND 
  taken_params.id = monthly_values.id_taken_params AND 
  taken_params.guid_params = params.guid AND 
  names_params.guid = params.guid_names_params AND
  taken_params.guid_meters = meters.guid AND 
  meters.guid=link_balance_groups_meters.guid_meters AND
  balance_groups.guid=link_balance_groups_meters.guid_balance_groups AND
  balance_groups.name='%s' AND
  monthly_values.date = '%s') z1
group by z1.name_group, z1.monthly_date, z1.name_abonents, z1.number_manual, z1.guid
order by name_abonents ASC) z2
on z3.name_abonents=z2.name_abonents
group by z2.monthly_date,
      z2.name_group, z3.name_abonents,
      z2.number_manual, z2.t0, z2.t1, z2.t2, z2.t3, z3.znak
ORDER BY z3.name_abonents ASC;    """%(obj_title, params[0],params[1],params[2],params[3], obj_title, electric_data)

    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('monthly',dm)
        return sQuery
    else: return """Select 'Н/Д'"""

def makeSqlQuery_electric_by_daily_or_monthly(obj_title, obj_parent_title, electric_data, params, dm):
    sQuery="""
   Select  z2.daily_date,
   electric_abons.ab_name, 
   electric_abons.factory_number_manual, 
   round(z2.t0::numeric,3), 
   round(z2.t1::numeric,3), 
   round(z2.t2::numeric,3), 
   round(z2.t3::numeric,3), 
   electric_abons.obj_name,  z2.ktt, z2.ktn, z2.a 
from electric_abons
LEFT JOIN 
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t3,
z1.ktn, z1.ktt, z1.a 
                        FROM
                        (SELECT daily_values.date as daily_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        daily_values.value as value_daily, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = daily_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='Электричество' and
                 abonents.name = '%s' AND objects.name = '%s' AND                      
                        daily_values.date = '%s'
                         group by 
                        daily_values.date,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3 
                        ) z1                      
group by z1.name_objects, z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktn, z1.ktt, z1.a 
) z2
on electric_abons.factory_number_manual=z2.number_manual
where electric_abons.ab_name = '%s' AND electric_abons.obj_name='%s'
ORDER BY electric_abons.ab_name ASC;""" % (params[0],params[1],params[2],params[3],obj_title, obj_parent_title, electric_data, obj_title,obj_parent_title )
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('daily',dm)
        #print sQuery
        return sQuery
    else: return """Select 'Н/Д'"""

def makeSqlQuery_electric_by_daily_or_monthly_for_object(obj_title, electric_data, params, dm, res):
    sQuery="""Select  z2.monthly_date,
   electric_abons.ab_name, 
    electric_abons.factory_number_manual, z2.t0, z2.t1, z2.t2, z2.t3,electric_abons.obj_name, z2.ktt,z2.ktn,z2.a
from electric_abons
LEFT JOIN 
(SELECT z1.monthly_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_monthly  end) as t3,
z1.ktt,z1.ktn,z1.a
                        FROM
                        (SELECT monthly_values.date as monthly_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        monthly_values.value as value_monthly, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                         link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.monthly_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources			
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = monthly_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and
                 objects.name = '%s' AND                      
                        monthly_values.date = '%s'
                         group by 
                        daily_values.date,
                        objects.name ,
                        abonents.name ,
                        meters.factory_number_manual,
                        daily_values.value ,
                        names_params.name ,
                        link_abonents_taken_params.coefficient ,
                         link_abonents_taken_params.coefficient_2 ,
                          link_abonents_taken_params.coefficient_3 
                        ) z1                        
                      
group by z1.name_objects, z1.monthly_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktt,z1.ktn,z1.a
) z2
on electric_abons.ab_name=z2.name_abonents
where electric_abons.obj_name='%s'
ORDER BY electric_abons.ab_name ASC;
"""%(params[0],params[1],params[2],params[3], res,obj_title, electric_data, obj_title)
    #print sQuery
    if dm=='monthly' or dm=='daily' or dm=='current':
        sQuery=sQuery.replace('monthly',dm)
        #print sQuery
        return sQuery
    else: return """Select 'Н/Д'"""

def get_data_table_electric_parametr_by_date_for_group_v2(obj_title, electric_data, params, dm):
    cursor = connection.cursor()
    #dm - строка, содержащая monthly or daily для sql-запроса или current
    cursor.execute(makeSqlQuery_electric_by_daily_or_monthly_for_group(obj_title, electric_data, params, dm))
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table

    
def get_data_table_by_date_for_group_3_zones_v2(obj_title, electric_data, dm):
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+']
    data_table=get_data_table_electric_parametr_by_date_for_group_v2(obj_title, electric_data, params, dm)
    if len(data_table)>0:
        data_table=ChangeNull(data_table, electric_data)
    return data_table
    
def get_data_table_electric_parametr_by_date_for_object_v2(obj_title, electric_data, params, dm, res):
    cursor = connection.cursor()
    #dm - строка, содержащая monthly or daily для sql-запроса
    cursor.execute(makeSqlQuery_electric_by_daily_or_monthly_for_object(obj_title, electric_data, params, dm, res))
    data_table = cursor.fetchall()
    # 0 - дата, 1 - Имя объекта, 2 - Имя абонента, 3 - заводской номер, 4 - значение
    return data_table
    
def get_data_table_by_date_for_object_3_zones_v2(obj_title, electric_data, dm):
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+']
    res=u'Электричество'
    data_table=get_data_table_electric_parametr_by_date_for_object_v2(obj_title, electric_data, params, dm,res)
    if len(data_table)>0: data_table=ChangeNull(data_table, electric_data)
    return data_table
    
    
def get_data_table_by_date_monthly_3_zones_v2(obj_title, obj_parent_title, electric_data, dm):
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+']
    cursor = connection.cursor()
    #dm - строка, содержащая monthly or daily для sql-запроса
    cursor.execute(makeSqlQuery_electric_by_daily_or_monthly(obj_title, obj_parent_title, electric_data, params, dm))
    data_table = cursor.fetchall()
    if len(data_table)>0: data_table=ChangeNull(data_table, electric_data)
    return data_table

def get_data_table_by_date_monthly_3_zones_v3(obj_title, obj_parent_title, electric_data, dm):
    cursor = connection.cursor()    
    #dm - строка, содержащая monthly or daily для sql-запроса
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+']
    cursor.execute(makeSqlQuery_electric_by_daily_or_monthly_v3(obj_title, obj_parent_title, electric_data, params, dm))
    data_table=cursor.fetchall()
    if len(data_table)>0: data_table=ChangeNull_and_LeaveEmptyCol(data_table, electric_data, 11)
    return data_table
    
def get_data_table_electric_period(isAbon,obj_title,obj_parent_title, electric_data_start, electric_data_end, res, dm):
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+',u'T4 A+', u'T0 R+']
    data_table=get_data_table_electric_parametr_by_period_v2(isAbon,obj_title, obj_parent_title, electric_data_start, electric_data_end, params, res, dm)
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table

def get_data_table_electric_period_for_group(obj_title,obj_parent_title, electric_data_start, electric_data_end, res):
    data_table = []
    params=[u'T0 A+',u'T1 A+',u'T2 A+',u'T3 A+',u'T4 A+', u'T0 R+']
    data_table=get_data_table_electric_parametr_by_period_for_group_v2(obj_title, electric_data_start, electric_data_end, params, res)
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table

def get_daily_value_by_meter_name(meters_name, electric_data_end, parametr ):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                                daily_values.value
                                FROM 
                                public.daily_values, 
                                public.link_abonents_taken_params, 
                                public.taken_params, 
                                public.abonents, 
                                public.objects, 
                                public.names_params, 
                                public.params, 
                                public.meters, 
                                public.resources
                                WHERE 
                                taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                                taken_params.id = daily_values.id_taken_params AND
                                taken_params.guid_params = params.guid AND
                                taken_params.guid_meters = meters.guid AND
                                abonents.guid = link_abonents_taken_params.guid_abonents AND
                                objects.guid = abonents.guid_objects AND
                                names_params.guid = params.guid_names_params AND
                                resources.guid = names_params.guid_resources AND
                                abonents.name = %s AND 
                                daily_values.date = %s AND
                                names_params.name = %s AND
                                resources.name = 'Электричество'
                                ORDER BY
                                objects.name ASC;""",[meters_name, electric_data_end, parametr])
    simpleq = simpleq.fetchall()
    try:
        result = simpleq[0][0]
    except IndexError:
        result = u'Нет данных'
    return result
    
    
def get_30_min_by_meter_name(meters_name, electric_data_end, electric_data_time, parametr):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                                  various_values.value 

                                FROM 
                                  public.various_values, 
                                  public.meters, 
                                  public.params, 
                                  public.taken_params, 
                                  public.names_params
                                WHERE 
                                  params.guid_names_params = names_params.guid AND
                                  taken_params.guid_params = params.guid AND
                                  taken_params.guid_meters = meters.guid AND
                                  taken_params.id = various_values.id_taken_params AND
                                  meters.name = %s AND
                                  various_values.date = %s AND 
                                  various_values.time = %s AND 
                                  names_params.name = %s
                                 LIMIT 1;""",[meters_name, electric_data_end, electric_data_time, parametr])
    simpleq = simpleq.fetchall()
    try:
        result = simpleq[0][0]
    except IndexError:
        result = u'Нет данных'
    return result
    
    
def get_k_t_n(meter_name):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          link_abonents_taken_params.coefficient
                        FROM 
                          public.link_abonents_taken_params, 
                          public.taken_params, 
                          public.meters
                        WHERE 
                          link_abonents_taken_params.guid_taken_params = taken_params.guid AND
                          meters.guid = taken_params.guid_meters AND
                          meters.factory_number_manual = %s
                          LIMIT 1;""", [meter_name])

    simpleq = simpleq.fetchall()
    return simpleq[0][0]
    
    
def get_k_t_t(meter_name):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          link_abonents_taken_params.coefficient_2
                        FROM 
                          public.link_abonents_taken_params, 
                          public.taken_params, 
                          public.meters
                        WHERE 
                          link_abonents_taken_params.guid_taken_params = taken_params.guid AND
                          meters.guid = taken_params.guid_meters AND
                          meters.factory_number_manual = %s
                          LIMIT 1;""", [meter_name])
    simpleq = simpleq.fetchall()
    return simpleq[0][0]

def get_k_t_t_by_factory_number_manual(factory_number_manual):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          link_abonents_taken_params.coefficient
                        FROM 
                          public.meters, 
                          public.link_abonents_taken_params, 
                          public.taken_params
                        WHERE 
                          link_abonents_taken_params.guid_taken_params = taken_params.guid AND
                          taken_params.guid_meters = meters.guid AND
                          meters.factory_number_manual = %s
                        ORDER BY
                          link_abonents_taken_params.coefficient ASC
                        LIMIT 1;""", [factory_number_manual])
    simpleq = simpleq.fetchall()
    return simpleq[0][0]

    
def list_of_abonents_heat(parent_guid, object_name): # Отличие в сортировке
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                       abonents.name
                      FROM 
                       public.objects,
                       public.abonents
                      WHERE 
                       objects.guid = abonents.guid_objects AND
                       objects.guid_parent = %s AND
                       objects.name = %s""",[parent_guid, object_name])
    simpleq = simpleq.fetchall()
    return simpleq
    

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
def get_serial_number_by_meter_name(meters_name):
    simpleq = connection.cursor()
    simpleq.execute(""" SELECT 
                         meters.factory_number_manual
                       FROM 
                         public.meters
                       WHERE 
                         meters.factory_number_manual = %s LIMIT 1; """,[meters_name])
    simpleq = simpleq.fetchall()
    if simpleq:
        return simpleq[0][0]
    else:
        return u'Нет данных' #Во view из AskueReports не было if-else, просто return simpleq[0][0] 
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
def delta_sum_a_plus(electric_data_end): # Возвращаем потребление по группе за число по группе Литейный цех
    cursor_abonents_list = connection.cursor()
    cursor_abonents_list.execute("""
                                SELECT 
                                  meters.name,
                                  link_balance_groups_meters.type
                                FROM 
                                  public.meters, 
                                  public.link_balance_groups_meters, 
                                  public.balance_groups
                                WHERE 
                                  link_balance_groups_meters.guid_balance_groups = balance_groups.guid AND
                                  link_balance_groups_meters.guid_meters = meters.guid AND
                                  balance_groups.name = 'Литейный цех'
                                ORDER BY
                                  meters.name ASC;""")
    abonents_list = cursor_abonents_list.fetchall()
    obj_title=u'Завод'
    data_table=[]

    for x in range(len(abonents_list)):
        cursor_t0_aplus_daily_temp = connection.cursor()
        cursor_t0_aplus_daily_temp.execute("""
                    SELECT 
                      daily_values.date, 
                      daily_values.value, 
                      abonents.name, 
                      daily_values.id_taken_params, 
                      objects.name, 
                      names_params.name, 
                      meters.factory_number_manual, 
                      resources.name
                    FROM 
                      public.daily_values, 
                      public.link_abonents_taken_params, 
                      public.taken_params, 
                      public.abonents, 
                      public.objects, 
                      public.names_params, 
                      public.params, 
                      public.meters, 
                      public.resources
                    WHERE 
                      taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                      taken_params.id = daily_values.id_taken_params AND
                      taken_params.guid_params = params.guid AND
                      taken_params.guid_meters = meters.guid AND
                      abonents.guid = link_abonents_taken_params.guid_abonents AND
                      objects.guid = abonents.guid_objects AND
                      names_params.guid = params.guid_names_params AND
                      resources.guid = names_params.guid_resources AND
                      abonents.name = %s AND 
                      objects.name = %s AND 
                      names_params.name = 'T0 A+' AND 
                      daily_values.date = %s AND 
                      resources.name = 'Электричество'
                      ORDER BY
                      objects.name ASC;""",[abonents_list[x][0], obj_title, electric_data_end])
        data_table_t0_aplus_daily_temp = cursor_t0_aplus_daily_temp.fetchall()
        
        data_table_temp = []
        try:
            if abonents_list[x][1]: # Если абонент входит в группу со знаком плюс, то показания как есть
                data_table_temp.append(data_table_t0_aplus_daily_temp[0][1]*get_k_t_n(abonents_list[x][0])*get_k_t_t(abonents_list[x][0]))
            else:
                data_table_temp.append(-data_table_t0_aplus_daily_temp[0][1]*get_k_t_n(abonents_list[x][0])*get_k_t_t(abonents_list[x][0]))
        except IndexError:
            data_table_temp.append(u"Н/Д")

        data_table.append(data_table_temp)
    sum_a_plus = 0

    for x in range(len(data_table)):
        try:
            sum_a_plus = sum_a_plus + data_table[x][0]
        except:
            next
      
    if sum_a_plus:
        return sum_a_plus
    else:
        return u'Н/Д'
        
def delta_sum_r_plus(electric_data_end): # Возвращаем потребление по группе за число
    cursor_abonents_list = connection.cursor()
    cursor_abonents_list.execute("""
                        SELECT 
                          meters.name,
                          link_balance_groups_meters.type
                        FROM 
                          public.meters, 
                          public.link_balance_groups_meters, 
                          public.balance_groups
                        WHERE 
                          link_balance_groups_meters.guid_balance_groups = balance_groups.guid AND
                          link_balance_groups_meters.guid_meters = meters.guid AND
                          balance_groups.name = 'Литейный цех'
                                ORDER BY
                                  meters.name ASC;""")
    abonents_list = cursor_abonents_list.fetchall()
    obj_title=u'Завод'
    data_table=[]

    for x in range(len(abonents_list)):
        cursor_t0_rplus_daily_temp = connection.cursor()
        cursor_t0_rplus_daily_temp.execute("""
                    SELECT 
                      daily_values.date, 
                      daily_values.value, 
                      abonents.name, 
                      daily_values.id_taken_params, 
                      objects.name, 
                      names_params.name, 
                      meters.factory_number_manual, 
                      resources.name
                    FROM 
                      public.daily_values, 
                      public.link_abonents_taken_params, 
                      public.taken_params, 
                      public.abonents, 
                      public.objects, 
                      public.names_params, 
                      public.params, 
                      public.meters, 
                      public.resources
                    WHERE 
                      taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                      taken_params.id = daily_values.id_taken_params AND
                      taken_params.guid_params = params.guid AND
                      taken_params.guid_meters = meters.guid AND
                      abonents.guid = link_abonents_taken_params.guid_abonents AND
                      objects.guid = abonents.guid_objects AND
                      names_params.guid = params.guid_names_params AND
                      resources.guid = names_params.guid_resources AND
                      abonents.name = %s AND 
                      objects.name = %s AND 
                      names_params.name = 'T0 R+' AND 
                      daily_values.date = %s AND 
                      resources.name = 'Электричество'
                      ORDER BY
                      objects.name ASC;""",[abonents_list[x][0], obj_title, electric_data_end])
        data_table_t0_rplus_daily_temp = cursor_t0_rplus_daily_temp.fetchall()
        
        data_table_temp = []
        try:
            if abonents_list[x][1]: # Если абонент входит в группу со знаком плюс, то показания как есть
                data_table_temp.append(data_table_t0_rplus_daily_temp[0][1]*get_k_t_n(abonents_list[x][0])*get_k_t_t(abonents_list[x][0]))
            else:
                data_table_temp.append(-data_table_t0_rplus_daily_temp[0][1]*get_k_t_n(abonents_list[x][0])*get_k_t_t(abonents_list[x][0]))

        except IndexError:
            data_table_temp.append(u"Н/Д")

        data_table.append(data_table_temp)
    sum_r_plus = 0

    for x in range(len(data_table)):
        try:
            sum_r_plus = sum_r_plus + data_table[x][0]
        except:
            next
      
    if sum_r_plus:
        return sum_r_plus
    else:
        return u'Н/Д'
        
def product_sum(date):
    simpleq = connection.cursor()
    simpleq.execute(""" SELECT 
          sum(product_info_kilns.product_weight)
        FROM 
          public.product_info_kilns
        WHERE 
          product_info_kilns.dt = %s;""",[date])
    simpleq = simpleq.fetchall()
    return simpleq[0][0]
    
def get_daily_water_channel(meters_name, electric_data_end):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          abonents.name, 
                          meters.name, 
                          daily_values.value, 
                          daily_values.date,
                          abonents.account_2
                        FROM 
                          public.daily_values, 
                          public.taken_params, 
                          public.meters, 
                          public.params, 
                          public.abonents, 
                          public.link_abonents_taken_params
                        WHERE 
                          daily_values.id_taken_params = taken_params.id AND
                          taken_params.guid_meters = meters.guid AND
                          params.guid = taken_params.guid_params AND
                          link_abonents_taken_params.guid_abonents = abonents.guid AND
                          link_abonents_taken_params.guid_taken_params = taken_params.guid AND
                          abonents.name = %s AND 
                          daily_values.date = %s;""",[meters_name, electric_data_end])
    simpleq = simpleq.fetchall()
    
    return simpleq
    
def makeSqlQuery_heat_sayany_by_date_for_abon(obj_title, obj_parent_title , electric_data_end, my_params):
    sQuery="""
    SELECT 

  daily_values.date, 
   
  abonents.name,   
  meters.factory_number_manual, 
sum(Case when names_params.name = '%s' then daily_values.value  end) as q1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as m1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t2
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' AND 
  abonents.name = '%s' AND 
  daily_values.date = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name
    """%(my_params[1],my_params[2],my_params[3],my_params[4],obj_parent_title,my_params[0],obj_title,electric_data_end)
    return sQuery
    
def makeSqlQuery_heat_sayany_by_date_for_obj(obj_title, obj_parent_title , electric_data_end, my_params):
    sQuery="""
    select z1.date, heat_abons.ab_name, heat_abons.factory_number_manual, z1.q1, z1.m1,z1.t1, z1.t2
from heat_abons
left join
(
SELECT 
  daily_values.date,    
  abonents.name as ab_name,   
  meters.factory_number_manual, 
sum(Case when names_params.name = '%s' then daily_values.value  end) as q1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as m1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t2
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' AND 
  daily_values.date = '%s'  
  group by daily_values.date,
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name
  order by abonents.name) as z1
on heat_abons.ab_name=z1.ab_name
where heat_abons.obj_name='%s'
order by heat_abons.ab_name
  

    """%(my_params[1],my_params[2],my_params[3],my_params[4],obj_title,my_params[0],electric_data_end,obj_title)
    return sQuery

def makeSqlQuery_heat_sayany_last_read_for_abon(obj_title, obj_parent_title, my_params):
    #print my_params[1],my_params[2],my_params[3],my_params[4],obj_parent_title,my_params[0],obj_title
    #print 'Query-last reded date'
    sQuery="""
    SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
sum(Case when names_params.name = '%s' then daily_values.value  end) as q1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as m1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t2
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' AND 
  abonents.name = '%s' 
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name
 order by daily_values.date DESC
    """%(my_params[1],my_params[2],my_params[3],my_params[4],obj_parent_title,my_params[0],obj_title)
    #print 'Query-ok'
    return sQuery
    
    
def get_data_table_by_date_heat_sayany_v2(obj_title, obj_parent_title, electric_data_end, isAbon):
    my_params=[u'Sayany',u'Q Система1' ,u'M Система1',u'T Канал1',u'T Канал2' ]
    cursor = connection.cursor()
    data_table=[]
    if (isAbon) and (electric_data_end is not None):
        #print 'Abonent po date'
        cursor.execute(makeSqlQuery_heat_sayany_by_date_for_abon(obj_title, obj_parent_title , electric_data_end, my_params))
    elif isAbon and (electric_data_end is None):
        #print 'Abonent last read'
        cursor.execute(makeSqlQuery_heat_sayany_last_read_for_abon(obj_title, obj_parent_title , my_params))
    else:
        #print 'Obj po date'
        cursor.execute(makeSqlQuery_heat_sayany_by_date_for_obj(obj_title, obj_parent_title , electric_data_end, my_params))
    data_table = cursor.fetchall()
        
    
    return data_table
    
def makeSqlQuery_heat_sayany_by_last_date_for_buhgaltery(account, obj_parent_title ,  my_params,electric_data_end):
    sQuery="""
    SELECT 
  account_2, 
  '2015-01-01'::date AS date_install,
  factory_number_manual,
  'Отопление'::text AS type_energo,
  meters.name,
  daily_values.value ,
  daily_values.date, 
  substring(abonents.name from 10 for char_length(abonents.name)), 
  objects.name
 
 
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' AND 
  abonents.account_2  = '%s' and
  names_params.name = '%s'    and (daily_values.date='%s'::date-interval '1 day'
   or daily_values.date='%s'::date-interval '2 day'
   or daily_values.date='%s'::date-interval '3 day')
  
 order by daily_values.date DESC
    """%(obj_parent_title,my_params[0],account,my_params[1],electric_data_end,electric_data_end,electric_data_end)
    #print sQuery
    return sQuery
    
def get_data_table_by_date_heat_sayany_for_buhgaltery(account, obj_parent_title,electric_data_end):
    my_params=[u'Sayany',u'Q Система1' ,u'M Система1',u'T Канал1',u'T Канал2' ]
    cursor = connection.cursor()
    data_table=[]
    cursor.execute(makeSqlQuery_heat_sayany_by_last_date_for_buhgaltery(account, obj_parent_title ,  my_params,electric_data_end))
    data_table = cursor.fetchall()
            
    return data_table
    
def makeSqlQuery_heat_sayany_period_for_abon(obj_title, obj_parent_title , electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z1.ab_name,z1.zav_num, z1.Q1, z2.Q1 as q2, z2.Q1-z1.Q1 as deltaQ, 
z1.m1, z2.m1 as m2, z2.m1-z1.m1 as deltam,

z1.t1, z2.t1 as t1_2, z1.t1-z2.t1 as deltat1,
z1.t2, z2.t2 as t2_2, z1.t2-z2.t2 as deltat2
From
(SELECT 
  daily_values.date as date_start, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
sum(Case when names_params.name = '%s' then daily_values.value  end) as q1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as m1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t2
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' AND 
  abonents.name = '%s' AND 
  daily_values.date = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name) z1,
  (
  Select
  daily_values.date as date_end, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
sum(Case when names_params.name = '%s' then daily_values.value  end) as q1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as m1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t2
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' AND 
  abonents.name = '%s' AND 
  daily_values.date = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name) z2"""%(my_params[1],my_params[2],my_params[3],my_params[4],obj_parent_title,my_params[0],obj_title,electric_data_start,my_params[1],my_params[2],my_params[3],my_params[4],obj_parent_title,my_params[0],obj_title,electric_data_end)
  
    return sQuery
    
def makeSqlQuery_heat_sayany_period_for_obj(obj_title, obj_parent_title , electric_data_start, electric_data_end, my_params):
    sQuery="""
Select heat_abons.ab_name,heat_abons.factory_number_manual, z3.q1, z3.q2, z3.deltaq, z3.m1, z3.m2, z3.deltam 
from heat_abons
left join 
(Select z1.ab_name,z1.zav_num,z1.date_start, z2.date_end, z1.Q1, z2.Q1 as q2, z2.Q1-z1.Q1 as deltaQ, 
z1.m1, z2.m1 as m2, z2.m1-z1.m1 as deltam,

z1.t1, z2.t1 as t1_2, z1.t1-z2.t1 as deltat1,
z1.t2, z2.t2 as t2_2, z1.t2-z2.t2 as deltat2
From
(SELECT 
  daily_values.date as date_start, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
sum(Case when names_params.name = '%s' then daily_values.value  end) as q1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as m1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t2
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' AND 
  daily_values.date = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name) z1,
  (
  Select
  daily_values.date as date_end, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
sum(Case when names_params.name = '%s' then daily_values.value  end) as q1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as m1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t1,
sum(Case when names_params.name = '%s' then daily_values.value  end) as t2
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' AND 
  daily_values.date = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name) z2
  where z1.ab_name=z2.ab_name) z3
  on heat_abons.ab_name=z3.ab_name
  where heat_abons.obj_name='%s'
  order by heat_abons.ab_name
 
"""    %(my_params[1],my_params[2],my_params[3],my_params[4],obj_parent_title,my_params[0],electric_data_start,my_params[1],my_params[2],my_params[3],my_params[4],obj_parent_title,my_params[0],electric_data_end, obj_parent_title)
    return sQuery
    
def get_data_table_period_heat_sayany(obj_title, obj_parent_title, electric_data_start, electric_data_end, isAbon):
    my_params=[u'Sayany',u'Q Система1' ,u'M Система1',u'T Канал1',u'T Канал2' ]
    cursor = connection.cursor()
    data_table=[]
    if (isAbon) and (electric_data_end is not None):
        #print 'Abonent po date'
        cursor.execute(makeSqlQuery_heat_sayany_period_for_abon(obj_title, obj_parent_title , electric_data_start, electric_data_end, my_params))
    elif isAbon and (electric_data_end is None):
        #print 'Abonent last read'
        pass
        #cursor.execute(makeSqlQuery_heat_sayany_last_read_for_abon(obj_title, obj_parent_title , my_params))
    else:
        #print 'Obj po date'
        cursor.execute(makeSqlQuery_heat_sayany_period_for_obj( obj_parent_title,obj_title, electric_data_start, electric_data_end, my_params))
    data_table = cursor.fetchall()
            
    return data_table
    
    
def MakeQuery_all_resources(electric_data_start, electric_data_end):
    my_params=[u'Импульс',u'Q Система1',u'Электричество', u'Sayany']
#    sQuery="""    with z3 as
#(Select account_2,'%s'::date as date_start, substring(water_abons_report.ab_name from 7 for char_length(water_abons_report.ab_name)) as meter_name,ab_name as factory_number_manual, type_energo, z2.value, z2.value_old,z2.delta,date_install,'%s'::date as date_end, obj_name as ab_name
#    from water_abons_report
#    LEFT JOIN (
#    with z1 as (SELECT 
#      meters.name, 
#      meters.factory_number_manual,
#      daily_values.date, 
#      daily_values.value, 
#      abonents.name, 
#      abonents.guid
#    FROM 
#      public.meters, 
#      public.taken_params, 
#      public.daily_values, 
#      public.abonents, 
#      public.link_abonents_taken_params,
#      params,
#      names_params,
#      resources
#    WHERE 
#      taken_params.guid_meters = meters.guid AND
#      daily_values.id_taken_params = taken_params.id AND
#      link_abonents_taken_params.guid_taken_params = taken_params.guid AND
#      link_abonents_taken_params.guid_abonents = abonents.guid and
#      params.guid=taken_params.guid_params  and
#      names_params.guid=params.guid_names_params and
#      resources.guid=names_params.guid_resources and
#      resources.name='%s'
#      and date='%s')
#    SELECT  
#      abonents.name, 
#      abonents.guid,
#      daily_values.date as date_old, 
#      daily_values.value as value_old,  
#      z1.date,
#      z1.value,
#      z1.value-daily_values.value as delta,
#      z1.factory_number_manual
#    FROM 
#      z1,
#      public.meters, 
#      public.taken_params, 
#      public.daily_values, 
#      public.abonents, 
#      public.link_abonents_taken_params,
#      params,
#      names_params,
#      resources
#    WHERE 
#      z1.guid=abonents.guid and
#      taken_params.guid_meters = meters.guid AND
#      daily_values.id_taken_params = taken_params.id AND
#      link_abonents_taken_params.guid_taken_params = taken_params.guid AND
#      link_abonents_taken_params.guid_abonents = abonents.guid and
#      params.guid=taken_params.guid_params  and
#      names_params.guid=params.guid_names_params and
#      resources.guid=names_params.guid_resources and
#      resources.name='%s'
#      and daily_values.date='%s'
#    )z2
#    on z2.name=water_abons_report.ab_name
#    
#    union
#    
#    Select z2.account_2,'%s'::date as date_start, z2.meter_name, z2.factory_number_manual,  z2.type_energo,z3.val_end, z2.val_start, z3.val_end-z2.val_start as delta, z2.date_install,'%s'::date as date_end, z2.ab_name
#from
#(Select account_2,factory_number_manual, heat_abons_report.meter_name, type_energo, date_install, heat_abons_report.ab_name, z1.date_start, z1.value as val_start
#from heat_abons_report
#Left join
#(SELECT 
#  daily_values.date as date_start, 
#  objects.name as obj_name, 
#  abonents.name as ab_name,   
#  meters.factory_number_manual as zav_num, 
#  meters.name as meter_name,
#  daily_values.value
#
#FROM 
#  public.abonents, 
#  public.objects, 
#  public.link_abonents_taken_params, 
#  public.taken_params, 
#  public.daily_values, 
#  public.meters, 
#  public.types_meters, 
#  public.params, 
#  public.names_params
#WHERE 
#  abonents.guid_objects = objects.guid AND
#  link_abonents_taken_params.guid_abonents = abonents.guid AND
#  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
#  taken_params.guid_meters = meters.guid AND
#  taken_params.guid_params = params.guid AND
#  daily_values.id_taken_params = taken_params.id AND
#  meters.guid_types_meters = types_meters.guid AND
#  params.guid_names_params = names_params.guid AND
#
#  types_meters.name = '%s' AND 
#  daily_values.date = '%s' and 
#  names_params.name = '%s'
#  group by daily_values.date, 
#  objects.name, 
#  abonents.name,   
#  meters.factory_number_manual, 
#  types_meters.name,
#  daily_values.value,
#  meters.name
#  order by objects.name, 
#  abonents.name) z1
#on heat_abons_report.meter_name=z1.meter_name) z2
#Left join 
#(SELECT 
#  daily_values.date as date_end, 
#  objects.name as obj_name, 
#  abonents.name as ab_name,   
#  meters.factory_number_manual as zav_num, 
#  meters.name as meter_name,
#  daily_values.value as val_end
#
#FROM 
#  public.abonents, 
#  public.objects, 
#  public.link_abonents_taken_params, 
#  public.taken_params, 
#  public.daily_values, 
#  public.meters, 
#  public.types_meters, 
#  public.params, 
#  public.names_params
#WHERE 
#  abonents.guid_objects = objects.guid AND
#  link_abonents_taken_params.guid_abonents = abonents.guid AND
#  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
#  taken_params.guid_meters = meters.guid AND
#  taken_params.guid_params = params.guid AND
#  daily_values.id_taken_params = taken_params.id AND
#  meters.guid_types_meters = types_meters.guid AND
#  params.guid_names_params = names_params.guid AND
#
#  types_meters.name = '%s' AND 
#  daily_values.date = '%s' and 
#  names_params.name = '%s'
#  group by daily_values.date, 
#  objects.name, 
#  abonents.name,   
#  meters.factory_number_manual, 
#  types_meters.name,
#  daily_values.value,
#  meters.name
#  order by objects.name, 
#  abonents.name) z3
#  on
#  z2.meter_name=z3.meter_name
#    
#    union
#    
#    Select account_2, '%s'::date as date_start, meter_name,z2.factory_number_manual,type_energo, z2.value, z2.value_old, z2.delta,date_install,'%s'::date as date_end, ab_name
#    from electric_abons_report
#    LEFT JOIN
#    (with z1 as 
#    (SELECT 
#      abonents.name, 
#      objects.name, 
#      daily_values.date, 
#      daily_values.value, 
#      names_params.name as name_params, 
#      types_meters.name, 
#      meters.factory_number_manual,
#      meters.name as meter_name
#    FROM 
#      public.abonents, 
#      public.objects, 
#      public.link_abonents_taken_params, 
#      public.taken_params, 
#      public.daily_values, 
#      public.params, 
#      public.names_params, 
#      public.types_meters, 
#      public.meters,
#      resources
#    WHERE 
#      abonents.guid_objects = objects.guid AND
#      link_abonents_taken_params.guid_abonents = abonents.guid AND
#      link_abonents_taken_params.guid_taken_params = taken_params.guid AND
#      taken_params.guid_params = params.guid AND
#      taken_params.guid_meters = meters.guid AND
#      daily_values.id_taken_params = taken_params.id AND
#      params.guid_names_params = names_params.guid AND
#      params.guid_types_meters = types_meters.guid AND
#    
#      resources.guid=names_params.guid_resources and
#      resources.name='%s' and
#      daily_values.date = '%s'
#    )
#    SELECT 
#      abonents.name, 
#      objects.name, 
#      z1.date,
#      z1.value,
#      daily_values.date as date_old, 
#      daily_values.value as value_old, 
#      names_params.name as params_name, 
#      types_meters.name, 
#      meters.factory_number_manual,
#      meters.name as meter_name,
#      z1.value-daily_values.value as delta
#    FROM 
#    z1,
#      public.abonents, 
#      public.objects, 
#      public.link_abonents_taken_params, 
#      public.taken_params, 
#      public.daily_values, 
#      public.params, 
#      public.names_params, 
#      public.types_meters, 
#      public.meters,
#      resources
#    WHERE 
#      abonents.guid_objects = objects.guid AND
#      link_abonents_taken_params.guid_abonents = abonents.guid AND
#      link_abonents_taken_params.guid_taken_params = taken_params.guid AND
#      taken_params.guid_params = params.guid AND
#      taken_params.guid_meters = meters.guid AND
#      daily_values.id_taken_params = taken_params.id AND
#      params.guid_names_params = names_params.guid AND
#      params.guid_types_meters = types_meters.guid AND
#       resources.guid=names_params.guid_resources and
#      resources.name='%s' and
#      daily_values.date = '%s' and
#      z1.meter_name=meters.name and
#      z1.name_params=names_params.name
#      order by abonents.name, 
#      objects.name, meters.name) z2
#      on electric_abons_report.name_meter=z2.meter_name and z2.params_name=electric_abons_report.name_params
#      ) 
#Select account_2,date_start, meter_name,factory_number_manual, type_energo, z3.value, value_old,delta,date_install,date_end,substring(ab_name from 10 for char_length(ab_name)) as ab_name
#from z3 
#order by account_2, type_energo"""

    sQuery="""
with z3 as
(
Select account_2,'%s'::date as date_start, z2.factory_number_manual as meter_name,ab_name as factory_number_manual, type_energo, z2.value, z2.value_old,z2.delta,date_install,'%s'::date as date_end, obj_name as ab_name, water_abons_report.name as obj_name
from water_abons_report

LEFT JOIN (
with z1 as (SELECT 
  meters.name, 
  meters.factory_number_manual,
  daily_values.date, 
  daily_values.value, 
  abonents.name, 
  abonents.guid
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s')

SELECT  
  abonents.name, 
  abonents.guid,
  daily_values.date as date_old, 
  daily_values.value as value_old,  
  z1.date,
  z1.value,
  z1.value-daily_values.value as delta,
  z1.factory_number_manual
FROM 
  z1,
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE 
  z1.guid=abonents.guid and
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and daily_values.date='%s'
)z2
on z2.name=water_abons_report.ab_name

union

Select z2.account_2,'%s'::date as date_start, z2.meter_name, z2.factory_number_manual,  z2.type_energo,z3.val_end, z2.val_start, z3.val_end-z2.val_start as delta, z2.date_install,'%s'::date as date_end, z2.ab_name, z2.obj_name
from
(Select account_2,factory_number_manual, heat_abons_report.meter_name, type_energo, date_install, heat_abons_report.ab_name, z1.date_start, z1.value as val_start, z1.obj_name
from heat_abons_report
Left join
(SELECT 
  daily_values.date as date_start, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
  meters.name as meter_name,
  daily_values.value

FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND

  types_meters.name = '%s' AND 
  daily_values.date = '%s' and 
  names_params.name = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name,
  daily_values.value,
  meters.name
  order by objects.name, 
  abonents.name) z1
on heat_abons_report.meter_name=z1.meter_name) z2
Left join 
(SELECT 
  daily_values.date as date_end, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
  meters.name as meter_name,
  daily_values.value as val_end

FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND

  types_meters.name = '%s' AND 
  daily_values.date = '%s' and 
  names_params.name = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name,
  daily_values.value,
  meters.name
  order by objects.name, 
  abonents.name) z3
  on
  z2.meter_name=z3.meter_name



union

Select account_2, '%s'::date as date_start, meter_name,report_num_meter,type_energo, z2.value, z2.value_old, z2.delta,date_install,'%s'::date as date_end, ab_name, obj_name
from electric_abons_without_sum_report

LEFT JOIN
(with z1 as 
(SELECT 
  abonents.name, 
  objects.name, 
  daily_values.date, 
  daily_values.value, 
  names_params.name as name_params, 
  types_meters.name, 
  meters.factory_number_manual,
  meters.name as meter_name
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters, 
  public.meters,
  resources
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND

  resources.guid=names_params.guid_resources and
  resources.name='%s' and
  daily_values.date = '%s'
)

SELECT 
  abonents.name, 
  objects.name, 
  z1.date,
  z1.value,
  daily_values.date as date_old, 
  daily_values.value as value_old, 
  names_params.name as params_name, 
  types_meters.name, 
  meters.factory_number_manual,
  meters.name as meter_name,
  z1.value-daily_values.value as delta
FROM 
z1,
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters, 
  public.meters,
  resources
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
   resources.guid=names_params.guid_resources and
  resources.name='%s' and
  daily_values.date = '%s' and
  z1.meter_name=meters.name and
  z1.name_params=names_params.name
  order by abonents.name, 
  objects.name, meters.name) z2
  on electric_abons_without_sum_report.name_meter=z2.meter_name and z2.params_name=electric_abons_without_sum_report.name_params
) 
Select account_2,date_start, meter_name,factory_number_manual, type_energo, z3.value, value_old,delta,date_install,date_end,substring(ab_name from 10 for char_length(ab_name)) as ab_name, obj_name
from z3 
order by account_2, obj_name, ab_name, type_energo
    """%(electric_data_start,electric_data_end,my_params[0],electric_data_end,my_params[0],electric_data_start, 
                                    electric_data_start,electric_data_end,my_params[3], electric_data_start,my_params[1],my_params[3],electric_data_end,my_params[1], 
                                    electric_data_start, electric_data_end, my_params[2], electric_data_end,my_params[2],electric_data_start)

    return sQuery
    
def get_data_table_report_all_res_period3(electric_data_start, electric_data_end):
    cursor = connection.cursor()
    data_table=[]
    #my_params=[u'Импульс',u'Саяны Комбик Q Система1 Суточный -- adress: 0  channel: 1',u'Электричество']
    cursor.execute(MakeQuery_all_resources(electric_data_start, electric_data_end))
    data_table = cursor.fetchall()
    return data_table

def MakeQuery_all_resources_by_date( electric_data_end):
    my_params=[u'Импульс',u'Меркурий 230', u'Sayany', u'Q Система1']
    sQuery="""
    with z3 as (Select account_2,date_install, substring(water_abons_report.ab_name from 7 for char_length(water_abons_report.ab_name)) as factory_number,type_energo,z1.meters_name, z1.value, z1.date,substring(obj_name from 10 for char_length(obj_name)) as abonent, water_abons_report.name as obj_name
from water_abons_report
LEFT JOIN 
(SELECT 
  meters.name as meters_name, 
  daily_values.date, 
  daily_values.value, 
  abonents.name as ab_name, 
  abonents.guid
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid 
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s') z1
  on z1.ab_name=water_abons_report.ab_name

union

Select account_2,date_install,report_num_meter,type_energo,electric_abons_without_sum_report.report_factory_number_manual, z1.value,z1.date_start, substring(electric_abons_without_sum_report.ab_name from 10 for char_length(electric_abons_without_sum_report.ab_name)) as abonent, electric_abons_without_sum_report.obj_name
from electric_abons_without_sum_report
Left join
(
SELECT 
  daily_values.date as date_start, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
  meters.name as meter_name,
  daily_values.value,
  names_params.name as names_params
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  types_meters.name = '%s' AND 
  daily_values.date = '%s'   
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name,
  daily_values.value,
  meters.name,
  names_params.name
  order by objects.name, 
  abonents.name) z1
on electric_abons_without_sum_report.name_meter=z1.meter_name and z1.names_params=electric_abons_without_sum_report.name_params

union

Select account_2,date_install,factory_number_manual,type_energo,heat_abons_report.meter_name, z1.value,z1.date_start, substring(heat_abons_report.ab_name from 10 for char_length(heat_abons_report.ab_name)) as abonent, heat_abons_report.obj_name
from heat_abons_report
Left join
(SELECT 
  daily_values.date as date_start, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
  meters.name as meter_name,
  daily_values.value
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  types_meters.name = '%s' AND 
  daily_values.date = '%s' and 
  names_params.name = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name,
  daily_values.value,
  meters.name
  order by objects.name, 
  abonents.name) z1
on heat_abons_report.meter_name=z1.meter_name) 

Select z3.account_2,z3.date_install, z3.factory_number,z3.type_energo,z3.meters_name, z3.value, z3.date, abonent, obj_name
from z3 
order by account_2, obj_name, abonent, type_energo
    """%(my_params[0], electric_data_end, my_params[1], electric_data_end, my_params[2], electric_data_end, my_params[3])
    #print sQuery
    return sQuery
def get_data_table_report_all_res_by_date(electric_data_end):
    cursor = connection.cursor()
    data_table=[]
    cursor.execute(MakeQuery_all_resources_by_date( electric_data_end))
    data_table = cursor.fetchall()
    return data_table

def MakeQuery_electric_resources_by_date( electric_data_end):
    my_params=[u'Меркурий 230']
    sQuery="""
    Select account_2,date_install,report_num_meter,type_energo,electric_abons_without_sum_report.report_factory_number_manual, z1.value,z1.date_start, substring(electric_abons_without_sum_report.ab_name from 10 for char_length(electric_abons_without_sum_report.ab_name)) as ab_name, electric_abons_without_sum_report.obj_name, electric_abons_without_sum_report.report_factory_number_manual
from electric_abons_without_sum_report
Left join
(
SELECT 
  daily_values.date as date_start, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
  meters.name as meter_name,
  daily_values.value,
  names_params.name as names_params
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  types_meters.name = '%s' AND 
  daily_values.date = '%s'   
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name,
  daily_values.value,
  meters.name,
  names_params.name
  order by objects.name, 
  abonents.name) z1
on electric_abons_without_sum_report.name_meter=z1.meter_name and z1.names_params=electric_abons_without_sum_report.name_params
order by account_2, electric_abons_without_sum_report.ab_name,type_energo
    """%(my_params[0], electric_data_end)
    return sQuery

def get_data_table_report_electric_res_by_date(electric_data_end):
    cursor = connection.cursor()
    data_table=[]
    cursor.execute(MakeQuery_electric_resources_by_date(electric_data_end))
    data_table = cursor.fetchall()
    return data_table

def MakeQuery_water_resources_by_date( electric_data_end):
    my_params=[u'Импульс']
    sQuery="""
Select account_2,date_install, substring(water_abons_report.ab_name from 7 for char_length(water_abons_report.ab_name)) as factory_number,type_energo,z1.meters_name, z1.value, z1.date,substring(obj_name from 10 for char_length(obj_name)), water_abons_report.name as obj_name
from water_abons_report
LEFT JOIN 
(SELECT 
  meters.name as meters_name, 
  daily_values.date, 
  daily_values.value, 
  abonents.name as ab_name, 
  abonents.guid
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid 
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s') z1
  on z1.ab_name=water_abons_report.ab_name
order by account_2
    """%(my_params[0], electric_data_end)
    return sQuery

def get_data_table_report_water_res_by_date(electric_data_end):
    cursor = connection.cursor()
    data_table=[]
    cursor.execute(MakeQuery_water_resources_by_date(electric_data_end))
    data_table = cursor.fetchall()
    return data_table

def MakeQuery_heat_resources_by_date( electric_data_end):
    my_params=[u'Sayany', u'Q Система1']
    sQuery="""
Select account_2,date_install,factory_number_manual,type_energo,heat_abons_report.meter_name, z1.value,z1.date_start, substring(heat_abons_report.ab_name from 10 for char_length(heat_abons_report.ab_name)), heat_abons_report.obj_name
from heat_abons_report
Left join
(SELECT 
  daily_values.date as date_start, 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  meters.factory_number_manual as zav_num, 
  meters.name as meter_name,
  daily_values.value

FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND

  types_meters.name = '%s' AND 
  daily_values.date = '%s' and 
  names_params.name = '%s'
  group by daily_values.date, 
  objects.name, 
  abonents.name,   
  meters.factory_number_manual, 
  types_meters.name,
  daily_values.value,
  meters.name
  order by objects.name, 
  abonents.name) z1
on heat_abons_report.meter_name=z1.meter_name
order by account_2


    """%(my_params[0], electric_data_end, my_params[1])
    return sQuery

def get_data_table_report_heat_res_by_date(electric_data_end):
    cursor = connection.cursor()
    data_table=[]
    cursor.execute(MakeQuery_heat_resources_by_date(electric_data_end))
    data_table = cursor.fetchall()
    return data_table
    
def get_data_table_report_all_res_period2(electric_data_start, electric_data_end):
    cursor = connection.cursor()
    data_table=[]
    cursor.execute(
"""Select account_2,%s::date as date_start, z2.factory_number_manual, ab_name, type_energo, z2.value, z2.value_old,z2.delta,date_install,%s::date as date_end, obj_name as ab_name
from water_abons_report
LEFT JOIN (
with z1 as (SELECT 
  meters.name, 
  meters.factory_number_manual,
  daily_values.date, 
  daily_values.value, 
  abonents.name, 
  abonents.guid
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params
WHERE 
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  meters.name LIKE '%%Пульсар%%'
  and date=%s)
SELECT  
  abonents.name, 
  abonents.guid,
  daily_values.date as date_old, 
  daily_values.value as value_old,  
  z1.date,
  z1.value,
  z1.value-daily_values.value as delta,
  z1.factory_number_manual
FROM 
  z1,
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params
WHERE 
  z1.guid=abonents.guid and
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  meters.name LIKE '%%Пульсар%%'
  and daily_values.date=%s
)z2
on z2.name=water_abons_report.ab_name
union
Select account_2,%s::date as date_start, meter_name,z2.factory_number_manual,type_energo, z2.value_old, z2.value,z2.delta,date_install,%s::date as date_end, ab_name
from heat_abons_report
LEFT JOIN
(with z1 as (SELECT 
  abonents.name, 
  objects.name, 
  daily_values.date as date_old, 
  daily_values.value as value_old, 
  meters.name as name_meters,
  meters.factory_number_manual,
  params.name
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters,
  params
WHERE 
  taken_params.guid_params=params.guid and
   abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.name LIKE '%%Sayany%%' and
  daily_values.date = %s and
   params.name='Саяны Комбик Q Система1 Суточный -- adress: 0  channel: 1'
  group by 
  abonents.name, 
  objects.name, 
  daily_values.date, 
  daily_values.value, 
  meters.name,
  meters.factory_number_manual,
  params.name)
  SELECT 
  abonents.name, 
  objects.name, 
  z1.date_old,
  z1.value_old,
  daily_values.date, 
  daily_values.value, 
  meters.name as name_meters,
  params.name,
  z1.factory_number_manual,
  z1.value_old-daily_values.value as delta
FROM 
  z1,
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters,
  params
WHERE 
  taken_params.guid_params=params.guid and
   abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.name LIKE '%%Sayany%%' and
  daily_values.date = %s and
  params.name='Саяны Комбик Q Система1 Суточный -- adress: 0  channel: 1'
  and meters.name = z1.name_meters
  group by 
  z1.factory_number_manual,
  abonents.name, 
  objects.name, 
  daily_values.date, 
  daily_values.value, 
  meters.name,
  params.name,
  z1.date_old,
  z1.value_old) z2
  on z2.name_meters=heat_abons_report.meter_name
union
Select account_2, %s::date as date_start, meter_name,z2.factory_number_manual,type_energo, z2.value, z2.value_old, z2.delta,date_install,%s::date as date_end, ab_name
from electric_abons_report
LEFT JOIN
(with z1 as 
(SELECT 
  abonents.name, 
  objects.name, 
  daily_values.date, 
  daily_values.value, 
  names_params.name as name_params, 
  types_meters.name, 
  meters.factory_number_manual,
  meters.name as meter_name
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters, 
  public.meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  types_meters.name LIKE '%%Меркурий%%230%%' AND 
  daily_values.date = %s
)
SELECT 
  abonents.name, 
  objects.name, 
  z1.date,
  z1.value,
  daily_values.date as date_old, 
  daily_values.value as value_old, 
  names_params.name as params_name, 
  types_meters.name, 
  meters.factory_number_manual,
  meters.name as meter_name,
  z1.value-daily_values.value as delta
FROM 
z1,
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters, 
  public.meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  types_meters.name LIKE '%%Меркурий%%230%%' AND 
  daily_values.date = %s and
  z1.meter_name=meters.name and
  z1.name_params=names_params.name
  order by abonents.name, 
  objects.name, meters.name) z2
  on electric_abons_report.name_meter=z2.meter_name and z2.params_name=electric_abons_report.name_params
  order by account_2
    """,[electric_data_start,electric_data_end,electric_data_end,electric_data_start, electric_data_start,electric_data_end,electric_data_end,electric_data_start, electric_data_start,electric_data_end, electric_data_end,electric_data_start])
    data_table = cursor.fetchall()
   
    return data_table

def MakeSqlQuery_water_tekon_daily_for_abonent(obj_parent_title, obj_title, electric_data_end, chanel, my_params, type_meter):
    sQuery="""
SELECT 
  daily_values.date,
  abonents.name as ab_name, 
  meters.factory_number_manual ,
  daily_values.value, types_meters.name as meter_type
  
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.names_params, 
  public.params, 
  public.resources, 
  public.meters , types_meters
WHERE 
types_meters.guid=params.guid_types_meters and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid
  And   
   names_params.name='%s' and
   resources.name='%s' and
   objects.name='%s' and
   abonents.name='%s' and
   daily_values.date='%s'  
   and types_meters.name='%s' 
    """%(chanel,my_params[0], obj_parent_title, obj_title, electric_data_end, type_meter)
    #print sQuery
    return sQuery
    
def MakeSqlQuery_water_tekon_daily_for_object(obj_parent_title, obj_title, electric_data_end, chanel, my_params, type_meter):
    sQuery="""
    Select z1.date, water_abons.ab_name, water_abons.factory_number_manual, z1.value
from public.water_abons
left join 
(SELECT 
  daily_values.date,
  abonents.name as ab_name, 
  meters.factory_number_manual ,
  daily_values.value, types_meters.name as meter_type
  
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.names_params, 
  public.params, 
  public.resources, 
  public.meters , types_meters
WHERE 
types_meters.guid=params.guid_types_meters and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid
  And   
   names_params.name='%s' and
   resources.name='%s' and
   objects.name='%s' and
   daily_values.date='%s'  
   and types_meters.name='%s' ) as z1
   
   on water_abons.ab_name=z1.ab_name
   where water_abons.obj_name='%s' 
   and water_abons.params_name='%s'   
  
   order by water_abons.ab_name
    """%(chanel,my_params[0], obj_title, electric_data_end,type_meter, obj_title, chanel)
    return sQuery
    
def get_data_table_tekon_daily(obj_title,obj_parent_title, electric_data_end, chanel, type_meter, isAbon):
    my_params=[u'Импульс']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_tekon_daily_for_abonent(obj_parent_title, obj_title, electric_data_end, chanel, my_params, type_meter))
    else:
        cursor.execute(MakeSqlQuery_water_tekon_daily_for_object(obj_parent_title, obj_title, electric_data_end, chanel, my_params, type_meter))
    data_table = cursor.fetchall()
    
    return data_table
    


def get_data_table_tekon_heat_daily(obj_title,obj_parent_title, electric_data_end, chanel, type_meter, isAbon):
    my_params=[u'Импульс']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_tekon_daily_for_abonent(obj_parent_title, obj_title, electric_data_end, chanel, my_params, type_meter))
    else:
        cursor.execute(MakeSqlQuery_water_tekon_daily_for_object(obj_parent_title, obj_title, electric_data_end, chanel, my_params, type_meter))
    data_table = cursor.fetchall()
    
    return data_table

def MakeSqlQuery_water_by_date_for_korp(meters_name, parent_name, electric_data_end, my_param, dc):
    sQuery="""
Select z2.date, obj_name as ab_name, water_abons_report.ab_name as meter_name,  z2.meter_name, z2.name_params, z2.value 
from water_abons_report

LEFT JOIN (
SELECT 
  daily_values.date,
  obj_name as ab_name,
  abonents.name as meters,
  meters.name as meter_name,  
  names_params.name as name_params,
  daily_values.value,    
  abonents.guid,
  water_abons_report.name,
  resources.name as res
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s' and
  water_abons_report.name='%s'
  order by obj_name, names_params.name ) z2
  on z2.meters=water_abons_report.ab_name
  where water_abons_report.name='%s'  
  order by obj_name, z2.name_params
    """%(my_param[0],electric_data_end, meters_name,meters_name)
    # if dc == u'current':
    #   sQuery=sQuery.replace('daily', dc)
    #print sQuery
    return sQuery
    
def MakeSqlQuery_water_by_date_for_abon(meters_name, parent_name, electric_data_end, my_param, dc):
    sQuery="""SELECT 
  daily_values.date,
  obj_name as ab_name,
  abonents.name as meters,
  meters.name as meter_name,  
  names_params.name as name_params,
  daily_values.value,    
  abonents.guid,
  water_abons_report.name,
  resources.name
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s' and
  water_abons_report.name='%s'
  and obj_name='%s'
  order by obj_name, names_params.name   
    """%(my_param[0],electric_data_end, parent_name, meters_name)
    #print sQuery
    # if dc == u'current':
    #   sQuery=sQuery.replace('daily', dc)
      #print sQuery

    #print dc
    return sQuery
    
def get_data_table_water_by_date(meters_name, parent_name, electric_data_end, isAbon, dc):
    cursor = connection.cursor()
    data_table=[]
    my_param=[u'Импульс',]
    #print "meters_name, parent_name, electric_data_end", meters_name, parent_name, electric_data_end
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_by_date_for_abon(meters_name, parent_name, electric_data_end, my_param,dc))
    else:
        cursor.execute(MakeSqlQuery_water_by_date_for_korp(meters_name, parent_name, electric_data_end, my_param, dc))
    data_table = cursor.fetchall()

    return data_table

def MakeSqlQuery_water_current_for_korp(meters_name, parent_name, electric_data_end, my_param):
    sQuery="""
Select z2.date, obj_name as ab_name, water_abons_report.ab_name as meter_name,  z2.meter_name, z2.name_params, z2.value, z2.time
from water_abons_report
LEFT JOIN (
SELECT 
  current_values.date,
  obj_name as ab_name,
  abonents.name as meters,
  meters.name as meter_name,  
  names_params.name as name_params,
  current_values.value,    
  current_values.time, 
  abonents.guid,
  water_abons_report.name,
  resources.name as res
FROM 
  public.meters, 
  public.taken_params, 
  public.current_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  current_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s' and
  water_abons_report.name='%s'
  order by obj_name, names_params.name ) z2
  on z2.meters=water_abons_report.ab_name
  where water_abons_report.name='%s'  
  order by obj_name, z2.name_params
    """%(my_param[0], meters_name, meters_name)
    #print sQuery
    return sQuery
    
def MakeSqlQuery_water_current_for_abon(meters_name, parent_name, electric_data_end, my_param):
    sQuery="""SELECT 
  current_values.date,
  obj_name as ab_name,
  abonents.name as meters,
  meters.name as meter_name,  
  names_params.name as name_params,
  current_values.value, 
  current_values.time,   
  abonents.guid,
  water_abons_report.name,
  resources.name
FROM 
  public.meters, 
  public.taken_params, 
  public.current_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  current_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'  and
  water_abons_report.name='%s'
  and obj_name='%s'
  order by obj_name, names_params.name   
    """%(my_param[0], parent_name, meters_name)
    #print sQuery
    return sQuery

def get_data_table_water_current(meters_name, parent_name, electric_data_end, isAbon, dc):
    cursor = connection.cursor()
    data_table=[]
    my_param=[u'Импульс',]
    #print "meters_name, parent_name, electric_data_end", meters_name, parent_name, electric_data_end
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_current_for_abon(meters_name, parent_name, electric_data_end, my_param))
    else:
        cursor.execute(MakeSqlQuery_water_current_for_korp(meters_name, parent_name, electric_data_end, my_param))
    data_table = cursor.fetchall()
    return data_table


def MakeSqlQuery_water_period_for_korp(meters_name, parent_name,electric_data_start, electric_data_end, my_param):
    sQuery="""  
SELECT  z.ab_name, z.account_2,z.date_st, z.meter_name,
z.type_energo, 
round(z.value_st::numeric,3),
round(z.value_end::numeric,3),
round(delta::numeric,3), z.date_install, z.date_end
From
(Select z_st.ab_name, z_st.account_2,z_st.date as date_st, z_st.meter_name, z_st.type_energo, z_st.value as value_st,z_end.value as value_end,round(z_end.value::numeric-z_st.value::numeric,3) as delta, z_st.date_install, z_end.date as date_end
from
(Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s'
order by obj_name, water_abons_report.ab_name, type_energo) z_st,
(
Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s'
order by obj_name, water_abons_report.ab_name, type_energo) z_end
where z_st.meter_name=z_end.meter_name) z
order by ab_name, meter_name
    """%( my_param[0], electric_data_start,meters_name,my_param[0], electric_data_end,meters_name)
    #print sQuery  
    return sQuery
def MakeSqlQuery_water_period_for_abon(meters_name, parent_name,electric_data_start, electric_data_end, my_param):
    sQuery="""

Select z_st.ab_name, z_st.account_2,z_st.date, z_st.meter_name,
z_st.type_energo, 
round(z_st.value::numeric,3),
round(z_end.value::numeric,3),
round((z_end.value-z_st.value)::numeric,3) as delta, z_st.date_install, z_end.date
from 
(Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s' and water_abons_report.obj_name='%s' 

order by account_2, obj_name) z_st,
(
Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s' and water_abons_report.obj_name='%s' 
order by account_2, obj_name) z_end
where z_st.meter_name=z_end.meter_name
    """%(my_param[0], electric_data_start, parent_name, meters_name,   my_param[0], electric_data_end,parent_name, meters_name )
    return sQuery
def get_data_table_water_period_pulsar(meters_name, parent_name, electric_data_start, electric_data_end, isAbon):
    cursor = connection.cursor()
    data_table=[]
    my_param=[u'Импульс',]
    #print "meters_name, parent_name, electric_data_end", meters_name, parent_name, electric_data_end
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_period_for_abon(meters_name, parent_name,electric_data_start, electric_data_end, my_param))
    else:
        cursor.execute(MakeSqlQuery_water_period_for_korp(meters_name, parent_name,electric_data_start, electric_data_end, my_param))
    data_table = cursor.fetchall()

    return data_table

def MakeSqlQuery_water_tekon_for_abonent_for_period(obj_parent_title, obj_title, electric_data_start,electric_data_end, chanel, my_params, type_meter):
    sQuery="""
Select z1.ab_name, z1.factory_number_manual, z1.value, z2.value, z2.value-z1.value as delta
from
(SELECT 
  daily_values.date,
  abonents.name as ab_name, 
  meters.factory_number_manual ,
  daily_values.value, types_meters.name as meter_type
  
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.names_params, 
  public.params, 
  public.resources, 
  public.meters , types_meters
WHERE 
types_meters.guid=params.guid_types_meters and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid
  And   
   names_params.name='%s' and
   resources.name='%s' and
   objects.name='%s' and
    abonents.name='%s' and 
   daily_values.date='%s'  
   and types_meters.name='%s'  
) z1,
(SELECT 
  daily_values.date,
  abonents.name as ab_name, 
  meters.factory_number_manual ,
  daily_values.value, types_meters.name as meter_type
  
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.names_params, 
  public.params, 
  public.resources, 
  public.meters , types_meters
WHERE 
types_meters.guid=params.guid_types_meters and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid
  And   
   names_params.name='%s' and
   resources.name='%s' and
   objects.name='%s' and
    abonents.name='%s' and 
   daily_values.date='%s'  
   and types_meters.name='%s'  
) z2
where z1.ab_name=z2.ab_name

    """%(chanel,my_params[0], obj_parent_title,obj_title, electric_data_start, type_meter, chanel,my_params[0],obj_parent_title, obj_title, electric_data_end, type_meter)
    #print sQuery
    return sQuery

def MakeSqlQuery_water_tekon_for_object_for_period(obj_parent_title, obj_title, electric_data_start,electric_data_end, chanel, my_params, meter_type):

    sQuery="""
    Select water_abons.ab_name, water_abons.factory_number_manual, z3.val_start, z3.val_end, z3.delta
from water_abons
left join
(Select z1.ab_name, z1.factory_number_manual, z1.value as val_start, z2.value as val_end, z2.value-z1.value as delta
from
(SELECT 
  daily_values.date,
  abonents.name as ab_name, 
  meters.factory_number_manual ,
  daily_values.value, types_meters.name as meter_type
  
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.names_params, 
  public.params, 
  public.resources, 
  public.meters , types_meters
WHERE 
types_meters.guid=params.guid_types_meters and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid
  And   
   names_params.name='%s' and
   resources.name='%s' and
   objects.name='%s' and
   daily_values.date='%s'  
   and types_meters.name='%s'   

) z1,
(SELECT 
  daily_values.date,
  abonents.name as ab_name, 
  meters.factory_number_manual ,
  daily_values.value, types_meters.name as meter_type
  
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.names_params, 
  public.params, 
  public.resources, 
  public.meters , types_meters
WHERE 
types_meters.guid=params.guid_types_meters and
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid
  And   
   names_params.name='%s' and
   resources.name='%s' and
   objects.name='%s' and
   daily_values.date='%s'  
   and types_meters.name='%s'    
) z2
where z1.ab_name=z2.ab_name) z3
on water_abons.ab_name=z3.ab_name
where water_abons.obj_name='%s' 
and water_abons.params_name='%s'
order by water_abons.ab_name
    """%(chanel,my_params[0], obj_title, electric_data_start,meter_type,chanel,my_params[0], obj_title, electric_data_end,meter_type, obj_title, chanel)
    
    return sQuery


def get_data_table_tekon_period(obj_title,obj_parent_title, electric_data_start, electric_data_end, chanel,  meter_type, isAbon):
    my_params=[u'Импульс']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_tekon_for_abonent_for_period(obj_parent_title, obj_title, electric_data_start,electric_data_end, chanel, my_params, meter_type))
    else:
        cursor.execute(MakeSqlQuery_water_tekon_for_object_for_period(obj_parent_title, obj_title,electric_data_start, electric_data_end, chanel, my_params, meter_type))
    data_table = cursor.fetchall()
    
    return data_table
    
#Отчет по теплу на начало суток. Саяны
def get_data_table_by_date_heat_sayany(obj_title, obj_parent_title, electric_data):
    data_table = []
    
    my_parametr = "Q Система1"    
    data_table_heat_Q1       = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Sayany")
    
#    my_parametr = 'Q Система2'               
#    data_table_heat_Q2  = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Sayany")

    my_parametr = 'M Система1'               
    data_table_heat_M1      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Sayany")
#
#    my_parametr = 'M Система2'               
#    data_table_heat_M2      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Sayany")

    my_parametr = 'T Канал1'               
    data_table_heat_T1      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Sayany")
    
    my_parametr = 'T Канал2'               
    data_table_heat_T2      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Sayany")
#    
#    my_parametr = 'T Канал3'               
#    data_table_heat_T3      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Sayany")
#    
#    my_parametr = 'T Канал4'               
#    data_table_heat_T4      = get_data_table_heat_parametr_by_date_daily(obj_title, obj_parent_title, electric_data, my_parametr, u"Sayany")

              
    for x in range(len(data_table_heat_Q1)):
        data_table_temp = []
        try:
            data_table_temp.append(data_table_heat_Q1[x][0]) # дата
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_Q1[x][2]) # имя абонента
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_Q1[x][3]) # заводской номер
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_Q1[x][4]) # значение Q1
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
#        try:
#            data_table_temp.append(data_table_heat_Q2[x][4]) # значение Q2
#        except IndexError:
#            data_table_temp.append(u"Н/Д")
#        except TypeError:
#            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_M1[x][4]) # значение M1
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
#        try:
#            data_table_temp.append(data_table_heat_M2[x][4]) # значение M2
#        except IndexError:
#            data_table_temp.append(u"Н/Д")
#        except TypeError:
#            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_T1[x][4]) # значение T1
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
        try:
            data_table_temp.append(data_table_heat_T2[x][4]) # значение T2
        except IndexError:
            data_table_temp.append(u"Н/Д")
        except TypeError:
            data_table_temp.append(u"Н/Д")
#        try:
#            data_table_temp.append(data_table_heat_T3[x][4]) # значение T3
#        except IndexError:
#            data_table_temp.append(u"Н/Д")
#        except TypeError:
#            data_table_temp.append(u"Н/Д")
#        try:
#            data_table_temp.append(data_table_heat_T4[x][4]) # значение T4
#        except IndexError:
#            data_table_temp.append(u"Н/Д")
#        except TypeError:
#            data_table_temp.append(u"Н/Д")

        data_table.append(data_table_temp)
    return data_table

def return_parent_guid_by_abonent_name(object_name):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          objects.guid
                        FROM 
                          public.objects
                        WHERE 
                          objects.name = %s;""",[object_name])
    simpleq = simpleq.fetchall()
    return simpleq[0][0]
    

def list_of_abonents(parent_guid, object_name):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                       abonents.name
                      FROM 
                       public.objects,
                       public.abonents
                      WHERE 
                       objects.guid = abonents.guid_objects AND
                       objects.guid_parent = %s AND
                       objects.name = %s 

                       ORDER BY
                       abonents.name ASC;""",[parent_guid, object_name])
    simpleq = simpleq.fetchall()
    return simpleq

    
def list_of_objects(parent_guid): #Возвращает список объектов
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          objects.name
                        FROM 
                          public.objects
                        WHERE 
                          objects.guid_parent = %s;""",[parent_guid])
    simpleq = simpleq.fetchall()
    return simpleq

def get_meters_guid_list_by_group_name(group_name): # Возвращает список GUID счётчиков по названию группы
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          meters.guid
                        FROM 
                          public.groups_80020, 
                          public.link_groups_80020_meters, 
                          public.meters
                        WHERE 
                          link_groups_80020_meters.guid_meters = meters.guid AND
                          link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
                          groups_80020.name = %s;""",[group_name])
    simpleq = simpleq.fetchall()
    return simpleq

def get_info_group_80020_meters(group_name):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          groups_80020.name_sender, 
                          groups_80020.inn_sender, 
                          groups_80020.dogovor_number, 
                          meters.factory_number_manual, 
                          link_groups_80020_meters.measuringpoint_name, 
                          link_groups_80020_meters.measuringpoint_code, 
                          meters.dt_last_read
                        FROM 
                          public.meters, 
                          public.groups_80020, 
                          public.link_groups_80020_meters
                        WHERE 
                          link_groups_80020_meters.guid_meters = meters.guid AND
                          link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
                          groups_80020.name = %s;""",[group_name])
    simpleq = simpleq.fetchall()
    return simpleq

def get_taken_param_by_meters_number_and_guid_params(meters_number, guid_params):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          meters.factory_number_manual, 
                          names_params.name
                        FROM 
                          public.params, 
                          public.meters, 
                          public.taken_params, 
                          public.names_params
                        WHERE 
                          taken_params.guid_meters = meters.guid AND
                          taken_params.guid_params = params.guid AND
                          names_params.guid = params.guid_names_params AND
                          meters.factory_number_manual = %s AND 
                          params.guid = %s;""",[meters_number, guid_params])
    simpleq = simpleq.fetchall()
    return simpleq

def get_name_of_type_meter_by_serial_number(meters_number):
    # Получаем имя типа счётчика по его заводскому номеру
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          types_meters.name
                        FROM 
                          public.meters, 
                          public.types_meters
                        WHERE 
                          meters.guid_types_meters = types_meters.guid AND
                          meters.factory_number_manual = %s;""",[meters_number])
    simpleq = simpleq.fetchall()
    return simpleq

def get_name_of_type_meter_by_guid(meters_guid):
    # Получаем имя типа счётчика по его guid
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                      types_meters.name
                    FROM 
                      public.meters, 
                      public.types_meters
                    WHERE 
                      meters.guid_types_meters = types_meters.guid AND
                      meters.guid = %s;""",[meters_guid])
    simpleq = simpleq.fetchall()
    return simpleq
    

def get_taken_param_by_guid_meters_and_guid_params(guid_meters, guid_params):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          meters.factory_number_manual, 
                          names_params.name
                        FROM 
                          public.meters, 
                          public.params, 
                          public.names_params, 
                          public.taken_params
                        WHERE 
                          params.guid = taken_params.guid_params AND
                          params.guid_names_params = names_params.guid AND
                          taken_params.guid_meters = meters.guid AND
                          meters.guid = %s AND 
                          params.guid = %s;""",[guid_meters, guid_params])
    simpleq = simpleq.fetchall()
    return simpleq

def get_count_of_30_profil_by_meter_number(date, meters_number, names_params):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          count(meters.factory_number_manual)
                        FROM 
                          public.various_values, 
                          public.meters, 
                          public.taken_params, 
                          public.params, 
                          public.names_params
                        WHERE 
                          various_values.id_taken_params = taken_params.id AND
                          taken_params.guid_meters = meters.guid AND
                          taken_params.guid_params = params.guid AND
                          params.guid_names_params = names_params.guid AND
                          meters.factory_number_manual = %s AND 
                          names_params.name = %s AND 
                          various_values.date = %s;""",[meters_number, names_params, date])
    simpleq = simpleq.fetchall()
    return simpleq[0][0]



def get_sum_of_30_profil_by_meter_number(date, meters_number, names_params):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          sum(various_values.value)
                        FROM 
                          public.various_values, 
                          public.meters, 
                          public.taken_params, 
                          public.params, 
                          public.names_params
                        WHERE 
                          various_values.id_taken_params = taken_params.id AND
                          taken_params.guid_meters = meters.guid AND
                          taken_params.guid_params = params.guid AND
                          params.guid_names_params = names_params.guid AND
                          meters.factory_number_manual = %s AND 
                          names_params.name = %s AND 
                          various_values.date = %s;""",[meters_number, names_params, date])
    simpleq = simpleq.fetchall()
    return simpleq[0][0]

def get_info_group_80020(group_80020_name):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          groups_80020.inn_sender, 
                          groups_80020.name_sender, 
                          groups_80020.inn_postavshik, 
                          groups_80020.name_postavshik, 
                          groups_80020.dogovor_number
                        FROM 
                          public.groups_80020
                        WHERE 
                          groups_80020.name = %s;""",[group_80020_name])
    simpleq = simpleq.fetchall()
    return simpleq

def get_info_measuring_point_in_group_80020(meters_guid):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          link_groups_80020_meters.measuringpoint_code, 
                          link_groups_80020_meters.measuringpoint_name
                        FROM 
                          public.link_groups_80020_meters
                        WHERE 
                          link_groups_80020_meters.guid_meters = %s;""",[meters_guid])
    simpleq = simpleq.fetchall()
    return simpleq

def get_30_min_value_by_meters_number_param_names_and_datetime(meters_number, param_names, date, time):
    simpleq = connection.cursor()
    simpleq.execute("""SELECT 
                          meters.factory_number_manual, 
                          names_params.name, 
                          various_values.date, 
                          various_values."time", 
                          various_values.value
                        FROM 
                          public.meters, 
                          public.various_values, 
                          public.names_params, 
                          public.taken_params, 
                          public.params
                        WHERE 
                          various_values.id_taken_params = taken_params.id AND
                          taken_params.guid_meters = meters.guid AND
                          taken_params.guid_params = params.guid AND
                          params.guid_names_params = names_params.guid AND
                          meters.factory_number_manual = %s AND 
                          names_params.name = %s AND 
                          various_values.date = %s AND 
                          various_values."time" = %s;""",[meters_number, param_names, date, time])
    simpleq = simpleq.fetchall()
    return simpleq

def makeSqlQuery_heat_daily_pulsar_teplo_abon(obj_parent_title,obj_title, electric_data, params):
    sQuery="""
           Select z2.daily_date, heat_abons.ab_name, heat_abons.factory_number_manual, 
round(z2.energy::numeric,7),
round(z2.volume::numeric,7),
round(z2.t_in::numeric,1),
round(z2.t_out::numeric,1)
from heat_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  objects.name = '%s' AND
                    abonents.name = '%s' AND            			  
            			  types_meters.name = '%s' AND 
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual
            order by z1.name_abonents) as z2
on z2.number_manual=heat_abons.factory_number_manual
where heat_abons.obj_name='%s' and heat_abons.ab_name  = '%s'
order by heat_abons.ab_name""" % (params[0],params[1],params[2],params[3], obj_parent_title, obj_title,params[4], electric_data,obj_parent_title, obj_title )
    #print sQuery
    return sQuery

def makeSqlQuery_heat_daily_pulsar_teplo_all(obj_title, electric_data, params):
    sQuery="""
           Select z2.daily_date, heat_abons.ab_name, heat_abons.factory_number_manual, 
round(z2.energy::numeric,7),
round(z2.volume::numeric,7),
round(z2.t_in::numeric,1),
round(z2.t_out::numeric,1)
from heat_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  objects.name = '%s' AND            			  
            			  types_meters.name = '%s' AND 
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual
            order by z1.name_abonents) as z2
on z2.number_manual=heat_abons.factory_number_manual
where heat_abons.obj_name='%s'
order by heat_abons.ab_name""" % (params[0],params[1],params[2],params[3], obj_title,params[4], electric_data, obj_title )
    #print sQuery    
    return sQuery



def get_data_table_by_date_daily_pulsar_teplo(obj_parent_title, obj_title, electric_data, isAbon):
    data_table = []
    params=[u'Энергия',u'Объем',u'Ti',u'To', 'Пульсар Теплосчётчик']
    cursor = connection.cursor()
    if isAbon:
        cursor.execute(makeSqlQuery_heat_daily_pulsar_teplo_abon(obj_parent_title,obj_title, electric_data, params))
    else:
        cursor.execute(makeSqlQuery_heat_daily_pulsar_teplo_all(obj_title, electric_data, params))
    data_table = cursor.fetchall()   
    
    if len(data_table)>0: data_table=ChangeNull(data_table, electric_data)
    return data_table



def makeSqlQuery_heat_pulsar_teplo_abon_period(obj_parent_title,obj_title, electric_data_end, electric_data_start, params):
    sQuery="""
   Select  ab_name,factory_number_manual,
round((z5.energy_start)::numeric,7) as energy_st,
round(z5.energy_end::numeric,7)as energy_e,
round((z5.energy_end-z5.energy_start)::numeric,7) as energy_delta,
round((z5.volume_start)::numeric,7),
round((z5.volume_end)::numeric,7),
round((z5.volume_end-z5.volume_start)::numeric,7) as volume_delta
FROM
(Select z3.obj_name, z3.ab_name,z3.factory_number_manual, z3.energy_start,z3.volume_start , z4.energy_end,z4.volume_end
from
(Select z2.daily_date, heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual, z2.energy as energy_start,z2.volume as volume_start,z2.t_in as t_in_start,z2.t_out as t_out_start
from heat_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  objects.name = '%s' AND
                    abonents.name = '%s' and            			  
            			  types_meters.name = '%s' AND 
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual
            order by z1.name_abonents) as z2
on z2.number_manual=heat_abons.factory_number_manual
where heat_abons.obj_name='%s' and heat_abons.ab_name = '%s') as z3,
(Select z2.daily_date, heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual, z2.energy as energy_end,z2.volume as volume_end,z2.t_in as t_in_end,z2.t_out as t_out_end
from heat_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  objects.name = '%s' AND 
                    abonents.name = '%s' and           			  
            			  types_meters.name = '%s' AND 
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual
            order by z1.name_abonents) as z2
on z2.number_manual=heat_abons.factory_number_manual
where heat_abons.obj_name='%s' and heat_abons.ab_name = '%s') as z4
where z3.factory_number_manual=z4.factory_number_manual
) as z5
order by ab_name
    """%(params[0],params[1],params[2],params[3],obj_parent_title, obj_title,params[4], electric_data_start, obj_parent_title, obj_title,
         params[0],params[1],params[2],params[3], obj_parent_title, obj_title,params[4], electric_data_end, obj_parent_title, obj_title)
    return sQuery

def makeSqlQuery_heat_pulsar_teplo_all_period(obj_title, electric_data_end,electric_data_start, params):
    sQuery="""
   Select  ab_name,factory_number_manual,
round((z5.energy_start)::numeric,7) as energy_st,
round(z5.energy_end::numeric,7)as energy_e,
round((z5.energy_end-z5.energy_start)::numeric,7) as energy_delta,
round((z5.volume_start)::numeric,7),
round((z5.volume_end)::numeric,7),
round((z5.volume_end-z5.volume_start)::numeric,7) as volume_delta
FROM
(Select z3.obj_name, z3.ab_name,z3.factory_number_manual, z3.energy_start,z3.volume_start , z4.energy_end,z4.volume_end
from
(Select z2.daily_date, heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual, z2.energy as energy_start,z2.volume as volume_start,z2.t_in as t_in_start,z2.t_out as t_out_start
from heat_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  objects.name = '%s' AND            			  
            			  types_meters.name = '%s' AND 
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual
            order by z1.name_abonents) as z2
on z2.number_manual=heat_abons.factory_number_manual
where heat_abons.obj_name='%s') as z3,
(Select z2.daily_date, heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual, z2.energy as energy_end,z2.volume as volume_end,z2.t_in as t_in_end,z2.t_out as t_out_end
from heat_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  objects.name = '%s' AND            			  
            			  types_meters.name = '%s' AND 
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual
            order by z1.name_abonents) as z2
on z2.number_manual=heat_abons.factory_number_manual
where heat_abons.obj_name='%s') as z4
where z3.factory_number_manual=z4.factory_number_manual
) as z5
order by ab_name
    """%(params[0],params[1],params[2],params[3], obj_title,params[4], electric_data_start,obj_title,
         params[0],params[1],params[2],params[3], obj_title,params[4], electric_data_end, obj_title)
    #print sQuery   
    return sQuery

def get_data_table_pulsar_teplo_for_period(obj_parent_title, obj_title, electric_data_end,electric_data_start, isAbon):
    data_table = []
    params=[u'Энергия',u'Объем',u'Ti',u'To', 'Пульсар Теплосчётчик']
    cursor = connection.cursor()
    if isAbon:
        cursor.execute(makeSqlQuery_heat_pulsar_teplo_abon_period(obj_parent_title,obj_title, electric_data_end,electric_data_start, params))
    else:
        cursor.execute(makeSqlQuery_heat_pulsar_teplo_all_period(obj_title, electric_data_end,electric_data_start, params))
    data_table = cursor.fetchall()   
    
    if len(data_table)>0: data_table=ChangeNull(data_table, None)
    return data_table

def MakeSqlQuery_water_pulsar_daily_for_abonent(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""
    Select z1.date,water_pulsar_abons.ab_name, water_pulsar_abons.type_meter, water_pulsar_abons.attr1, water_pulsar_abons.factory_number_manual, round(z1.value::numeric,3)
from water_pulsar_abons
left join
(SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11),   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  abonents.name='%s' and
  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z1
on z1.factory_number_manual=water_pulsar_abons.factory_number_manual
where 
water_pulsar_abons.obj_name='%s'and
water_pulsar_abons.ab_name='%s' 
    """%(obj_parent_title, obj_title, electric_data_end, my_params[0],my_params[1],obj_parent_title, obj_title)
    #print sQuery
    return sQuery
    
def MakeSqlQuery_water_pulsar_daily_for_all(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""
    Select z1.date, water_pulsar_abons.ab_name, z1.type_meter, z1.attr1, water_pulsar_abons.factory_number_manual, round(z1.value::numeric,3),water_pulsar_abons.ab_guid
from water_pulsar_abons
left join 
(SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11) as type_meter,   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
ORDER BY
  abonents.name ASC) as z1
on water_pulsar_abons.factory_number_manual=z1.factory_number_manual
  where water_pulsar_abons.obj_name='%s'
  order by water_pulsar_abons.ab_name, z1.type_meter, z1.attr1
    """%(obj_title, electric_data_end, my_params[0],my_params[1],obj_title)
    #print sQuery
    return sQuery
    
def get_data_table_pulsar_water_daily(obj_parent_title, obj_title, electric_data_end, isAbon):
    my_params=[u'Пульсар ГВС', u'Пульсар ХВС']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_pulsar_daily_for_abonent(obj_parent_title, obj_title, electric_data_end, my_params))
    else:
        cursor.execute(MakeSqlQuery_water_pulsar_daily_for_all(obj_parent_title, obj_title, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table
    
def MakeSqlQuery_water_pulsar_period_for_abonent(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params):
    #print obj_parent_title, obj_title,electric_data_start, my_params[0], my_params[1]
    #print obj_parent_title, obj_title,  electric_data_end, my_params[0], my_params[1]    
    sQuery="""
    Select z1.ab_name, z1.type_meter, z1.attr1, z1.factory_number_manual,round(z1.value_start::numeric,3),round(z2.value_end::numeric,3), round((z2.value_end-z1.value_start)::numeric,3) as delta
from
(select water_pulsar_abons.ab_name, water_pulsar_abons.type_meter, water_pulsar_abons.attr1, water_pulsar_abons.factory_number_manual, z0.value as value_start
from water_pulsar_abons
left join
(SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11)as type_meters,
   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  abonents.name='%s' and
  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z0
on z0.factory_number_manual=water_pulsar_abons.factory_number_manual
where water_pulsar_abons.obj_name='%s' 
and water_pulsar_abons.ab_name='%s'
) as z1,
(select water_pulsar_abons.ab_name, water_pulsar_abons.type_meter, water_pulsar_abons.attr1, water_pulsar_abons.factory_number_manual, z1.value as value_end
from water_pulsar_abons
left join
(SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11)as type_meters,
   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  abonents.name='%s' and
  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z1
on z1.factory_number_manual=water_pulsar_abons.factory_number_manual
where water_pulsar_abons.obj_name='%s' 
and water_pulsar_abons.ab_name='%s'
) as z2
where z1.factory_number_manual=z2.factory_number_manual
    """%(obj_parent_title, obj_title,electric_data_start, my_params[0], my_params[1],obj_parent_title, obj_title, obj_parent_title, obj_title,  electric_data_end, my_params[0], my_params[1],obj_parent_title, obj_title)
    #print sQuery  
    return sQuery
    
def MakeSqlQuery_water_pulsar_period_for_all(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params):
    sQuery="""
Select z_start.ab_name, z_start.type_meter, z_start.attr1, z_start.factory_number_manual,round(z_start.value::numeric,3),round(z_end.value::numeric,3), round((z_end.value-z_start.value)::numeric,3) as delta
from
(SELECT water_pulsar_abons.ab_name, water_pulsar_abons.type_meter, water_pulsar_abons.attr1, water_pulsar_abons.factory_number_manual, z1.value
from
water_pulsar_abons
Left join
(SELECT 
  objects.name, 
  abonents.name, 
  daily_values.date, 
  daily_values.value, 
  meters.name,
  meters.factory_number_manual, 
  resources.name
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  (resources.name = '%s' OR 
  resources.name = '%s'))as z1
  on z1.factory_number_manual=water_pulsar_abons.factory_number_manual
  where water_pulsar_abons.obj_name='%s'
  order by ab_name) as z_end,
(SELECT water_pulsar_abons.ab_name, water_pulsar_abons.type_meter, water_pulsar_abons.attr1, water_pulsar_abons.factory_number_manual, z1.value
from
water_pulsar_abons
Left join
(SELECT 
  objects.name, 
  abonents.name, 
  daily_values.date, 
  daily_values.value, 
  meters.name,
  meters.factory_number_manual, 
  resources.name
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  (resources.name = '%s' OR 
  resources.name = '%s'))as z1
  on z1.factory_number_manual=water_pulsar_abons.factory_number_manual
  where water_pulsar_abons.obj_name='%s'
  order by ab_name) as z_start
where z_end.factory_number_manual=z_start.factory_number_manual
order by z_start.ab_name, z_start.attr1, z_start.type_meter 
    """%(electric_data_end , my_params[2], my_params[3], obj_title, electric_data_start, my_params[2], my_params[3],obj_title)
    #print sQuery 
    return sQuery
    
def get_data_table_pulsar_water_for_period(obj_parent_title, obj_title, electric_data_start, electric_data_end, isAbon):
    my_params=[u'Пульсар ГВС', u'Пульсар ХВС', u'ГВС', u'ХВС']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_pulsar_period_for_abonent(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params))
    else:
        cursor.execute(MakeSqlQuery_water_pulsar_period_for_all(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table
    
def MakeSqlQuery_water_pulsar_period_for_abonent_Skladochnaya(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params):
    sQuery="""
    select z_start.ab_name,  z_start.gvs_1_num, round(z_start.gvs_1::numeric,3), z_start.date_start, round(z_end.gvs_1::numeric,3), z_end.date_end,round((z_end.gvs_1-z_start.gvs_1)::numeric,3) , z_end.hvs_1_num, round(z_start.hvs_1::numeric,3), z_start.date_start, round(z_end.hvs_1::numeric,3),  z_end.date_end,round((z_end.hvs_1-z_start.hvs_1)::numeric,3)
from

(select water_pulsar_abons.ab_name,water_pulsar_abons.ab_guid, z3.gvs_1_num, z3.gvs_1, z3.date, z3.hvs_1_num, z3.hvs_1,   z3.date as date_start
from water_pulsar_abons
left join
(Select *
from
(
Select z1.date,z1.name,z1.guid, 
sum(Case when  z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as hvs_1_num,
sum(Case when  z1.type_meter='%s'  then z1.value else 0 end) as hvs_1,
sum(Case when z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as gvs_1_num,
sum(Case when  z1.type_meter='%s'  then z1.value else 0 end) as gvs_1

from
(
SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11)as type_meter,
   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 

  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z1
group by z1.date,z1.name,z1.guid) as z2) as z3
on  water_pulsar_abons.ab_guid=z3.guid
where water_pulsar_abons.obj_name='%s'
group by water_pulsar_abons.ab_name, z3.hvs_1_num, z3.hvs_1, z3.gvs_1_num, z3.gvs_1,z3.date, water_pulsar_abons.ab_guid
order by water_pulsar_abons.ab_name) as z_start,

(select water_pulsar_abons.ab_name,water_pulsar_abons.ab_guid, z3.gvs_1_num, z3.gvs_1, z3.date, z3.hvs_1_num, z3.hvs_1,   z3.date as date_end
from water_pulsar_abons
left join
(Select *
from
(
Select z1.date,z1.name,z1.guid, 
sum(Case when  z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as hvs_1_num,
sum(Case when  z1.type_meter='%s'  then z1.value else 0 end) as hvs_1,
sum(Case when z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as gvs_1_num,
sum(Case when  z1.type_meter='%s'  then z1.value else 0 end) as gvs_1

from
(
SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11)as type_meter,
   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 

  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z1
group by z1.date,z1.name,z1.guid) as z2) as z3
on  water_pulsar_abons.ab_guid=z3.guid
where water_pulsar_abons.obj_name='%s'
and water_pulsar_abons.ab_name='%s'
group by water_pulsar_abons.ab_name, z3.hvs_1_num, z3.hvs_1, z3.gvs_1_num, z3.gvs_1,z3.date, water_pulsar_abons.ab_guid
order by water_pulsar_abons.ab_name) as z_end
where z_end.ab_guid=z_start.ab_guid
    """%(my_params[2], my_params[2],my_params[3],my_params[3], obj_parent_title,electric_data_start,my_params[0],my_params[1],obj_parent_title,
         my_params[2], my_params[2],my_params[3],my_params[3], obj_parent_title,electric_data_end,my_params[0],my_params[1],obj_parent_title, obj_title)
    #print sQuery    
    return sQuery
    
def MakeSqlQuery_water_pulsar_period_for_all_Skladochnaya(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params):
    
    sQuery="""
select z_start.ab_name,  z_start.gvs_1_num, round(z_start.gvs_1::numeric,3), z_start.date_start,round(z_end.gvs_1::numeric,3), z_end.date_end,round((z_end.gvs_1-z_start.gvs_1)::numeric,3) , z_end.hvs_1_num, round(z_start.hvs_1::numeric,3), z_start.date_start, round(z_end.hvs_1::numeric,3),  z_end.date_end,round((z_end.hvs_1-z_start.hvs_1)::numeric,3)
from
(select water_pulsar_abons.ab_name,water_pulsar_abons.ab_guid, z3.gvs_1_num, z3.gvs_1, z3.date, z3.hvs_1_num, z3.hvs_1,   z3.date as date_start
from water_pulsar_abons
left join
(Select *
from
(
Select z1.date,z1.name,z1.guid, 
sum(Case when  z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as hvs_1_num,
sum(Case when  z1.type_meter='%s'  then z1.value else 0 end) as hvs_1,
sum(Case when z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as gvs_1_num,
sum(Case when  z1.type_meter='%s'  then z1.value else 0 end) as gvs_1

from
(
SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11)as type_meter,   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 

  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z1
group by z1.date,z1.name,z1.guid) as z2) as z3
on  water_pulsar_abons.ab_guid=z3.guid
where water_pulsar_abons.obj_name='%s'
group by water_pulsar_abons.ab_name, z3.hvs_1_num, z3.hvs_1, z3.gvs_1_num, z3.gvs_1,z3.date, water_pulsar_abons.ab_guid
order by water_pulsar_abons.ab_name) as z_start,

(select water_pulsar_abons.ab_name,water_pulsar_abons.ab_guid, z3.gvs_1_num, z3.gvs_1, z3.date, z3.hvs_1_num, z3.hvs_1,   z3.date as date_end
from water_pulsar_abons
left join
(Select *
from
(
Select z1.date,z1.name,z1.guid, 
sum(Case when  z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as hvs_1_num,
sum(Case when  z1.type_meter='%s'  then z1.value else 0 end) as hvs_1,
sum(Case when z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as gvs_1_num,
sum(Case when  z1.type_meter='%s'  then z1.value else 0 end) as gvs_1

from
(
SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11)as type_meter,
   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 

  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z1
group by z1.date,z1.name,z1.guid) as z2) as z3
on  water_pulsar_abons.ab_guid=z3.guid
where water_pulsar_abons.obj_name='%s'
group by water_pulsar_abons.ab_name, z3.hvs_1_num, z3.hvs_1, z3.gvs_1_num, z3.gvs_1,z3.date, water_pulsar_abons.ab_guid
order by water_pulsar_abons.ab_name) as z_end
where z_end.ab_guid=z_start.ab_guid
    """%(my_params[2], my_params[2],my_params[3],my_params[3], obj_title,electric_data_start,my_params[0],my_params[1], obj_title, 
         my_params[2], my_params[2],my_params[3],my_params[3], obj_title,electric_data_end,my_params[0],my_params[1], obj_title)
    #print sQuery    
    return sQuery
    
def get_data_table_pulsar_water_for_period_Skladochnaya(obj_parent_title, obj_title, electric_data_start, electric_data_end, isAbon):
    my_params=[u'Пульсар ГВС', u'Пульсар ХВС', u'ХВС',u'ГВС']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_pulsar_period_for_abonent_Skladochnaya(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params))
    else:
        cursor.execute(MakeSqlQuery_water_pulsar_period_for_all_Skladochnaya(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table
    
def MakeSqlQuery_water_pulsar_daily_for_abonent_row(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""
Select z2.date_end,z2.name, z2.hvs_1_num, z2.hvs_1,z2.gvs_1_num, z2.gvs_1, 
z2.hvs_2_num, z2.hvs_2,  z2.gvs_2_num,z2.gvs_2, 
z2.hvs_3_num,z2.hvs_3, z2.gvs_3_num, z2.gvs_3, 
(z2.hvs_1+z2.hvs_2+z2.hvs_3) as sum_hvs,
(z2.gvs_1+z2.gvs_2+z2.gvs_3) as sum_gvs
from 
(
Select z1.date_end, z1.name,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as hvs_1_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0 end) as hvs_1,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as gvs_1_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0 end) as gvs_1,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint end) as hvs_2_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0  end) as hvs_2,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint end) as gvs_2_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0  end) as gvs_2,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as hvs_3_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0  end) as hvs_3,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as gvs_3_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0  end) as gvs_3
from
(
Select '%s'::date as date_end,water_pulsar_abons.ab_name as name, water_pulsar_abons.type_meter, water_pulsar_abons.attr1, water_pulsar_abons.factory_number_manual, z0.value
from water_pulsar_abons
left join
(SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11),   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  abonents.name='%s' and
  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z0
on z0.factory_number_manual=water_pulsar_abons.factory_number_manual
where water_pulsar_abons.ab_name='%s' and
water_pulsar_abons.obj_name='%s'
) as z1
group by z1.date_end,z1.name
) as z2
    """%(my_params[4],my_params[2],my_params[4],my_params[2],my_params[4],my_params[3],my_params[4],my_params[3],
         my_params[5],my_params[2],my_params[5],my_params[2],my_params[5],my_params[3],my_params[5],my_params[3],
         my_params[6],my_params[2],my_params[6],my_params[2],my_params[6],my_params[3],my_params[6],my_params[3],
         electric_data_end,
         obj_parent_title, obj_title, electric_data_end, my_params[0], my_params[1], obj_title,obj_parent_title)
    return sQuery
    
def MakeSqlQuery_water_pulsar_daily_for_all_row(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""
Select z2.date_end,z2.name, z2.hvs_1_num, z2.hvs_1,z2.gvs_1_num, z2.gvs_1, 
z2.hvs_2_num, z2.hvs_2,  z2.gvs_2_num,z2.gvs_2, 
z2.hvs_3_num,z2.hvs_3, z2.gvs_3_num, z2.gvs_3, 
(z2.hvs_1+z2.hvs_2+z2.hvs_3) as sum_hvs,
(z2.gvs_1+z2.gvs_2+z2.gvs_3) as sum_gvs
from 
(
Select z1.date_end, z1.name,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as hvs_1_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0 end) as hvs_1,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as gvs_1_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0 end) as gvs_1,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint end) as hvs_2_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0  end) as hvs_2,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint end) as gvs_2_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0  end) as gvs_2,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as hvs_3_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0  end) as hvs_3,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.factory_number_manual::bigint  end) as gvs_3_num,
sum(Case when z1.attr1 = '%s' and z1.type_meter='%s'  then z1.value else 0  end) as gvs_3
from
(
Select '%s'::date as date_end,water_pulsar_abons.ab_name as name, water_pulsar_abons.type_meter, water_pulsar_abons.attr1, water_pulsar_abons.factory_number_manual, z0.value
from water_pulsar_abons
left join
(SELECT 
  daily_values.date,  
  abonents.name, 
  substring(types_meters.name from 9 for 11),   
  meters.attr1,
  meters.factory_number_manual,   
  daily_values.value,   
  abonents.guid
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.meters, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 

  daily_values.date = '%s' and
  (types_meters.name='%s' or types_meters.name='%s')
) as z0
on z0.factory_number_manual=water_pulsar_abons.factory_number_manual
where 
water_pulsar_abons.obj_name='%s'
) as z1
group by z1.date_end,z1.name
) as z2
order by z2.name
    """%(my_params[4],my_params[2],my_params[4],my_params[2],my_params[4],my_params[3],my_params[4],my_params[3],
         my_params[5],my_params[2],my_params[5],my_params[2],my_params[5],my_params[3],my_params[5],my_params[3],
         my_params[6],my_params[2],my_params[6],my_params[2],my_params[6],my_params[3],my_params[6],my_params[3],
         electric_data_end,
          obj_title, electric_data_end, my_params[0], my_params[1], obj_title)
    #print sQuery
    return sQuery
    
def get_data_table_pulsar_water_daily_row(obj_parent_title, obj_title, electric_data_end, isAbon):
    my_params=[u'Пульсар ГВС', u'Пульсар ХВС',u'ХВС',u'ГВС', 'Стояк 1', 'Стояк 2', 'Стояк 3']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_water_pulsar_daily_for_abonent_row(obj_parent_title, obj_title, electric_data_end, my_params))
    else:
        cursor.execute(MakeSqlQuery_water_pulsar_daily_for_all_row(obj_parent_title, obj_title, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table
    
def MakeSqlQuery_heat_elf_period_for_all(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z_end.ab_name, z_end.factory_number_manual, z_end.energy_end/100,z_start.energy_start/100,(z_end.energy_end-z_start.energy_start)/100 as delta_energy, z_end.volume_end,z_start.volume_start,z_end.volume_end-z_start.volume_start as delta_volume
from
(select heat_abons.ab_name, heat_abons.factory_number_manual, z2.energy_end, z2.volume_end
from heat_abons
left join

(SELECT 
daily_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy_end,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume_end

FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' and
  daily_values.date='%s'
  group by daily_values.date, objects.name, abonents.name, meters.factory_number_manual) as z2
  on z2.factory_number_manual=heat_abons.factory_number_manual
  where heat_abons.obj_name='%s'
) as z_end,

(select heat_abons.ab_name, heat_abons.factory_number_manual, z1.energy_start, z1.volume_start
from heat_abons
left join
(SELECT 
daily_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy_start,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume_start

FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' and
  daily_values.date='%s'
  group by daily_values.date, objects.name, abonents.name, meters.factory_number_manual) as z1
  on z1.factory_number_manual=heat_abons.factory_number_manual
  where heat_abons.obj_name='%s'
) as z_start
  
  where z_start.factory_number_manual=z_end.factory_number_manual
  order by z_start.ab_name
    """%(my_params[0],my_params[1],obj_title,my_params[2],electric_data_end,obj_title, 
         my_params[0],my_params[1],obj_title,my_params[2],electric_data_start,obj_title)
    
    return sQuery
    
def MakeSqlQuery_heat_elf_period_for_abonent(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params):

    sQuery="""
    select heat_abons.ab_name, heat_abons.factory_number_manual,z3.energy_start/100, z3.energy_end/100, z3.delta_energy/100, z3.volume_start, z3.volume_end, z3.delta_volume
from heat_abons
left join
(Select z1.ab_name, z1.factory_number_manual, z1.energy as energy_end,z2.energy as energy_start, z1.energy-z2.energy as delta_energy, z1.volume as volume_end,z2.volume as volume_start, z1.volume-z2.volume as delta_volume
from
(SELECT 
daily_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume

FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' and
  daily_values.date='%s'
  group by daily_values.date, objects.name, abonents.name, meters.factory_number_manual) as z1,
  (SELECT 
daily_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume

FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' and
  daily_values.date='%s'
  group by daily_values.date, objects.name, abonents.name, meters.factory_number_manual) as z2
  where z1.factory_number_manual=z2.factory_number_manual) as z3
  on z3.factory_number_manual=heat_abons.factory_number_manual
  where heat_abons.ab_name='%s' and
  heat_abons.obj_name='%s'
  order by ab_name
    """%(my_params[0],my_params[1],obj_parent_title,my_params[2],electric_data_end, 
         my_params[0],my_params[1],obj_parent_title,my_params[2],electric_data_start,obj_title,obj_parent_title )
    #print sQuery
    return sQuery
    
def get_data_table_elf_period(obj_parent_title, obj_title, electric_data_start, electric_data_end, isAbon):
    my_params=[u'Энергия',u'Объем',u'Эльф 1.08']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_heat_elf_period_for_abonent(obj_parent_title, obj_title, electric_data_start,electric_data_end, my_params))
    else:
        cursor.execute(MakeSqlQuery_heat_elf_period_for_all(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table
    
def MakeSqlQuery_heat_elf_daily_for_abonent(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""    
SELECT 

                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value/100 else null end) as energy,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume

FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  abonents.name = '%s' AND 
  objects.name = '%s' AND 
  types_meters.name = '%s' and
  daily_values.date='%s'
  group by daily_values.date, objects.name, abonents.name, meters.factory_number_manual
    """%(my_params[0],my_params[1],obj_title,obj_parent_title,my_params[2],electric_data_end)
    return sQuery
    
def MakeSqlQuery_heat_elf_daily_for_all(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""
    Select heat_abons.ab_name, heat_abons.factory_number_manual, z1.energy/100, z1.volume

from heat_abons
left join
(SELECT 
daily_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume

FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' and
  daily_values.date='%s'
  group by daily_values.date, objects.name, abonents.name, meters.factory_number_manual) as z1
  on heat_abons.factory_number_manual=z1.factory_number_manual
  where heat_abons.obj_name='%s'
  order by heat_abons.ab_name
    """%(my_params[0],my_params[1],obj_title,my_params[2],electric_data_end,obj_title)
    return sQuery
    
def get_data_table_elf_heat_daily(obj_parent_title, obj_title, electric_data_end, isAbon):
    my_params=[u'Энергия',u'Объем',u'Эльф 1.08']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_heat_elf_daily_for_abonent(obj_parent_title, obj_title, electric_data_end, my_params))
    else:
        cursor.execute(MakeSqlQuery_heat_elf_daily_for_all(obj_parent_title, obj_title, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table
    
def MakeSqlQuery_heat_water_elf_daily_for_all(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""
    select z_heat.ab_name, z_heat.factory_number_manual, z_heat.energy, z_heat.volume, z_water_hvs.attr1, z_water_hvs.value,z_water_gvs.attr2, z_water_gvs.value
from
(Select heat_abons.ab_name, heat_abons.factory_number_manual, z1.energy, z1.volume
from heat_abons
left join
(SELECT 
daily_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume

FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' and
  daily_values.date='%s'
  group by daily_values.date, objects.name, abonents.name, meters.factory_number_manual) as z1
  on heat_abons.factory_number_manual=z1.factory_number_manual
  where heat_abons.obj_name='%s'
) as z_heat,
  (Select z1.date,ab_name,water_abons.factory_number_manual, z1.attr1, z1.value
from water_abons
left join
(
SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.attr1, 
  daily_values.value, 
  taken_params.id, 
  
  params.channel,
  abonents.guid as ab_guid,
  meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = 1 and 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z1
  on z1.ab_guid=water_abons.ab_guid
  where water_abons.obj_name = '%s' 
) as z_water_hvs,
(Select z1.date,ab_name,water_abons.factory_number_manual, z1.attr2, z1.value
from water_abons
left join
(
SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.attr2, 
  daily_values.value, 
  taken_params.id,   
  params.channel,
  abonents.guid as ab_guid,
  meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = 2 and 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z1
  on z1.ab_guid=water_abons.ab_guid
  where water_abons.obj_name = '%s' 
) as z_water_gvs
where z_heat.ab_name=z_water_hvs.ab_name
and z_heat.ab_name=z_water_gvs.ab_name
order by z_heat.ab_name
    """%(my_params[0],my_params[1],obj_title,my_params[2],electric_data_end,obj_title,
         obj_title,electric_data_end, obj_title,obj_title,electric_data_end, obj_title)
    #print sQuery
    return sQuery

def MakeSqlQuery_heat_water_elf_daily_for_abon(obj_title, abon, electric_data_end, my_params):
    sQuery="""
    select z_heat.ab_name, z_heat.factory_number_manual, z_heat.energy, z_heat.volume, z_water_hvs.attr1, z_water_hvs.value,z_water_gvs.attr2, z_water_gvs.value
from
(Select heat_abons.ab_name, heat_abons.factory_number_manual, z1.energy, z1.volume
from heat_abons
left join
(SELECT 
daily_values.date,                           
                          objects.name, 
                          abonents.name as ab_name, 
                          meters.factory_number_manual,                           
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as energy,
                          sum(Case when names_params.name = '%s' then daily_values.value else null end) as volume

FROM 
  public.link_abonents_taken_params, 
  public.meters, 
  public.abonents, 
  public.taken_params, 
  public.objects, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.types_meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid_types_meters = types_meters.guid AND
  abonents.guid = link_abonents_taken_params.guid_abonents AND
  abonents.guid_objects = objects.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  objects.name = '%s' AND 
  types_meters.name = '%s' and
  daily_values.date='%s'
  group by daily_values.date, objects.name, abonents.name, meters.factory_number_manual) as z1
  on heat_abons.factory_number_manual=z1.factory_number_manual
  where heat_abons.obj_name='%s'
) as z_heat,
  (Select z1.date,ab_name,water_abons.factory_number_manual, z1.attr1, z1.value
from water_abons
left join
(
SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.attr1, 
  daily_values.value, 
  taken_params.id, 
  
  params.channel,
  abonents.guid as ab_guid,
  meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = 1 and 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z1
  on z1.ab_guid=water_abons.ab_guid
  where water_abons.obj_name = '%s' 
) as z_water_hvs,
(Select z1.date,ab_name,water_abons.factory_number_manual, z1.attr2, z1.value
from water_abons
left join
(
SELECT 
  daily_values.date, 
  abonents.name,   
  meters.factory_number_manual, 
  meters.attr2, 
  daily_values.value, 
  taken_params.id,   
  params.channel,
  abonents.guid as ab_guid,
  meters.guid
FROM 
  public.meters, 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params
WHERE 
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  objects.name = '%s' AND 
  params.channel = 2 and 
  daily_values.date='%s'
ORDER BY
  abonents.name ASC) as z1
  on z1.ab_guid=water_abons.ab_guid
  where water_abons.obj_name = '%s' 
) as z_water_gvs
where z_heat.ab_name=z_water_hvs.ab_name
and z_heat.ab_name=z_water_gvs.ab_name and
z_heat.ab_name='%s'
order by z_heat.ab_name
    """%(my_params[0],my_params[1],obj_title,my_params[2],electric_data_end,obj_title,
         obj_title,electric_data_end, obj_title,obj_title,electric_data_end, obj_title, abon)
    #print sQuery
    return sQuery


def get_data_table_elf_heat_water_daily(obj_parent_title, obj_title, electric_data_end, isAbon):
    my_params=[u'Энергия',u'Объем',u'Эльф 1.08']
    cursor = connection.cursor()
    data_table=[]
    if (isAbon):
        cursor.execute(MakeSqlQuery_heat_water_elf_daily_for_abon(obj_parent_title, obj_title, electric_data_end, my_params))
    else:
        cursor.execute(MakeSqlQuery_heat_water_elf_daily_for_all(obj_parent_title, obj_title, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table
    
def MakeSqlQuery_rejim(obj_title, electric_data_end, energy):
    sQuery="""
    with date_st as (
   SELECT 
  objects.name, 
  abonents.name, 
  names_params.name, 
  various_values.date, 
  various_values."time", 
  various_values.value
FROM 
  public.various_values, 
  public.taken_params, 
  public.link_abonents_taken_params, 
  public.abonents, 
  public.objects, 
  public.meters, 
  public.names_params, 
  public.params
WHERE 
  various_values.id_taken_params = taken_params.id AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  abonents.guid_objects = objects.guid AND
  params.guid_names_params = names_params.guid AND
  various_values."time" =  '00:00:00' AND 
  various_values.date = ('01.'::text||(extract(month from timestamp '%s'))::text||'.'||(extract(year from timestamp '%s'))::text)::timestamp AND 
  names_params.name = '%s' and
  abonents.name='%s'
  )
  
SELECT 
  date_st.value,
   coefficient as ktt,
   coefficient_2 as ktn, 
   coefficient_3 as A,
  objects.name, 
  abonents.name,   
  names_params.name,  
  sum(Case when (various_values."time">='00:00:00' and various_values."time"<='00:30:00') then various_values.value end)/2 as t0,
  sum(Case when (various_values."time">='01:00' and various_values."time"<='01:30') then various_values.value end)/2 + date_st.value as t1,
  sum(Case when (various_values."time">='02:00' and various_values."time"<='02:30') then various_values.value end)/2 + date_st.value as t2,
  sum(Case when (various_values."time">='03:00' and various_values."time"<='03:30') then various_values.value end)/2 + date_st.value as t3,
  sum(Case when (various_values."time">='04:00' and various_values."time"<='04:30') then various_values.value end)/2 + date_st.value  as t4,
  sum(Case when (various_values."time">='05:00' and various_values."time"<='05:30') then various_values.value end)/2 + date_st.value  as t5,
  sum(Case when (various_values."time">='06:00' and various_values."time"<='06:30') then various_values.value end)/2 + date_st.value  as t6,
  sum(Case when (various_values."time">='07:00' and various_values."time"<='07:30') then various_values.value end)/2 + date_st.value  as t7,
  sum(Case when (various_values."time">='08:00' and various_values."time"<='08:30') then various_values.value end)/2 + date_st.value  as t8,
  sum(Case when (various_values."time">='09:00' and various_values."time"<='09:30') then various_values.value end)/2 + date_st.value  as t9,
  sum(Case when (various_values."time">='10:00' and various_values."time"<='10:30') then various_values.value end)/2 + date_st.value  as t10,
  sum(Case when (various_values."time">='11:00' and various_values."time"<='11:30') then various_values.value end)/2 + date_st.value  as t11,
  sum(Case when (various_values."time">='12:00' and various_values."time"<='12:30') then various_values.value end)/2 + date_st.value  as t12,
    sum(Case when (various_values."time">='13:00' and various_values."time"<='13:30') then various_values.value end)/2 + date_st.value  as t13,
  sum(Case when (various_values."time">='14:00' and various_values."time"<='14:30') then various_values.value end)/2 + date_st.value  as t14,
  sum(Case when (various_values."time">='15:00' and various_values."time"<='15:30') then various_values.value end)/2 + date_st.value  as t15,
  sum(Case when (various_values."time">='16:00' and various_values."time"<='16:30') then various_values.value end)/2 + date_st.value  as t16,
  sum(Case when (various_values."time">='17:00' and various_values."time"<='17:30') then various_values.value end)/2 + date_st.value  as t17,
  sum(Case when (various_values."time">='18:00' and various_values."time"<='18:30') then various_values.value end)/2 + date_st.value  as t18,
  sum(Case when (various_values."time">='19:00' and various_values."time"<='19:30') then various_values.value end)/2 + date_st.value  as t19,
  sum(Case when (various_values."time">='20:00' and various_values."time"<='20:30') then various_values.value end)/2 + date_st.value  as t20,
  sum(Case when (various_values."time">='21:00' and various_values."time"<='21:30') then various_values.value end)/2 + date_st.value  as t21,
  sum(Case when (various_values."time">='22:00' and various_values."time"<='22:30') then various_values.value end)/2 + date_st.value  as t22,
  sum(Case when (various_values."time">='23:00' and various_values."time"<='23:30') then various_values.value end)/2 + date_st.value  as t23
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.various_values, 
  public.params, 
  public.names_params,
  date_st
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  various_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  various_values.date = '%s' AND 
  names_params.name = '%s' and
  abonents.name='%s'

  group by   objects.name, 
  abonents.name,   
  names_params.name,
  date_st.value,
  coefficient, coefficient_2,coefficient_3
    """%(electric_data_end,electric_data_end,energy,obj_title,electric_data_end,energy,obj_title)
    #print sQuery
    return sQuery
    
def get_data_table_rejim( obj_title, electric_data_end, energy):
    #my_params=[u'Энергия',u'Объем',u'Эльф 1.08']
    cursor = connection.cursor()
    data_table=[]    
    cursor.execute(MakeSqlQuery_rejim(obj_title, electric_data_end, energy))   
    data_table = cursor.fetchall()
    
    return data_table
    

def MakeSqlQuery_pulsar1_between_dates(obj_title, obj_parent_title,electric_data_start, electric_data_end):
    sQuery="""
    Select z3.c_date,z3.ab_name,z3.obj_name, z3.gvs,z3.hvs,
round((z3.gvs-lag(gvs)over (order by c_date))::numeric,3)  as delta_gvs,
round((z3.hvs-lag(hvs) over (order by c_date))::numeric,3) as delta_hvs
from
(Select z_date.c_date,z1.ab_name,z1.obj_name, z1.gvs,z1.hvs
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z_date
left join
(
SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name,   
  daily_values.date, 
  sum(Case when resources.name= 'ГВС' then daily_values.value  end) as gvs,
  sum(Case when resources.name= 'ХВС' then daily_values.value  end) as hvs
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.resources, 
  public.names_params, 
  public.daily_values
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  names_params.guid = params.guid_names_params AND
  daily_values.id_taken_params = taken_params.id AND
  (resources.name = 'ХВС' or
  resources.name = 'ГВС') AND 
  daily_values.date BETWEEN '%s' and '%s'
  and objects.name = '%s' and
  abonents.name  = '%s'
  group by 
  objects.name, 
  abonents.name,   
  daily_values.date
  order by obj_name, ab_name, date) z1
  on z1.date=z_date.c_date
  order by z_date.c_date
  ) z3
  
    """%(electric_data_start, electric_data_end,electric_data_start, electric_data_end,obj_parent_title,obj_title)
    #print sQuery
    return sQuery

def MakeSqlQuery_pulsar1_between_dates_for_obj(obj_title,electric_data_start, electric_data_end):
    sQuery="""
    Select z3.c_date,z3.obj_name,z3.obj_name, z3.gvs,z3.hvs,
round((z3.gvs-lag(gvs) over (order by c_date))::numeric,3)  as delta_gvs,
round((z3.hvs-lag(hvs) over (order by c_date))::numeric,3) as delta_hvs
from
(Select z_date.c_date,z1.obj_name, z1.gvs,z1.hvs
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z_date
left join
(
SELECT 
  objects.name as obj_name,   
  daily_values.date, 
  sum(Case when resources.name= 'ГВС' then daily_values.value  end) as gvs,
  sum(Case when resources.name= 'ХВС' then daily_values.value  end) as hvs
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.resources, 
  public.names_params, 
  public.daily_values
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  names_params.guid = params.guid_names_params AND
  daily_values.id_taken_params = taken_params.id AND
  (resources.name = 'ХВС' or
  resources.name = 'ГВС') AND 
  daily_values.date BETWEEN '%s' and '%s'
  and objects.name = '%s' 
  group by 
  objects.name,    
  daily_values.date
  order by obj_name, date) z1
  on z1.date=z_date.c_date
  order by z_date.c_date
  ) z3
    """%(electric_data_start, electric_data_end,electric_data_start, electric_data_end, obj_title)
    #print sQuery
    return sQuery
def get_data_table_water_pulsar1_between_dates(obj_title, obj_parent_title,electric_data_start, electric_data_end, isAbon):
    cursor = connection.cursor()
    data_table=[]
    if isAbon:    
        cursor.execute(MakeSqlQuery_pulsar1_between_dates(obj_title, obj_parent_title,electric_data_start, electric_data_end))
    else:
        cursor.execute(MakeSqlQuery_pulsar1_between_dates_for_obj(obj_title,electric_data_start, electric_data_end))
    data_table = cursor.fetchall()
    
    return data_table
    
def MakeSqlQuery_comments_for_abon(guid_abonent):
    sQuery="""
    SELECT 
  comments.guid, 
  comments.comment, 
  comments.date, 
  comments.guid_abonents, 
  abonents.name, 
  objects.name
FROM 
  public.comments, 
  public.abonents, 
  public.objects
WHERE 
  comments.guid_abonents = abonents.guid AND
  abonents.guid_objects = objects.guid AND
  comments.guid_abonents = '%s'
  order by comments.date
    """%(guid_abonent)
    #print sQuery
    return sQuery
def get_data_table_comments_for_abon(guid_abonent):
    cursor = connection.cursor()
    data_table=[]    
    cursor.execute(MakeSqlQuery_comments_for_abon(guid_abonent))   
    data_table = cursor.fetchall()
    
    return data_table

def MakeSqlQuery_karat_for_abon(obj_parent_title, obj_title, electric_data_end,  my_params):
    sQuery="""
    Select z1.date,heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual,  z1.Q,z1.M,z1.ti,z1.to,z1.ton,z1.terr
from heat_abons
left join
(SELECT 
daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  sum(Case when names_params.name = 'Q Система1' then daily_values.value  end) as Q,
  sum(Case when names_params.name = 'M Система1' then daily_values.value  end) as M,
sum(Case when names_params.name = 'Ti' then daily_values.value  end) as ti,
sum(Case when names_params.name = 'To' then daily_values.value  end) as to,
sum(Case when names_params.name = 'Ton' then daily_values.value  end) as ton,
sum(Case when names_params.name = 'Terr' then daily_values.value  end) as terr,
abonents.guid
FROM 
  public.objects, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.meters, 
  public.types_params, 
  public.resources, 
  public.names_params, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_types_params = types_params.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  types_meters.name = '%s'

  group by   
  daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  types_meters.name,
  abonents.guid 
) z1
on z1.guid=heat_abons.ab_guid
where heat_abons.obj_name='%s' and
heat_abons.ab_name='%s' and
heat_abons.type_meters = '%s'
order by heat_abons.ab_name
    """%(electric_data_end, my_params[0],obj_parent_title, obj_title, my_params[0])
    return sQuery
    
def MakeSqlQuery_karat_for_korp(obj_parent_title, obj_title, electric_data_end,  my_params):
    sQuery="""
    Select z1.date,heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual,  z1.Q,z1.M,z1.ti,z1.to,z1.ton,z1.terr
from heat_abons
left join
(SELECT 
daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  sum(Case when names_params.name = 'Q Система1' then daily_values.value  end) as Q,
  sum(Case when names_params.name = 'M Система1' then daily_values.value  end) as M,
sum(Case when names_params.name = 'Ti' then daily_values.value  end) as ti,
sum(Case when names_params.name = 'To' then daily_values.value  end) as to,
sum(Case when names_params.name = 'Ton' then daily_values.value  end) as ton,
sum(Case when names_params.name = 'Terr' then daily_values.value  end) as terr,
abonents.guid
FROM 
  public.objects, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.meters, 
  public.types_params, 
  public.resources, 
  public.names_params, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_types_params = types_params.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  types_meters.name = '%s'

  group by   
  daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  types_meters.name,
  abonents.guid 
) z1
on z1.guid=heat_abons.ab_guid
where heat_abons.obj_name='%s' and
heat_abons.type_meters = '%s'
order by heat_abons.ab_name
    """%(electric_data_end, my_params[0], obj_title, my_params[0])
    return sQuery
    
def get_data_table_karat_heat_water_daily(obj_parent_title, obj_title, electric_data_end, isAbon):
    my_params=[u'Карат 307']    
    cursor = connection.cursor()
    data_table=[]    
    if isAbon:
        cursor.execute(MakeSqlQuery_karat_for_abon(obj_parent_title, obj_title, electric_data_end, my_params))  
    else:
         cursor.execute(MakeSqlQuery_karat_for_korp(obj_parent_title, obj_title, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table

def MakeSqlQuery_karat_for_abon_for_period(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z_start.ab_name, z_start.factory_number_manual, z_start.Q, z_end.Q, round((Z_end.Q-z_start.Q)::numeric,2), z_start.M, z_end.M, round((Z_end.M-z_start.M)::numeric,2), 
z_start.ton, z_end.ton, round((Z_end.ton-z_start.ton)::numeric,2)
from
(Select z1.date,heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual,  z1.Q,z1.M,z1.ti,z1.to,z1.ton,z1.terr, heat_abons.ab_guid
from heat_abons
left join
(SELECT 
daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  sum(Case when names_params.name = 'Q Система1' then daily_values.value  end) as Q,
  sum(Case when names_params.name = 'M Система1' then daily_values.value  end) as M,
sum(Case when names_params.name = 'Ti' then daily_values.value  end) as ti,
sum(Case when names_params.name = 'To' then daily_values.value  end) as to,
sum(Case when names_params.name = 'Ton' then daily_values.value  end) as ton,
sum(Case when names_params.name = 'Terr' then daily_values.value  end) as terr,
abonents.guid
FROM 
  public.objects, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.meters, 
  public.types_params, 
  public.resources, 
  public.names_params, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_types_params = types_params.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  types_meters.name = '%s'

  group by   
  daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  types_meters.name,
  abonents.guid 
) z1
on z1.guid=heat_abons.ab_guid
where heat_abons.obj_name='%s' and
heat_abons.ab_name='%s' and
heat_abons.type_meters = '%s'
order by heat_abons.ab_name) z_start,
(Select z1.date,heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual,  z1.Q,z1.M,z1.ti,z1.to,z1.ton,z1.terr, heat_abons.ab_guid
from heat_abons
left join
(SELECT 
daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  sum(Case when names_params.name = 'Q Система1' then daily_values.value  end) as Q,
  sum(Case when names_params.name = 'M Система1' then daily_values.value  end) as M,
sum(Case when names_params.name = 'Ti' then daily_values.value  end) as ti,
sum(Case when names_params.name = 'To' then daily_values.value  end) as to,
sum(Case when names_params.name = 'Ton' then daily_values.value  end) as ton,
sum(Case when names_params.name = 'Terr' then daily_values.value  end) as terr,
abonents.guid
FROM 
  public.objects, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.meters, 
  public.types_params, 
  public.resources, 
  public.names_params, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_types_params = types_params.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  types_meters.name = '%s'

  group by   
  daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  types_meters.name,
  abonents.guid 
) z1
on z1.guid=heat_abons.ab_guid
where heat_abons.obj_name='%s' and
heat_abons.ab_name='%s' and
heat_abons.type_meters = '%s'
order by heat_abons.ab_name) z_end
where z_start.ab_guid=z_end.ab_guid
    """%(electric_data_start, my_params[0],obj_parent_title, obj_title, my_params[0],electric_data_end, my_params[0],obj_parent_title, obj_title, my_params[0])
    return sQuery
    
def MakeSqlQuery_karat_for_korp_for_period(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z_start.ab_name, z_start.factory_number_manual, z_start.Q, z_end.Q, round((Z_end.Q-z_start.Q)::numeric,2), z_start.M, z_end.M, round((Z_end.M-z_start.M)::numeric,2), 
z_start.ton, z_end.ton, round((Z_end.ton-z_start.ton)::numeric,2)
from
(Select z1.date,heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual,  z1.Q,z1.M,z1.ti,z1.to,z1.ton,z1.terr, heat_abons.ab_guid
from heat_abons
left join
(SELECT 
daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  sum(Case when names_params.name = 'Q Система1' then daily_values.value  end) as Q,
  sum(Case when names_params.name = 'M Система1' then daily_values.value  end) as M,
sum(Case when names_params.name = 'Ti' then daily_values.value  end) as ti,
sum(Case when names_params.name = 'To' then daily_values.value  end) as to,
sum(Case when names_params.name = 'Ton' then daily_values.value  end) as ton,
sum(Case when names_params.name = 'Terr' then daily_values.value  end) as terr,
abonents.guid
FROM 
  public.objects, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.meters, 
  public.types_params, 
  public.resources, 
  public.names_params, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_types_params = types_params.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  types_meters.name = '%s'

  group by   
  daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  types_meters.name,
  abonents.guid 
) z1
on z1.guid=heat_abons.ab_guid
where heat_abons.obj_name='%s' and
heat_abons.type_meters = '%s'
order by heat_abons.ab_name) z_start,
(Select z1.date,heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual,  z1.Q,z1.M,z1.ti,z1.to,z1.ton,z1.terr, heat_abons.ab_guid
from heat_abons
left join
(SELECT 
daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  sum(Case when names_params.name = 'Q Система1' then daily_values.value  end) as Q,
  sum(Case when names_params.name = 'M Система1' then daily_values.value  end) as M,
sum(Case when names_params.name = 'Ti' then daily_values.value  end) as ti,
sum(Case when names_params.name = 'To' then daily_values.value  end) as to,
sum(Case when names_params.name = 'Ton' then daily_values.value  end) as ton,
sum(Case when names_params.name = 'Terr' then daily_values.value  end) as terr,
abonents.guid
FROM 
  public.objects, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.daily_values, 
  public.params, 
  public.meters, 
  public.types_params, 
  public.resources, 
  public.names_params, 
  public.types_meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_types_params = types_params.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid_types_meters = types_meters.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.date = '%s' AND 
  types_meters.name = '%s'

  group by   
  daily_values.date,
  objects.name, 
  abonents.name,  
  meters.factory_number_manual, 
  types_meters.name,
  abonents.guid 
) z1
on z1.guid=heat_abons.ab_guid
where heat_abons.obj_name='%s' and
heat_abons.type_meters = '%s'
order by heat_abons.ab_name) z_end
where z_start.ab_guid=z_end.ab_guid
    """%(electric_data_start, my_params[0], obj_title, my_params[0],electric_data_end, my_params[0], obj_title, my_params[0])
    return sQuery   
    
def get_karat_potreblenie(obj_parent_title, obj_title,electric_data_start, electric_data_end, isAbon):
    my_params=[u'Карат 307']    
    cursor = connection.cursor()
    data_table=[]    
    if isAbon:
        cursor.execute(MakeSqlQuery_karat_for_abon_for_period(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params))  
    else:
         cursor.execute(MakeSqlQuery_karat_for_korp_for_period(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params))
    data_table = cursor.fetchall()
    
    return data_table
 
def MakeSqlQuery_balance_electric(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""
    SELECT 
  balance_groups.name, 
  link_balance_groups_meters.type, 
  types_abonents.name, 
  sum(daily_values.value * link_abonents_taken_params.coefficient), 
  names_params.name, 
  resources.name
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.link_balance_groups_meters, 
  public.taken_params, 
  public.meters, 
  public.balance_groups, 
  public.types_abonents, 
  public.daily_values, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND
  abonents.guid_types_abonents = types_abonents.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_balance_groups_meters.guid_meters = meters.guid AND
  link_balance_groups_meters.guid_balance_groups = balance_groups.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  balance_groups.name = '%s' AND 
  daily_values.date = '%s' AND 
  names_params.name = '%s' 
  group by  balance_groups.name, 
  link_balance_groups_meters.type, 
  types_abonents.name, 

  names_params.name, 
  resources.name

    """%(obj_title,electric_data_end,my_params[1])
    return sQuery
def get_data_table_balance_electric_daily(obj_parent_title, obj_title, electric_data_end,type_resource):
    my_params=[type_resource, u'T0 A+']    
    cursor = connection.cursor()
    data_table=[]    
    cursor.execute(MakeSqlQuery_balance_electric(obj_parent_title, obj_title, electric_data_end, my_params))    
    data_table = cursor.fetchall()
    
    return data_table
    
def GetSimpleTable(table,fieldName,value):
    dt=[]
    cursor = connection.cursor()
    if len(fieldName)>0:
        sQuery="""
        Select *
        from %s
        where %s.%s='%s'"""%(table, table, fieldName, value)
    else: sQuery="""
        Select *
        from %s"""%(table)
        
    #print sQuery
    cursor.execute(sQuery)
    dt = cursor.fetchall()
    return dt

def MakeSqlQuery_balance_electric_period(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params, guid_type_abon):
    sQuery="""
    select balance_name,type,type_abon,sumT,res_name, c_date,
round((z1.sumT-lag(sumT) over (order by date))::numeric,3) as delta,
countAbon,
guid_types_abonents
from
(Select * 
from(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z4
left join 
(
SELECT
  balance_groups.name as balance_name,
  link_balance_groups_meters.type,
  types_abonents.name as type_abon,
  sum(daily_values.value * link_abonents_taken_params.coefficient) as sumT,
  count(daily_values.value) as countAbon,
  names_params.name as param_name,
  resources.name AS res_name,
  daily_values.date,
  abonents.guid_types_abonents
FROM
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.link_balance_groups_meters,
  public.taken_params,
  public.meters,
  public.balance_groups,
  public.types_abonents,
  public.daily_values,
  public.params,
  public.names_params,
  public.resources
WHERE
  abonents.guid_objects = objects.guid AND
  abonents.guid_types_abonents = types_abonents.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_balance_groups_meters.guid_meters = meters.guid AND
  link_balance_groups_meters.guid_balance_groups = balance_groups.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  balance_groups.name = '%s' AND
  resources.name='%s' and
  daily_values.date between '%s' and '%s' AND
  names_params.name = '%s' and
  types_abonents.guid='%s'
  group by  balance_groups.name,
  link_balance_groups_meters.type,
  types_abonents.name,
  abonents.guid_types_abonents,
  names_params.name,
  resources.name,daily_values.date
  order by types_abonents.name,date)z3
on z4.c_date=z3.date ) z1
order by c_date"""%(electric_data_start, electric_data_end, obj_title,my_params[0], electric_data_start, electric_data_end,my_params[1],guid_type_abon)
    #print sQuery
    return sQuery
        
def get_data_table_balance_electric_perid(obj_parent_title, obj_title,electric_data_start, electric_data_end,guid_type_abon):
    my_params=[u'Электричество', u'T0 A+']    
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_balance_electric_period(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params, guid_type_abon))    
    data_table = cursor.fetchall()    
    return data_table

def MakeSqlQuery_balance_electric_period_potrebiteli(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params, type_abon):
    sQuery="""
    select balance_name,type,'%s'::text,sumT,res_name, date,
round((z1.sumT-lag(sumT) over (order by date))::numeric,3) as delta,
countAbon
from
(SELECT 
  balance_groups.name as balance_name, 
  link_balance_groups_meters.type, 
 
  sum(daily_values.value * link_abonents_taken_params.coefficient) as sumT, 
  count(daily_values.value) as countAbon,
  names_params.name as param_name, 
  resources.name AS res_name, 
  daily_values.date
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.link_balance_groups_meters, 
  public.taken_params, 
  public.meters, 
  public.balance_groups, 

  public.daily_values, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  abonents.guid_objects = objects.guid AND

  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_balance_groups_meters.guid_meters = meters.guid AND
  link_balance_groups_meters.guid_balance_groups = balance_groups.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  balance_groups.name = '%s' AND 
  daily_values.date between'%s' and '%s' AND 
  resources.name='%s' and
  names_params.name = '%s' and  
  link_balance_groups_meters.type is False
  group by  balance_groups.name, 
  link_balance_groups_meters.type, 
  names_params.name, 
  resources.name,daily_values.date
  order by date) z1 """%(type_abon,obj_title,electric_data_start, electric_data_end,my_params[0],my_params[1])
    #print sQuery
    return sQuery
def get_data_table_balance_electric_perid_potrebiteli(obj_parent_title, obj_title,electric_data_start, electric_data_end, type_abon):
    my_params=[u'Электричество', u'T0 A+']    
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_balance_electric_period_potrebiteli(obj_parent_title, obj_title,electric_data_start, electric_data_end, my_params, type_abon))    
    data_table = cursor.fetchall()    
    return data_table

def MakeSqlQuery_all_res_by_date_for_abon(obj_parent_title_water, obj_parent_title_electric, obj_title, electric_data_end, my_params):
    sQuery="""
    Select water_abons_report.ab_name as meter,
 type_energo,water_abons_report.meter_name, z1.value, z1.date, 
 water_abons_report.obj_name as water_ab_name,
  water_abons_report.name as obj_name
from water_abons_report
LEFT JOIN
(SELECT
  meters.name as meters_name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s') z1
  on z1.ab_name=water_abons_report.ab_name
  where water_abons_report.name ='%s'
  and water_abons_report.obj_name='%s'

  union

  Select name_meter,type_energo,electric_abons_without_sum_report.factory_number_manual, z1.value,z1.date_start, electric_abons_without_sum_report.ab_name, electric_abons_without_sum_report.obj_name
from electric_abons_without_sum_report
Left join
(
SELECT
  daily_values.date as date_start,
  objects.name as obj_name,
  abonents.name as ab_name,
  meters.factory_number_manual as zav_num,
  meters.name as meter_name,
  daily_values.value,
  names_params.name as names_params
FROM
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.meters,
  public.types_meters,
  public.params,
  public.names_params,
  resources
WHERE
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  resources.guid=names_params.guid_resources and
  resources.name='%s' and
  daily_values.date = '%s'
  group by daily_values.date,
  objects.name,
  abonents.name,
  meters.factory_number_manual,
  types_meters.name,
  daily_values.value,
  meters.name,
  names_params.name
  order by objects.name,
  abonents.name) z1
on electric_abons_without_sum_report.name_meter=z1.meter_name and z1.names_params=electric_abons_without_sum_report.name_params
where electric_abons_without_sum_report.ab_name='%s' and
 electric_abons_without_sum_report.obj_name='%s'

 union

Select heat_abons.type_meters::text||' '||heat_abons.factory_number_manual::text, name_param,factory_number_manual, z1.value,z1.date_start, heat_abons.ab_name, heat_abons.obj_name
from heat_abons
Left join
(SELECT
  daily_values.date as date_start,
  objects.name as obj_name,
  abonents.name as ab_name,
  meters.factory_number_manual as zav_num,
  meters.name as meter_name,
  daily_values.value,
  types_meters.name as type_meter,
  names_params.name as name_param
FROM
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.meters,
  public.types_meters,
  public.params,
  public.names_params,
  resources
WHERE
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  resources.guid=names_params.guid_resources and
  resources.name='%s' and
  daily_values.date = '%s' 
  group by daily_values.date,
  objects.name,
  abonents.name,
  meters.factory_number_manual,
  types_meters.name,
  daily_values.value,
  meters.name, names_params.name
  order by objects.name,
  abonents.name) z1
on heat_abons.factory_number_manual=z1.zav_num
where heat_abons.ab_name='%s' and 
heat_abons.obj_name='%s'

order by meter, type_energo
    """%(my_params[2], electric_data_end,obj_parent_title_water, obj_title, my_params[0], electric_data_end, obj_title,obj_parent_title_electric, my_params[1], electric_data_end,obj_title, obj_parent_title_electric)
    #print sQuery
    return sQuery
def get_data_table_all_res_for_abon(obj_parent_title_water, obj_parent_title_electric, obj_title, electric_data_end):
    my_params=[u'Электричество', u'Тепло', u'Импульс', ]    
    cursor = connection.cursor()
    data_table=[]  
    
    cursor.execute(MakeSqlQuery_all_res_by_date_for_abon(obj_parent_title_water, obj_parent_title_electric, obj_title, electric_data_end, my_params))    
    data_table = cursor.fetchall()
    
    return data_table
 
def MakeSqlQuery_water_period_with_delta_for_abon(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z3.c_date,z3.ab_name,z3.obj_name, z3.res_name, z3.gvs,z3.hvs,
round((z3.gvs-lag(gvs)over (order by c_date))::numeric,3)  as delta_gvs,
round((z3.hvs-lag(hvs) over (order by c_date))::numeric,3) as delta_hvs
from
(Select z_date.c_date,z1.ab_name,z1.obj_name, z1.res_name, z1.gvs,z1.hvs
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z_date
left join
(
SELECT
  daily_values.date,
  obj_name as ab_name,  
  water_abons_report.name as obj_name,
  resources.name as res_name,
  sum(Case when abonents.name like '%s' then daily_values.value  end) as gvs,
  sum(Case when abonents.name not like '%s' then daily_values.value  end) as hvs
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  AND
  daily_values.date between '%s' and '%s' and
  water_abons_report.name='%s'
  and obj_name='%s'
  group by  
  daily_values.date,
  obj_name,  
  water_abons_report.name,
  resources.name) z1
  on z1.date=z_date.c_date
  order by z_date.c_date) z3"""%(electric_data_start, electric_data_end,my_params[1],my_params[1],my_params[2],electric_data_start, electric_data_end,obj_parent_title,obj_title)
    #print sQuery    
    return sQuery
def MakeSqlQuery_water_period_with_delta_for_all(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z3.c_date,z3.obj_name,z3.obj_name, z3.res_name, z3.gvs,z3.hvs,
round((z3.gvs-lag(gvs)over (order by c_date))::numeric,3)  as delta_gvs,
round((z3.hvs-lag(hvs) over (order by c_date))::numeric,3) as delta_hvs
from
(Select z_date.c_date,z1.obj_name, z1.res_name, z1.gvs,z1.hvs
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z_date
left join
(
SELECT
  daily_values.date, 
  water_abons_report.name as obj_name,
  resources.name as res_name,
  sum(Case when abonents.name like '%s' then daily_values.value  end) as gvs,
  sum(Case when abonents.name not like '%s' then daily_values.value  end) as hvs
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  AND
  daily_values.date between '%s' and '%s' and
  water_abons_report.name='%s'
  
  group by  
  daily_values.date,  
  water_abons_report.name,
  resources.name) z1
  on z1.date=z_date.c_date
  order by z_date.c_date) z3"""%(electric_data_start, electric_data_end,my_params[1],my_params[1],my_params[2],electric_data_start, electric_data_end,obj_title)
    #print sQuery    
    return sQuery
    
def get_data_table_water_between(obj_title,obj_parent_title,electric_data_start, electric_data_end,isAbon):
    my_params=[u'%ХВС%', u'%ГВС%', u'Импульс', ]    
    cursor = connection.cursor()
    data_table=[]  
    if isAbon:
        cursor.execute(MakeSqlQuery_water_period_with_delta_for_abon(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params))  
    else:
        cursor.execute(MakeSqlQuery_water_period_with_delta_for_all(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params))  
    data_table = cursor.fetchall()
    
    return data_table

def MakeSqlQuery_heat_period_with_delta_for_abon(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z3.c_date,z3.name_abonents,z3.name_objects, z3.number_manual, z3.energy,z3.volume,
round((z3.energy-lag(energy)over (order by c_date))::numeric,3)  as delta_energy,
round((z3.volume-lag(volume) over (order by c_date))::numeric,3) as delta_volume
from
(
Select *
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z_date
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  objects.name = '%s' AND
            			  abonents.name = '%s' and 
            			  types_meters.name = '%s' AND 
            			  daily_values.date between '%s' and '%s'
                                    ) z1                      
group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual
order by z1.name_abonents) z2
on z2.daily_date=z_date.c_date
 order by z_date.c_date) z3
    """%(electric_data_start, electric_data_end,my_params[1],my_params[2],my_params[3],my_params[4], obj_parent_title, obj_title,my_params[0],electric_data_start, electric_data_end)
    #print sQuery
    return sQuery

def MakeSqlQuery_heat_period_with_delta_for_all(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z3.c_date,z3.name_objects,z3.name_objects,z3.name_objects,  z3.energy,z3.volume,
round((z3.energy-lag(energy)over (order by c_date))::numeric,3)  as delta_energy,
round((z3.volume-lag(volume) over (order by c_date))::numeric,3) as delta_volume
from
(
Select *
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z_date
left join
(SELECT z1.daily_date, z1.name_objects,  
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  
            			  daily_values.value as value_daily, 
            			 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  objects.name = '%s' AND            		
            			  types_meters.name = '%s' AND 
            			  daily_values.date between '%s' and '%s'
                                    ) z1                      
group by  z1.daily_date, z1.name_objects) z2
on z2.daily_date=z_date.c_date
 order by z_date.c_date) z3
    """%(electric_data_start, electric_data_end,my_params[1],my_params[2],my_params[3],my_params[4], obj_title,my_params[0],electric_data_start, electric_data_end)
    #print sQuery
    return sQuery
    
def get_data_table_heat_between(obj_parent_title, obj_title,electric_data_start, electric_data_end,isAbon):
    my_params=[u'Пульсар Теплосчётчик', u'Энергия', u'Объем', u'Ti',u'To' ]    
    cursor = connection.cursor()
    data_table=[]  
    if isAbon:
        cursor.execute(MakeSqlQuery_heat_period_with_delta_for_abon(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params))  
    else:
        cursor.execute(MakeSqlQuery_heat_period_with_delta_for_all(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params))  
    data_table = cursor.fetchall()
    
    return data_table
    
def generate_monthly_range(electric_data_start,electric_data_end):
    cursor = connection.cursor()
    data_table=[]  
    sQuery="""
    SELECT generate_series((Select * from 
make_date(extract(year from '%s'::timestamp)::int,extract(month from '%s'::timestamp)::int, 1)), 
(Select * from 
make_date(extract(year from '%s'::timestamp)::int,extract(month from '%s'::timestamp)::int, 1)), '1 month')::timestamp without time zone
    """%(electric_data_start,electric_data_start,electric_data_end,electric_data_end)
    #print sQuery
    cursor.execute(sQuery)
    data_table = cursor.fetchall()    
    return data_table
 
def MakeSqlQuery_elf_period_monthly_for_all(data_start, data_end, my_params):
    sQuery="""
    Select z_end.ab_name, z_end.factory_number_manual, z_end.attr2,
CASE
            WHEN  z_end.channel = 2 THEN 'ГВ'::text
            WHEN  z_end.channel = 1 Then 'ХВ'::text
   END as type_res,  
   z_start.val_start,
z_end.val_end, round((z_end.val_end-z_start.val_start)::numeric,3) as delta
from
(Select ab_name, water_abons.factory_number_manual,water_abons.attr2,z1.val_end, z1.type_res, water_abons.ab_guid,  water_abons.channel
from water_abons
left join
(SELECT
  daily_values.date,
  abonents.name,  
  meters.factory_number_manual,
  abonents.guid as abon_guid,
  daily_values.value as val_end,
  taken_params.id,
  params.channel,
  abonents.guid as ab_guid,
  meters.guid,
    CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter
FROM
  public.meters,
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.params
WHERE
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  daily_values.date='%s' 
  and (channel=1 or channel=2)
ORDER BY
  abonents.name ASC) as z1
  on z1.meter=water_abons.attr2 and z1.abon_guid=water_abons.ab_guid and z1.channel=water_abons.channel
) as z_end,

  (Select ab_name, water_abons.factory_number_manual, z1.meter,z1.val_start, z1.type_res, water_abons.attr2,  water_abons.ab_guid, water_abons.channel
from water_abons
left join
(SELECT
  daily_values.date,
  abonents.name,  
  meters.factory_number_manual,
abonents.guid as abon_guid,
  daily_values.value as val_start,
  taken_params.id,
  params.channel,
  abonents.guid as ab_guid,
   meters.guid,
    CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter
FROM
  public.meters,
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.params
WHERE
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  daily_values.date='%s' 
  and (channel=1 or channel=2) 
ORDER BY
  abonents.name ASC) as z1
  on z1.meter=water_abons.attr2 and z1.abon_guid=water_abons.ab_guid  and z1.channel=water_abons.channel
 ) as z_start 
  where z_end.attr2=z_start.attr2 and z_end.ab_guid=z_start.ab_guid and z_end.channel=z_start.channel
  order by z_end.ab_name,z_end.attr2,z_end.channel 
      """%(my_params[0],my_params[1],data_end,my_params[0],my_params[1],data_start)
    #print sQuery
    #print '______________________________________________________________________________'
    return sQuery
    
    
def get_data_table_elf_period_monthly(data_start, data_end):
    my_params=[u'ГВ', u'ХВ']    
    cursor = connection.cursor()
    data_table=[]  
    cursor.execute(MakeSqlQuery_elf_period_monthly_for_all(data_start, data_end, my_params))  
    data_table = cursor.fetchall()
    
    return data_table

def MakeSqlQuery_elf_period_with_delta_for_all(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z_end.ab_name, z_end.factory_number_manual, z_end.attr2,
CASE
            WHEN  z_end.channel = 2 THEN '%s'::text
            WHEN  z_end.channel = 1 Then '%s'::text
   END as type_res,  
   z_start.val_start,
z_end.val_end, round((z_end.val_end-z_start.val_start)::numeric,3) as delta
from
(Select ab_name, water_abons.factory_number_manual,water_abons.attr2,z1.val_end, z1.type_res, water_abons.ab_guid,  water_abons.channel
from water_abons
left join
(SELECT
  daily_values.date,
  abonents.name,  
  meters.factory_number_manual,
  abonents.guid as abon_guid,
  daily_values.value as val_end,
  taken_params.id,
  params.channel,
  abonents.guid as ab_guid,
  meters.guid,
    CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter
FROM
  public.meters,
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.params
WHERE
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  daily_values.date='%s' 
  and (channel=1 or channel=2)
ORDER BY
  abonents.name ASC) as z1
  on z1.meter=water_abons.attr2 and z1.abon_guid=water_abons.ab_guid and z1.channel=water_abons.channel
  where water_abons.obj_name = '%s'
) as z_end,

  (Select ab_name, water_abons.factory_number_manual, z1.meter,z1.val_start, z1.type_res, water_abons.attr2,  water_abons.ab_guid, water_abons.channel
from water_abons
left join
(SELECT
  daily_values.date,
  abonents.name,  
  meters.factory_number_manual,
abonents.guid as abon_guid,
  daily_values.value as val_start,
  taken_params.id,
  params.channel,
  abonents.guid as ab_guid,
   meters.guid,
    CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter
FROM
  public.meters,
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.params
WHERE
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  daily_values.date='%s' 
  and (channel=1 or channel=2) 
ORDER BY
  abonents.name ASC) as z1
  on z1.meter=water_abons.attr2 and z1.abon_guid=water_abons.ab_guid  and z1.channel=water_abons.channel
  where water_abons.obj_name = '%s'
 ) as z_start 
  where z_end.attr2=z_start.attr2 and z_end.ab_guid=z_start.ab_guid and z_end.channel=z_start.channel
  order by z_end.ab_name,z_end.attr2,z_end.channel 
    """%( my_params[0], my_params[1], my_params[0], my_params[1],electric_data_end,obj_title,  my_params[0], my_params[1],electric_data_start,obj_title)
    return sQuery  
 
def MakeSqlQuery_elf_period_with_delta_for_abon(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select z_end.ab_name, z_end.factory_number_manual, z_end.attr2,
CASE
            WHEN  z_end.channel = 2 THEN '%s'::text
            WHEN  z_end.channel = 1 Then '%s'::text
   END as type_res,  
   z_start.val_start,
z_end.val_end, round((z_end.val_end-z_start.val_start)::numeric,3) as delta
from
(Select ab_name, water_abons.factory_number_manual,water_abons.attr2,z1.val_end, z1.type_res, water_abons.ab_guid,  water_abons.channel
from water_abons
left join
(SELECT
  daily_values.date,
  abonents.name,  
  meters.factory_number_manual,
  abonents.guid as abon_guid,
  daily_values.value as val_end,
  taken_params.id,
  params.channel,
  abonents.guid as ab_guid,
  meters.guid,
    CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter
FROM
  public.meters,
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.params
WHERE
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  daily_values.date='%s' 
  and (channel=1 or channel=2)
ORDER BY
  abonents.name ASC) as z1
  on z1.meter=water_abons.attr2 and z1.abon_guid=water_abons.ab_guid and z1.channel=water_abons.channel
  where water_abons.obj_name = '%s'  and water_abons.ab_name = '%s'
) as z_end,

  (Select ab_name, water_abons.factory_number_manual, z1.meter,z1.val_start, z1.type_res, water_abons.attr2,  water_abons.ab_guid, water_abons.channel
from water_abons
left join
(SELECT
  daily_values.date,
  abonents.name,  
  meters.factory_number_manual,
abonents.guid as abon_guid,
  daily_values.value as val_start,
  taken_params.id,
  params.channel,
  abonents.guid as ab_guid,
   meters.guid,
    CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter
FROM
  public.meters,
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.params
WHERE
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  daily_values.date='%s' 
  and (channel=1 or channel=2) 
ORDER BY
  abonents.name ASC) as z1
  on z1.meter=water_abons.attr2 and z1.abon_guid=water_abons.ab_guid  and z1.channel=water_abons.channel
  where water_abons.obj_name = '%s'  and water_abons.ab_name = '%s'
 ) as z_start 
  where z_end.attr2=z_start.attr2 and z_end.ab_guid=z_start.ab_guid and z_end.channel=z_start.channel
  order by z_end.ab_name,z_end.attr2,z_end.channel 
    """%( my_params[0], my_params[1], my_params[0], my_params[1],electric_data_end,obj_parent_title,obj_title,  my_params[0], my_params[1],electric_data_start,obj_parent_title,obj_title)
    return sQuery
    
    
def get_data_table_water_period_elf(obj_title, obj_parent_title, electric_data_start, electric_data_end, isAbon):
    my_params=[u'ГВ', u'ХВ' ]    
    cursor = connection.cursor()
    data_table=[]  
    if isAbon:
        cursor.execute(MakeSqlQuery_elf_period_with_delta_for_abon(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params))  
    else:
        cursor.execute(MakeSqlQuery_elf_period_with_delta_for_all(obj_parent_title, obj_title, electric_data_start, electric_data_end, my_params))  
    data_table = cursor.fetchall()
    
    return data_table

def MakeSqlQuery_elf_daily_for_all(obj_parent_title, obj_title,  electric_data_end, my_params):
    sQuery="""
    Select ab_name, water_abons.factory_number_manual, z1.meter,z1.val_start, z1.type_res, water_abons.attr2,  water_abons.ab_guid, water_abons.channel
from water_abons
left join
(SELECT
  daily_values.date,
  abonents.name,  
  meters.factory_number_manual,
abonents.guid as abon_guid,
  daily_values.value as val_start,
  taken_params.id,
  params.channel,
  abonents.guid as ab_guid,
   meters.guid,
    CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter
FROM
  public.meters,
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.params
WHERE
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  daily_values.date='%s' 
  and (channel=1 or channel=2) 
ORDER BY
  abonents.name ASC) as z1
  on z1.meter=water_abons.attr2 and z1.abon_guid=water_abons.ab_guid  and z1.channel=water_abons.channel
  where water_abons.obj_name = '%s'
  order by water_abons.ab_name
    """%( my_params[0],my_params[1], electric_data_end, obj_title)
    return sQuery 
   
def MakeSqlQuery_elf_daily_for_abon(obj_parent_title, obj_title, electric_data_end, my_params):
    sQuery="""
    Select ab_name, water_abons.factory_number_manual, z1.meter,z1.val_start, z1.type_res, water_abons.attr2,  water_abons.ab_guid, water_abons.channel
from water_abons
left join
(SELECT
  daily_values.date,
  abonents.name,  
  meters.factory_number_manual,
abonents.guid as abon_guid,
  daily_values.value as val_start,
  taken_params.id,
  params.channel,
  abonents.guid as ab_guid,
   meters.guid,
    CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter
FROM
  public.meters,
  public.abonents,
  public.objects,
  public.link_abonents_taken_params,
  public.taken_params,
  public.daily_values,
  public.params
WHERE
  meters.guid = taken_params.guid_meters AND
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.id = daily_values.id_taken_params AND
  taken_params.guid_params = params.guid AND
  daily_values.date='%s' 
  and (channel=1 or channel=2) 
ORDER BY
  abonents.name ASC) as z1
  on z1.meter=water_abons.attr2 and z1.abon_guid=water_abons.ab_guid  and z1.channel=water_abons.channel
  where water_abons.obj_name = '%s' and water_abons.ab_name = '%s'
  order by water_abons.ab_name
    """%( my_params[0],my_params[1], electric_data_end, obj_parent_title, obj_title)
    #print sQuery
    return sQuery 
    
def get_data_table_water_daily_elf(obj_title, obj_parent_title, electric_data_end, isAbon):
    my_params=[u'ГВ', u'ХВ' ]    
    cursor = connection.cursor()
    data_table=[]  
    if isAbon:
        cursor.execute(MakeSqlQuery_elf_daily_for_abon(obj_parent_title, obj_title,  electric_data_end, my_params))  
    else:
        cursor.execute(MakeSqlQuery_elf_daily_for_all(obj_parent_title, obj_title, electric_data_end, my_params))  
    data_table = cursor.fetchall()
    
    return data_table

def MakeSqlQuery_electric_no_data( obj_title,  electric_data_end, my_params):
    sQuery="""
    Select 
  electric_abons.obj_name, electric_abons.ab_name, 
    electric_abons.factory_number_manual, z2.t0, z2.t1, z2.t2, z2.t3
    
from electric_abons
LEFT JOIN 
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t3
                        FROM
                        (SELECT daily_values.date as daily_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        daily_values.value as value_daily, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources			
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = daily_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and
                        Objects.name= '%s' 
                        and            
                        daily_values.date = '%s' 
                        ) z1                      
group by z1.name_objects, z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktn, z1.ktt, z1.a 
) z2
on electric_abons.ab_name=z2.name_abonents
where  electric_abons.obj_name= '%s' 
and z2.t0 is null
   
ORDER BY electric_abons.obj_name, electric_abons.ab_name ASC """%(my_params[0],my_params[1],my_params[2],my_params[3],my_params[4],obj_title,electric_data_end,obj_title)
    return sQuery
    
def get_electric_no_data(obj_title, electric_data_end):
    my_params=['T0 A+','T1 A+','T2 A+','T3 A+','Электричество']   
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_electric_no_data( obj_title,  electric_data_end, my_params))  
    data_table = cursor.fetchall()    
    return data_table

def MakeSqlQuery_electric_count( obj_title,  electric_data_end, my_params):
    sQuery="""
    select obj_name, count (t0) as have_val,  count (ab_name) as all_row, round((count(t0)*100/count(ab_name))::numeric,0) as percent_val, (count (ab_name)-count (t0)) as no_val, '%s'
from
(
Select  z2.daily_date,
  electric_abons.obj_name, electric_abons.ab_name, 
    electric_abons.factory_number_manual, z2.t0, z2.t1, z2.t2, z2.t3, z2.ktn, z2.ktt, z2.a
    
from electric_abons
LEFT JOIN 
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t0,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t1,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t2,
sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t3,
z1.ktn, z1.ktt, z1.a 
                        FROM
                        (SELECT daily_values.date as daily_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        daily_values.value as value_daily, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources			
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = daily_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and
                        Objects.name= '%s' 
                        and            
                        daily_values.date = '%s'
                        ) z1                      
group by z1.name_objects, z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktn, z1.ktt, z1.a 
) z2
on electric_abons.ab_name=z2.name_abonents
where  electric_abons.obj_name= '%s' 
   
ORDER BY electric_abons.ab_name ASC) as z 
group by obj_name"""%(electric_data_end,my_params[0],my_params[1],my_params[2],my_params[3],my_params[4],obj_title,electric_data_end,obj_title)
    #print sQuery
    return sQuery 
    
def get_electric_count(obj_title, electric_data_end):
    my_params=['T0 A+','T1 A+','T2 A+','T3 A+','Электричество']   
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_electric_count( obj_title,  electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table
    
def get_res_objects(res): 
    cursor = connection.cursor()
    data_table=[]     
    sQuery=""" SELECT  obj_name
                       FROM %s_abons
                        group by obj_name   
                        order by obj_name ASC
                        """%(res)
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def MakeSqlQuery_heat_no_data( obj_title, electric_data_end, my_params):
    sQuery="""
    Select heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual, 
round(z2.energy::numeric,7),
round(z2.volume::numeric,7),
round(z2.t_in::numeric,1),
round(z2.t_out::numeric,1), heat_abons.name
from heat_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out, res
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type,
            			  resources.name as res
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters,
            			  resources
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  names_params.guid_resources=resources.guid and
            			  objects.name = '%s' AND            			  
            			  resources.name = '%s' AND 
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual, z1.res
            order by z1.name_abonents) as z2
on z2.number_manual=heat_abons.factory_number_manual
where heat_abons.obj_name='%s'
and (z2.energy is null or z2.volume is null)
order by heat_abons.obj_name, heat_abons.ab_name
    """%(my_params[0],my_params[1],my_params[2],my_params[3], obj_title,my_params[4],electric_data_end, obj_title)
    return sQuery    
def get_heat_no_data(obj_title,  electric_data_end):
    my_params=['Энергия','Объем','Ti','To', 'Тепло']   
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_heat_no_data( obj_title, electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table
 
def MakeSqlQuery_heat_count( obj_title, electric_data_end, my_params):
    sQuery="""
    Select obj_name, Count(z.energy), Count(z.ab_name), round((count(energy)*100/count(ab_name))::numeric,0) as percent_val, 
    (count (ab_name)-count (energy)) as no_val, '%s'
from
(Select heat_abons.obj_name, heat_abons.ab_name, heat_abons.factory_number_manual, 
round(z2.energy::numeric,7) as energy,
round(z2.volume::numeric,7) as volume,
round(z2.t_in::numeric,1),
round(z2.t_out::numeric,1), heat_abons.name
from heat_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as energy,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as volume,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_in,
            sum(Case when z1.params_name = '%s' then z1.value_daily  end) as t_out, res
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type,
            			  resources.name as res
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters,
            			  resources
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  names_params.guid_resources=resources.guid and
            			  objects.name = '%s' AND            			  
            			  resources.name = '%s' AND 
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual, z1.res
            order by z1.name_abonents) as z2
on z2.number_manual=heat_abons.factory_number_manual
where heat_abons.obj_name='%s'
order by heat_abons.ab_name) as z
group by obj_name
    """%(electric_data_end,my_params[0],my_params[1],my_params[2],my_params[3], obj_title,my_params[4],electric_data_end, obj_title)
    return sQuery
def get_heat_count(obj_title,  electric_data_end):
    my_params=['Энергия','Объем','Ti','To', 'Тепло']   
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_heat_count( obj_title, electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table
    
def get_water_impulse_objects(): 
    cursor = connection.cursor()
    data_table=[]     
    sQuery=""" SELECT  name
                       FROM water_abons_report
                        group by name   
                        order by name ASC
                        """
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table
    
    
def MakeSqlQuery_water_impulse_no_data( obj_title, electric_data_end, my_params):
    sQuery="""
    Select water_abons_report.name as obj_name, obj_name as ab_name, water_abons_report.ab_name as meter_name,   water_abons_report.meter_name, water_abons_report.channel, z2.value 
from water_abons_report

LEFT JOIN (
SELECT 
  daily_values.date,
  obj_name as ab_name,
  abonents.name as meters,
  meters.name as meter_name,  
  names_params.name as name_params,
  daily_values.value,    
  abonents.guid,
  water_abons_report.name,
  resources.name as res
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s' and
  water_abons_report.name='%s'
  order by obj_name, names_params.name ) z2
  on z2.meters=water_abons_report.ab_name
  where water_abons_report.name='%s'  
  and value is null
  order by obj_name, z2.name_params
    """%(my_params[0],electric_data_end,obj_title,obj_title)
    return sQuery 
     
def get_water_impulse_no_data(obj_title,  electric_data_end):
    my_params=['Импульс']   
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_water_impulse_no_data( obj_title, electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table
    
def MakeSqlQuery_water_impulse_count( obj_title, electric_data_end, my_params):
    sQuery="""
    Select obj_name, Count(z.value), Count(z.ab_name), round((count(value)*100/count(ab_name))::numeric,0) as percent_val, 
    (count (ab_name)-count (value)) as no_val, '%s'
from
(
Select water_abons_report.name as obj_name, obj_name as ab_name, water_abons_report.ab_name as meter_name,  z2.meter_name, z2.name_params, z2.value 
from water_abons_report

LEFT JOIN (
SELECT 
  daily_values.date,
  obj_name as ab_name,
  abonents.name as meters,
  meters.name as meter_name,  
  names_params.name as name_params,
  daily_values.value,    
  abonents.guid,
  water_abons_report.name,
  resources.name as res
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.abonents, 
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources
WHERE 
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s' and
  water_abons_report.name='%s'
  order by obj_name, names_params.name ) z2
  on z2.meters=water_abons_report.ab_name
  where water_abons_report.name='%s'  
  order by obj_name, z2.name_params) z
  group by obj_name
    """%(electric_data_end,my_params[0],electric_data_end,obj_title,obj_title)
    return sQuery    
    
def get_water_impulse_count(obj_title,  electric_data_end):
    my_params=['Импульс']   
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_water_impulse_count( obj_title, electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table

def MakeSqlQuery_water_impulse_balnce_period( obj_title,electric_data_start,  electric_data_end, my_params):
    sQuery="""
    Select c_date,bal_name, res_name, water_minus,water_plus,delta_water_minus,delta_water_plus, 
    delta_water_plus-delta_water_minus as nebalans, round(((( delta_water_plus-delta_water_minus ) *100)/delta_water_plus)::numeric,0) as percent,
answer
from
(
Select z3.c_date,z3.bal_name, z3.res_name, z3.water_minus,z3.water_plus,
round((z3.water_minus-lag(water_minus)over (order by c_date))::numeric,3)  as delta_water_minus,
round((z3.water_plus-lag(water_plus)over (order by c_date))::numeric,3)  as delta_water_plus,
z3.answer
from
(Select z_date.c_date,z1.bal_name, z1.res_name, z1.water_plus,z1.water_minus, z1.answer
from
(select c_date::date
from
generate_series('%s'::timestamp without time zone, '%s'::timestamp without time zone, interval '1 day') as c_date) z_date
left join
(
SELECT
  daily_values.date, 
    resources.name as res_name,
    balance_groups.name as bal_name,
  sum(Case when  link_balance_groups_meters.type=False then daily_values.value end) as water_minus,
  sum(Case when  link_balance_groups_meters.type=True then daily_values.value end) as water_plus,
  count(water_abons_report.name) as answer
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  water_abons_report,
  params,
  names_params,
  resources,
  link_balance_groups_meters,
  balance_groups
WHERE
  link_balance_groups_meters.guid_meters=meters.guid and
  link_balance_groups_meters.guid_balance_groups=balance_groups.guid and
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  water_abons_report.ab_name=abonents.name and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  AND
  daily_values.date between '%s' and '%s'
  and balance_groups.name='%s'
  group by  
 
  daily_values.date,  
balance_groups.name,
  resources.name) z1
  on z1.date=z_date.c_date
  order by z_date.c_date) z3
  ) as z4    """%(  electric_data_start, electric_data_end, my_params[0], electric_data_start, electric_data_end,  obj_title) 
    #print sQuery    
    return sQuery  
    
    
def get_data_table_balance_water_impulse_perid(obj_parent_title, obj_title,electric_data_start, electric_data_end):
    my_params=['Импульс']   
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeSqlQuery_water_impulse_balnce_period( obj_title, electric_data_start, electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table

def get_date_month_range_by_date(electric_date_end):
    cursor = connection.cursor()
    data_table=[] 
    sQuery="""
    SELECT date_trunc('day', dd)::date::text
    FROM generate_series
        ( (date_trunc('month', '%s'::timestamp))::timestamp 
        , (date_trunc('day', date_trunc('month', '%s'::TIMESTAMP) +'1 month' - '1 hour'::INTERVAL))::timestamp
        , '1 day'::interval) dd
    """%(electric_date_end, electric_date_end) 
    #print sQuery    
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()      
    return data_table

def MakeQuery_electric_period_c300(obj_parent_title, obj_title ,electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select row_number() over(ORDER BY z_start.account_1, z_start.type_energo) num, 
z_start.account_1::numeric::text,
z_start.type_energo, 
''::text,
''::text,
''::text,
z_start.factory_number_manual, 
z_start.type_energo2, 
(case when z_start.value_daily > 0 then z_start.value_daily::text else '-' end), 
(case when z_end.value_daily > 0 then z_end.value_daily::text   else '-' end), 
(case when z_end.value_daily > 0 and z_start.value_daily > 0 then round((z_end.value_daily-z_start.value_daily)::numeric, 3)::text else '-' end)

from
(Select account_1, type_energo,  
    electric_abons_report_for_botsad.factory_number_manual, type_energo2,
    name_params, value_daily,
    ktt,ktn, electric_abons_report_for_botsad.obj_name, electric_abons_report_for_botsad.ab_name
from electric_abons_report_for_botsad
LEFT JOIN
(SELECT daily_values.date as daily_date,
                        objects.name as name_objects,
                        abonents.name as name_abonents,
                        meters.factory_number_manual as number_manual,
                        daily_values.value as value_daily,
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values,
                         public.link_abonents_taken_params,
                         public.taken_params,
                         public.abonents,
                         public.objects,
                         public.names_params,
                         public.params,
                         public.meters,
                         public.types_meters,
                         public.resources
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                        taken_params.id = daily_values.id_taken_params AND
                        taken_params.guid_params = params.guid AND
                        taken_params.guid_meters = meters.guid AND
                        abonents.guid = link_abonents_taken_params.guid_abonents AND
                        objects.guid = abonents.guid_objects AND
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and                        
                        objects.name = '%s' AND
                        daily_values.date ='%s' 
                        and names_params.name!='T0 A+'
                        
) z2
on z2.number_manual=electric_abons_report_for_botsad.factory_number_manual and electric_abons_report_for_botsad.name_params=z2.params_name
where 
 electric_abons_report_for_botsad.obj_name='%s'  
 ) z_start,

(Select account_1, type_energo,  
    electric_abons_report_for_botsad.factory_number_manual, type_energo2,
    name_params, value_daily,
    ktt,ktn, electric_abons_report_for_botsad.obj_name, electric_abons_report_for_botsad.ab_name
from electric_abons_report_for_botsad
LEFT JOIN
(SELECT daily_values.date as daily_date,
                        objects.name as name_objects,
                        abonents.name as name_abonents,
                        meters.factory_number_manual as number_manual,
                        daily_values.value as value_daily,
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.daily_values,
                         public.link_abonents_taken_params,
                         public.taken_params,
                         public.abonents,
                         public.objects,
                         public.names_params,
                         public.params,
                         public.meters,
                         public.types_meters,
                         public.resources
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND
                        taken_params.id = daily_values.id_taken_params AND
                        taken_params.guid_params = params.guid AND
                        taken_params.guid_meters = meters.guid AND
                        abonents.guid = link_abonents_taken_params.guid_abonents AND
                        objects.guid = abonents.guid_objects AND
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='%s' and                        
                        objects.name = '%s' AND
                        daily_values.date ='%s' 
                        and names_params.name!='T0 A+'                        
) z2
on z2.number_manual=electric_abons_report_for_botsad.factory_number_manual and electric_abons_report_for_botsad.name_params=z2.params_name
where 
 electric_abons_report_for_botsad.obj_name='%s'  
 ) z_end
where z_start.factory_number_manual=z_end.factory_number_manual and z_start.type_energo=z_end.type_energo
 order by num, z_start.account_1, z_start.type_energo2
    """%( my_params[0],obj_title ,electric_data_start, obj_title, my_params[0],obj_title ,electric_data_end,obj_title )
    return sQuery

def get_data_table_electric_period_c300(obj_parent_title, obj_title ,electric_data_start, electric_data_end):
    my_params=[u'Электричество',]
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeQuery_electric_period_c300(obj_parent_title, obj_title ,electric_data_start, electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table

def MakeQuery_80020_statistic(group_name,electric_data_start,electric_data_end, my_params):
    sQuery="""
    Select z_info.name_sender, 
                         z_info.inn_sender, 
                         z_info.dogovor_number, 
                         z_info.factory_number_manual, 
                         z_info.measuringpoint_name, 
                         z_info.measuringpoint_code, 
                         z_info.dt_last_read,
                         z_info.val_start,
                         z_info.val_end,
                         z_info.delta,
                         round(z_count.sum_30::numeric,2),
                         z_count.percent
from
(Select z_start.name_sender, 
                         z_start.inn_sender, 
                         z_start.dogovor_number, 
                         z_start.factory_number_manual, 
                         z_start.measuringpoint_name, 
                          z_start.measuringpoint_code, 
                          z_start.dt_last_read,
                          z_start.value as val_start,
                          z_end.value as val_end,
                          round((z_end.value-z_start.value)::numeric,2) as delta
from
(Select report_80020.name_sender, 
                         report_80020.inn_sender, 
                          report_80020.dogovor_number, 
                         report_80020.factory_number_manual, 
                         report_80020.measuringpoint_name, 
                          report_80020.measuringpoint_code, 
                          report_80020.dt_last_read,
                          z1.value
from
report_80020
Left Join
(SELECT 
  meters.name, 
  meters.factory_number_manual, 
  daily_values.date, 
  daily_values.value, 
  groups_80020.name, 
  names_params.name
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.groups_80020, 
  public.link_groups_80020_meters, 
  public.params, 
  public.names_params
WHERE 
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  params.guid_names_params = names_params.guid AND
  daily_values.date = '%s' AND 
  names_params.name = '%s'
   and groups_80020.name='%s'
   group by 
  meters.name,
  meters.factory_number_manual,
  daily_values.date,
  daily_values.value,
  groups_80020.name,
  names_params.name) z1
on z1.factory_number_manual=report_80020.factory_number_manual
where report_80020.group_name='%s'
 ) z_start,

(Select report_80020.name_sender, 
                         report_80020.inn_sender, 
                          report_80020.dogovor_number, 
                         report_80020.factory_number_manual, 
                         report_80020.measuringpoint_name, 
                          report_80020.measuringpoint_code, 
                          report_80020.dt_last_read,
                          z1.value 
from
report_80020
Left Join
(SELECT 
  meters.name, 
  meters.factory_number_manual, 
  daily_values.date, 
  daily_values.value, 
  groups_80020.name, 
  names_params.name
FROM 
  public.meters, 
  public.taken_params, 
  public.daily_values, 
  public.groups_80020, 
  public.link_groups_80020_meters, 
  public.params, 
  public.names_params
WHERE 
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  params.guid_names_params = names_params.guid AND
  daily_values.date = '%s' AND 
  names_params.name = '%s'
   and groups_80020.name='%s'
   group by 
  meters.name,
  meters.factory_number_manual,
  daily_values.date,
  daily_values.value,
  groups_80020.name,
  names_params.name) z1
on z1.factory_number_manual=report_80020.factory_number_manual
where report_80020.group_name='%s'
 ) z_end
where z_start.factory_number_manual=z_end.factory_number_manual
group by z_start.name_sender,
                         z_start.inn_sender,
                         z_start.dogovor_number,
                         z_start.factory_number_manual,
                         z_start.measuringpoint_name,
                          z_start.measuringpoint_code,
                          z_start.dt_last_read,
                          z_start.value,
                          z_end.value ) z_info
left join
(Select 
sum(z.summa) as sum_30 ,
z.factory_number_manual,
round( (
        100 -((((SELECT count(dd)
          FROM generate_series
        ( '%s'::timestamp 
        , '%s'::timestamp
        , '1 day'::interval) dd) *48)-sum(z.count_48))/((SELECT count(dd)
          FROM generate_series
        ( '%s'::timestamp 
        , '%s'::timestamp
        , '1 day'::interval) dd) *48)) *100)::numeric,1) as percent
from
(SELECT 
  names_params.name, 
  various_values.date, 
  sum (various_values.value) as summa, 
  count(meters.factory_number_manual) as count_48,
  meters.factory_number_manual, 
  groups_80020.name
FROM 
  public.meters, 
  public.groups_80020, 
  public.link_groups_80020_meters, 
  public.taken_params, 
  public.various_values, 
  public.params, 
  public.names_params
WHERE 
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  various_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  names_params.name = '%s' AND 
  various_values.date BETWEEN '%s' and '%s'
  and groups_80020.name='%s'
  group by names_params.name, 
  various_values.date,  
  meters.factory_number_manual, 
  groups_80020.name 
  order by factory_number_manual, date ) z
  group by z.factory_number_manual
) z_count
on z_count.factory_number_manual=z_info.factory_number_manual
    """%(electric_data_start, my_params[0],group_name, group_name, electric_data_end, my_params[0], group_name,group_name, electric_data_start,electric_data_end,
    electric_data_start,electric_data_end,my_params[1],electric_data_start,electric_data_end, group_name)
    #print sQuery
    return sQuery

def get_80020_statistic(group_name,electric_data_start,electric_data_end):
    my_params=[u'T0 A+',u'A+ Профиль']
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeQuery_80020_statistic(group_name,electric_data_start,electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table

def get_header_taken_params(group_name):
    sQuery="""
    SELECT 
  meters.factory_number_manual, 
  names_params.name
FROM 
  public.groups_80020, 
  public.meters, 
  public.types_meters, 
  public.names_params, 
  public.params, 
  public.link_groups_80020_meters
WHERE 
  meters.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  params.guid_types_meters = types_meters.guid AND
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  (names_params.name = '%s' OR 
  names_params.name = '%s')
  and groups_80020.name='%s'
group by   meters.factory_number_manual, 
  names_params.name,
  measuringpoint_name
  order by measuringpoint_name
    """%('T0 A+',u'T0 R+', group_name)
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()      
    return data_table

def get_A_R_energy_by_factory_number_period(factory_number_manual,electric_data_start,electric_data_end, name_param):
    if name_param == 'T0 R+':
        name_param = 'R+ Профиль'
    else:
        name_param = 'A+ Профиль'

    sQuery="""
    Select dd::date,
(case when count_48>0 then count_48 else 0 end)
FROM generate_series
        ( '%s'::timestamp
        , '%s'::timestamp
        , '1 day'::interval) dd
        left join
        (
SELECT
  names_params.name as name_param,
  various_values.date,
  count(meters.factory_number_manual) as count_48,
  meters.factory_number_manual
FROM
  public.meters,
  public.groups_80020,
  public.link_groups_80020_meters,
  public.taken_params,
  public.various_values,
  public.params,
  public.names_params
WHERE
  link_groups_80020_meters.guid_groups_80020 = groups_80020.guid AND
  link_groups_80020_meters.guid_meters = meters.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  various_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  factory_number_manual='%s' and
  various_values.date BETWEEN '%s' and '%s'
  and names_params.name = '%s'

  group by names_params.name,
  various_values.date,
  meters.factory_number_manual,
  groups_80020.name
  order by factory_number_manual, date) z
  on z.date=dd
  group by dd,
  factory_number_manual,
  count_48
  order by  dd
    """%(electric_data_start,electric_data_end,factory_number_manual,electric_data_start,electric_data_end, name_param)
   
    #print sQuery
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()      
    return data_table

def MakeQuery_water_period_c300(obj_parent_title, obj_title ,electric_data_start, electric_data_end, my_params):
    sQuery="""
    Select row_number() over(ORDER BY ab_name) num, 
substring(ab_name from 10)::int,
(case when type_energo='Горячее водоснабжение' then 'ГВС' else 'ХВС' end),
''::text,
''::text,
''::text,
substring(meter_name from (position('№' in meter_name)+1)::int ),
(case when type_energo='Горячее водоснабжение' then 'fhw' else 'fcw' end),
(case when val_start > 0 then val_start::text else '-' end) as val_start, 
(case when val_end > 0 then val_end::text   else '-' end) as val_end, 
(case when val_end > 0 and val_start > 0 then round((val_end-val_start)::numeric, 3)::text else '-' end) as delta 
from
(
Select z_st.ab_name, z_st.account_2,z_st.date, z_st.meter_name,z_st.type_energo, round(z_st.value::numeric,3) as val_start, round(z_end.value::numeric,3) as val_end, z_st.date_install, z_end.date
from 
(Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s'
order by account_2, obj_name) z_st,
(
Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='%s'
  and date='%s'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s'
order by account_2, obj_name) z_end
where z_st.meter_name=z_end.meter_name
and z_st.ab_name like '%%Квартира%%'
) z
order by ab_name
    """%(my_params[0],electric_data_start,obj_title, my_params[0], electric_data_end, obj_title)
    #print sQuery
    return sQuery
def get_data_table_water_period_c300(obj_parent_title, obj_title ,electric_data_start, electric_data_end,):
    my_params=[u'Импульс']
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeQuery_water_period_c300(obj_parent_title, obj_title ,electric_data_start, electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table


def update_table_with_replace(table, update_field, where_field, where_value, old_value, new_value):
  cursor = connection.cursor()
  sQuery="""
  UPDATE %s
   SET %s=replace(%s, '%s', '%s')
 WHERE %s='%s'
  """%(table, update_field, update_field, old_value, new_value, where_field, where_value)
  #print sQuery
  #print '_________________________________'
  cursor.execute(sQuery)
  #connection.commit()
  cursor.close()
def MakeQuery_water_digital_pulsar_statistic(obj,  electric_data_end, my_params):
  sQuery="""
  Select obj_name, Count(z.volume), Count(z.ab_name), round((count(volume)*100/count(ab_name))::numeric,2) as percent_val, (count (ab_name)-count (volume)) as no_val
from
(Select water_pulsar_abons.obj_name, water_pulsar_abons.ab_name, water_pulsar_abons.factory_number_manual, 
round(z2.value_daily::numeric,3) as volume, water_pulsar_abons.name
from water_pulsar_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.value_daily
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type,
            			  resources.name as res
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters,
            			  resources
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  names_params.guid_resources=resources.guid and
            			  objects.name = '%s' AND            			  
            			  (types_meters.name::text = '%s'::text OR types_meters.name::text = '%s'::text)
            			  AND
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual, z1.res, z1.value_daily
            order by z1.name_abonents) as z2
on z2.number_manual=water_pulsar_abons.factory_number_manual
where water_pulsar_abons.obj_name='%s'
order by water_pulsar_abons.ab_name) as z
group by obj_name
  """%(obj, my_params[0],my_params[1], electric_data_end, obj)
  #print sQuery
  return sQuery
def get_water_digital_pulsar_count(obj,  electric_data_end):
    my_params=[u'Пульсар ГВС', u'Пульсар ХВС']
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeQuery_water_digital_pulsar_statistic(obj,  electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table

def MakeQuery_water_digital_pulsar_no_data(obj,  electric_data_end, my_params):
  sQuery="""
  Select water_pulsar_abons.obj_name, water_pulsar_abons.ab_name, water_pulsar_abons.factory_number_manual, 
round(z2.value_daily::numeric,3) as volume, water_pulsar_abons.name
from water_pulsar_abons
left join
(SELECT z1.daily_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.value_daily
            
                                    FROM
                                    (SELECT 
            			  daily_values.date as daily_date, 
            			  objects.name as name_objects, 
            			  abonents.name as name_abonents, 
            			  daily_values.value as value_daily, 
            			  meters.factory_number_manual as number_manual, 
            			  names_params.name as params_name, 
            			  types_meters.name as meter_type,
            			  resources.name as res
            			FROM 
            			  public.daily_values, 
            			  public.taken_params, 
            			  public.abonents, 
            			  public.link_abonents_taken_params, 
            			  public.objects, 
            			  public.params, 
            			  public.names_params, 
            			  public.meters, 
            			  public.types_meters,
            			  resources
            			WHERE 
            			  daily_values.id_taken_params = taken_params.id AND
            			  taken_params.guid_params = params.guid AND
            			  taken_params.guid_meters = meters.guid AND
            			  abonents.guid_objects = objects.guid AND
            			  link_abonents_taken_params.guid_abonents = abonents.guid AND
            			  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
            			  params.guid_names_params = names_params.guid AND
            			  meters.guid_types_meters = types_meters.guid AND
            			  names_params.guid_resources=resources.guid and
            			  objects.name = '%s' AND            			  
            			  (types_meters.name::text = '%s'::text OR types_meters.name::text = '%s'::text)
            			  AND
            			  daily_values.date = '%s' 
                                    ) z1
            group by z1.name_abonents, z1.daily_date, z1.name_objects, z1.number_manual, z1.res, z1.value_daily
            order by z1.name_abonents) as z2
on z2.number_manual=water_pulsar_abons.factory_number_manual
where water_pulsar_abons.obj_name='%s'
  and value_daily is null
  order by obj_name, water_pulsar_abons.ab_name
  """%(obj, my_params[0],my_params[1], electric_data_end, obj)
  #print sQuery
  return sQuery

def get_water_digital_pulsar_no_data(obj,  electric_data_end):
    my_params=[u'Пульсар ГВС', u'Пульсар ХВС']
    cursor = connection.cursor()
    data_table=[]      
    cursor.execute(MakeQuery_water_digital_pulsar_no_data(obj,  electric_data_end, my_params))  
    data_table = cursor.fetchall()      
    return data_table

def get_water_digital_pulsar_objects(): 
    cursor = connection.cursor()
    data_table=[]     
    sQuery=""" SELECT  obj_name
                       FROM water_pulsar_abons
                        group by obj_name   
                        order by obj_name ASC
                        """
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_abons_by_object_guid_and_res(obj_guid, res):
    cursor = connection.cursor()
    data_table=[]  
    #res='Электричество'  
    sQuery=""" SELECT   
  abonents.name,
  abonents.guid
FROM 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.objects
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  resources.name = '%s' AND
  objects.guid = '%s'
    group by 
  abonents.name,  abonents.guid
  order by abonents.name
                        """ %(res, obj_guid)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_meters_by_abons_guid_and_res(abon_guid, res):
    cursor = connection.cursor()
    data_table=[]  
    if res == 'ХВС':
        condition =  "(resources.name = 'ХВС' or resources.name = 'ГВС')"
    
    else: condition =  "(resources.name = '%s')"%res

    # if res == 'ХВС':
    #     condition =  "(resources.name = 'ХВС' or resources.name = 'ГВС')"
    # elif res == 'Импульс':
    #   condition =  "resources.name = 'Импульс'"
    # else: return data_table

    sQuery="""SELECT   
  abonents.name,
  meters.name,
  meters.factory_number_manual  
FROM 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.params, 
  public.names_params, 
  public.resources,   
  public.meters
WHERE 
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  taken_params.guid_meters = meters.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  %s AND
  abonents.guid = '%s'
    group by 
  abonents.name,
  meters.name,
  meters.factory_number_manual
  order by abonents.name""" %(condition, abon_guid)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_balance_groups_by_res(res_name):
    cursor = connection.cursor()
    data_table=[]  
 
    sQuery="""
    SELECT 
  balance_groups.name, 
  resources.name
FROM 
  public.balance_groups, 
  public.link_balance_groups_meters, 
  public.meters, 
  public.types_meters, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  link_balance_groups_meters.guid_balance_groups = balance_groups.guid AND
  link_balance_groups_meters.guid_meters = meters.guid AND
  meters.guid_types_meters = types_meters.guid AND
  params.guid_types_meters = types_meters.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  resources.name = '%s'
  group by   balance_groups.name, 
  resources.name
  order by   balance_groups.name
    """ %(res_name)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_water_abonents_by_obj_guid(obj_guid, name_res):
    cursor = connection.cursor()
    data_table=[]  
 
    sQuery="""
    Select name, guid, res_name
from
(SELECT 
  abonents.name, 
  abonents.guid,
  (case when resources.name = '%s' or resources.name = '%s' then 'ХВС' else 'Импульс' end) as res_name   
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  (resources.name = '%s' or resources.name = '%s' or resources.name = '%s') 
  and
  objects.guid = '%s'
  group by  abonents.name, 
  abonents.guid, 
  resources.name) z1
  
  group by name, guid, res_name
  order by name
    """ %( name_res[0], name_res[1], name_res[0], name_res[1], name_res[2], obj_guid)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()

    return data_table
  
def get_meters_by_type( type_name):
    cursor = connection.cursor()
    data_table=[]   
    sQuery="""
SELECT 
  meters.guid,
  meters.name
FROM 
  public.meters, 
  public.types_meters
WHERE 
  meters.guid_types_meters = types_meters.guid and
  (types_meters.name ='%s')
   and meters.name !='A'
order by meters.name
    """ %(type_name)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_restored_activ_reactiv(obj_title, obj_parent_title, date_st,activ,reactiv,date2, date_end):
    #дата с которой есть данные - показания аткивнки - показания реактивки - дата до которой нужны показания
    cursor = connection.cursor()
    data_table=[]   
    sQuery="""
Select '%s','%s', z.obj_name, z.ab_name, z.factory_number_manual,
%s+sum(z.sum_30_t0) as sum_t0,
%s+sum(z.sum_30_tr0) as sum_tr0
from 

(SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name, 
  various_values.date, 
 meters.factory_number_manual,
  sum(Case when names_params.name = 'A+ Профиль' then various_values.value  end) as sum_30_t0,
  sum(Case when names_params.name = 'R+ Профиль' then various_values.value end) as sum_30_tr0
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.various_values, 
  public.params,
  public.names_params,
  public.meters
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.guid_params = params.guid AND
  various_values.id_taken_params = taken_params.id AND
  names_params.guid = params.guid_names_params AND 
   taken_params.guid_meters = meters.guid AND 
  various_values.date between '%s' and '%s' and
                        abonents.name = '%s' AND 
                        objects.name = '%s' 
  
  group by objects.name, 
  abonents.name,  
  various_values.date,
  factory_number_manual
  order by date
  ) z
group by z.obj_name, z.ab_name, z.factory_number_manual
    """ %(date_end,date_end, activ, reactiv, date_st, date2, obj_title, obj_parent_title)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_dt_monthly_activ_reactiv(obj_title, obj_parent_title, date_end):
    #дата с которой есть данные - показания аткивнки - показания реактивки - дата до которой нужны показания
    cursor = connection.cursor()
    data_table=[]   
    sQuery="""
SELECT z1.monthly_date, z1.name_objects, z1.name_abonents, z1.number_manual, 
sum(Case when z1.params_name = 'T0 A+' then z1.value_monthly  end) as t0,
sum(Case when z1.params_name = 'T0 R+' then z1.value_monthly  end) as tr0,

z1.ktn, z1.ktt, z1.a 
                        FROM
                        (SELECT monthly_values.date as monthly_date, 
                        objects.name as name_objects, 
                        abonents.name as name_abonents, 
                        meters.factory_number_manual as number_manual, 
                        monthly_values.value as value_monthly, 
                        names_params.name as params_name,
                        link_abonents_taken_params.coefficient as ktt,
                         link_abonents_taken_params.coefficient_2 as ktn,
                          link_abonents_taken_params.coefficient_3 as a
                        FROM
                         public.monthly_values, 
                         public.link_abonents_taken_params, 
                         public.taken_params, 
                         public.abonents, 
                         public.objects, 
                         public.names_params, 
                         public.params, 
                         public.meters,
                         public.types_meters,
                         public.resources			
                        WHERE
                        taken_params.guid = link_abonents_taken_params.guid_taken_params AND 
                        taken_params.id = monthly_values.id_taken_params AND 
                        taken_params.guid_params = params.guid AND 
                        taken_params.guid_meters = meters.guid AND 
                        abonents.guid = link_abonents_taken_params.guid_abonents AND 
                        objects.guid = abonents.guid_objects AND 
                        names_params.guid = params.guid_names_params AND
                        params.guid_names_params=names_params.guid and 
                        types_meters.guid=meters.guid_types_meters and
                        names_params.guid_resources=resources.guid and
                        resources.name='Электричество' and
                        abonents.name = '%s' AND 
                        objects.name = '%s' AND                      
                        monthly_values.date = '%s'
                        ) z1                      
group by z1.name_objects, z1.monthly_date, z1.name_objects, z1.name_abonents, z1.number_manual, z1.ktn, z1.ktt, z1.a
    """ %( obj_title, obj_parent_title, date_end)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_link_abonents_taken_params_by_meter_guid(guid_meter):
    cursor = connection.cursor()
    data_table=[]   
    sQuery="""
     SELECT 
  abonents.guid, 
  abonents.name, 
  link_abonents_taken_params.guid, 
  link_abonents_taken_params.name,  
  meters.guid, 
  meters.name,  
  taken_params.guid,
  taken_params.name
FROM 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters
WHERE 
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  meters.guid = taken_params.guid_meters AND
  meters.guid = '%s'
    """ %(guid_meter)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_abonent_by_meter_and_pulsar_chanel(guid_meter, address):
    cursor = connection.cursor()
    data_table=[]   
    sQuery="""
    SELECT   
  abonents.guid, 
  abonents.name, 
  params.name, 
  params.param_address
FROM 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.types_meters, 
  public.params
WHERE 
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  meters.guid_types_meters = types_meters.guid AND
  meters.guid = '%s' and
  params.param_address = %s
ORDER BY
  meters.name ASC, 
  params.name ASC
    """ %(guid_meter, address)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def InsertInLinkAbonentsTakenParams(name, coefficient, guid_abonents, guid_taken_params, coefficient_2, coefficient_3):
    cursor = connection.cursor()
    sQuery="""
   INSERT INTO link_abonents_taken_params(
            guid, name, coefficient, guid_abonents, guid_taken_params, coefficient_2, coefficient_3)
    VALUES (uuid_in(md5(random()::text || clock_timestamp()::text)::cstring), '%s',%s, '%s', '%s',%s,%s)
    """ %(name, coefficient, guid_abonents, guid_taken_params, coefficient_2, coefficient_3)
    #print sQuery
    cursor.execute(sQuery)
    connection.commit() 
    
    return True  

def get_count_current_params_by_meters_guid(guid_meter):
    cursor = connection.cursor()
    data_table=[]   
    sQuery="""
   SELECT 
  Count(types_params.name), 
  types_meters.name
FROM 
  public.meters, 
  public.taken_params, 
  public.params, 
  public.types_params, 
  public.types_meters
WHERE 
  meters.guid_types_meters = types_meters.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_types_params = types_params.guid AND
  meters.guid = '%s' AND 
  types_params.name = 'Текущий'
  Group by types_meters.name
    """ %(guid_meter)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()    
    return data_table

def get_electric_30_by_abonent_for_period(obj_title, obj_parent_title,electric_data_start, electric_data_end, params):
    cursor = connection.cursor()
    data_table=[]   
    sQuery="""
   Select 
       meter_name,
       factory_number_manual,
       ktt,
       date,
       time,
       c_date,
       activ,
       reactiv,
       '30',
       (EXTRACT(EPOCH FROM c_date) * 1000)::text as utc,
       row_number() over(ORDER BY meter_name) num
from 
(select c_date
from
generate_series('%s 00:00:00'::timestamp without time zone, '%s 23:30:00'::timestamp without time zone, interval '30 minutes') as c_date) as z_date
Left join
(SELECT 
  objects.name as obj_name, 
  abonents.name as ab_name, 
  meters.name as meter_name, 
  meters.factory_number_manual, 
  link_abonents_taken_params.coefficient as ktt, 
  various_values.date, 
  various_values.time,   
  (various_values.date + various_values.time)::timestamp as date_time,
  SUM (CASE when names_params.name = '%s' then various_values.value else 0 end) as activ,
  SUM (CASE when names_params.name = '%s' then various_values.value else 0 end) as reactiv
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.various_values, 
  public.params, 
  public.names_params
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  various_values.id_taken_params = taken_params.id AND
  params.guid_names_params = names_params.guid AND
  various_values.date between '%s' and '%s' AND 
  abonents.name = '%s' AND 
  objects.name = '%s'
  group by 
  objects.name, 
  abonents.name, 
  meters.name, 
  meters.factory_number_manual, 
  link_abonents_taken_params.coefficient, 
  various_values.date, 
  various_values.time
  ORDER BY
  various_values.date ASC, 
  various_values.time ASC) z1
  on z1.date_time = z_date.c_date
    """ %(electric_data_start, electric_data_end,params[0], params[1], electric_data_start, electric_data_end, obj_title, obj_parent_title)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table

def get_electric_daily_by_user(id_user, date_end):
    cursor = connection.cursor()
    data_table=[]   
    sQuery="""
    WITH electic_info as
(
SELECT  
  resources.name as res_name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name as meters_name
FROM 
  public.abonents, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.auth_user, 
  public.params, 
  public.names_params, 
  public.resources
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND 
  resources.name = 'Электричество' AND  
  auth_user.id = %s
  group by resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name
)

Select electic_info.res_name, electic_info.username, electic_info.first_name, 
electic_info.last_name, electic_info.meters_name, date, 
round(t0::numeric,3),
round(t1::numeric,3),
round(t2::numeric,3),
round(t3::numeric,3)
From electic_info
LEFT JOIN
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name as meters_name, 
  daily_values.date, 
sum(Case when names_params.name = 'T0 A+' then value  end) as t0,
sum(Case when names_params.name = 'T1 A+' then value  end) as t1,
sum(Case when names_params.name = 'T2 A+' then value end) as t2,
sum(Case when names_params.name = 'T3 A+' then value  end) as t3
FROM 
  public.abonents, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.auth_user, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.daily_values
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Электричество' AND 
  daily_values.date = '%s' AND
  auth_user.id = %s
  group by resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name, 
  daily_values.date) as z
  ON z.meters_name = electic_info.meters_name
    """ %(id_user, date_end, id_user)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table



def MakeHeatQueryByUser(id_user, date_end, params):
    sQuery="""
    WITH heat_info as
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name  as meters_name
FROM 
  public.abonents, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.auth_user, 
  public.params, 
  public.names_params, 
  public.resources, 
  types_meters
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_types_meters = types_meters.guid  AND
  resources.name = 'Тепло' AND 
  auth_user.id = %s
  and types_meters.name = '%s'
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name
)

Select heat_info.username, heat_info.username, heat_info.first_name, heat_info.last_name, heat_info.meters_name, round(z.energy::numeric,2), round(z.volume::numeric,2), round(z.t_in::numeric,0), round(z.t_out::numeric,0)
From heat_info
Left JOIN
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name as meters_name, 
  daily_values.date, 

 sum(Case when names_params.name = '%s' then value  end) as energy,
            sum(Case when names_params.name = '%s' then value  end) as volume,
            sum(Case when names_params.name = '%s' then value  end) as t_in,
            sum(Case when names_params.name = '%s' then value  end) as t_out
FROM 
  public.abonents, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.auth_user, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.daily_values,
  types_meters
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.id_taken_params = taken_params.id AND 
  params.guid_types_meters = types_meters.guid  AND
  resources.name = 'Тепло' AND 
  daily_values.date = '%s' AND
  auth_user.id = %s
  and types_meters.name = '%s'
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name, 
  daily_values.date
) z
ON z.meters_name = heat_info.meters_name
    """ %( id_user, params[4],   params[0],params[1],params[2],params[3], date_end, id_user, params[4])
    #print sQuery
    return sQuery

def get_heat_daily_by_user_pulsar(id_user, date_end):
    params=[u'Энергия',u'Объем',u'Ti',u'To', u'Пульсар Теплосчётчик']
    cursor = connection.cursor()
    data_table=[] 
    #передаём 4 параметра и тип счётчика, возможно функция подойдёт под другие теплосчётчики 
    sQuery = MakeHeatQueryByUser(id_user, date_end, params)
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table

def get_heat_daily_by_user_Sayany(id_user, date_end):
    params=[u'Q Система1' ,u'M Система1',u'T Канал1',u'T Канал2',u'Sayany' ]
    cursor = connection.cursor()
    data_table=[] 
    sQuery = MakeHeatQueryByUser(id_user, date_end, params)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table

def get_heat_daily_by_user_Elf(id_user, date_end):
    #Используется стандартная функция, поэтому параметры энергия и объём дублируется вместо не поддерживаемых эльфами температруы вх и вых.
    params=[u'Энергия',u'Объем',u'Энергия',u'Объем', u'Эльф 1.08']
    cursor = connection.cursor()
    data_table=[] 
    sQuery = MakeHeatQueryByUser(id_user, date_end, params)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table
    
    
def get_heat_daily_by_user_Karat(id_user, date_end):
    params=[u'Q Система1', 'M Система1', 'Ti', 'To', u'Карат 307']
    cursor = connection.cursor()
    data_table=[] 
    sQuery = MakeHeatQueryByUser(id_user, date_end, params)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table

def get_heat_daily_by_user_Danfos(id_user, date_end):
    pass

def get_electric_period_by_user(id_user, date_start, date_end):
    pass

def get_heat_period_by_user_pulsar(id_user, date_start, date_end):
    pass

def MakeDigitalWaterQueryByUser(id_user, date_end, params):
    sQuery="""
  WITH water_info as
(
  SELECT
  resources.name as res_name,
  auth_user.username,
  auth_user.first_name,
  auth_user.last_name,
  meters.name as meters_name
  
FROM
  public.abonents,
  public.link_abonents_auth_user,
  public.link_abonents_taken_params,
  public.taken_params,
  public.meters,
  public.auth_user,
  public.params,
  public.names_params,
  public.resources, 
  types_meters
WHERE
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND 
  params.guid_types_meters = types_meters.guid  AND
  (resources.name = '%s' or resources.name = '%s')AND 
  auth_user.id = %s
  and (types_meters.name = '%s' or types_meters.name = '%s')
  group by  resources.name,
  auth_user.username,
  auth_user.first_name,
  auth_user.last_name,
  meters.name)

SELECT res_name, water_info.username, water_info.first_name, water_info.last_name, water_info.meters_name, date, value
From water_info
LEFT JOIN 
(
  SELECT
  resources.name,
  auth_user.username,
  auth_user.first_name,
  auth_user.last_name,
  meters.name as meters_name,
  daily_values.date,
   daily_values.value
FROM
  public.abonents,
  public.link_abonents_auth_user,
  public.link_abonents_taken_params,
  public.taken_params,
  public.meters,
  public.auth_user,
  public.params,
  public.names_params,
  public.resources,
  public.daily_values,
  types_meters
WHERE
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.id_taken_params = taken_params.id AND
  params.guid_types_meters = types_meters.guid  AND
  (resources.name = '%s' or resources.name = '%s')AND
  daily_values.date = '%s' AND
  auth_user.id = %s
  and (types_meters.name = '%s' or types_meters.name = '%s')
  group by  resources.name,
  auth_user.username,
  auth_user.first_name,
  auth_user.last_name,
  meters.name,
  daily_values.date,
  daily_values.value) as z
  ON z.meters_name = water_info.meters_name """%(params[0], params[1],id_user,params[2],params[3],   params[0], params[1], date_end,id_user,params[2],params[3])
    #print sQuery
    return sQuery

def get_water_digital_daily_by_user(id_user, date_end):
    params=[u'ХВС',u'ГВС', u'Пульсар ХВС', u'Пульсар ГВС']
    cursor = connection.cursor()
    data_table=[] 
    sQuery = MakeDigitalWaterQueryByUser(id_user, date_end, params)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table

def  MakeImpulseWaterQueryByUser(id_user, date_end, params):
    sQuery="""
    with water_info as
(SELECT  
  resources.name as res_name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name as ab_name
FROM 
  public.abonents, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.auth_user, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.daily_values,
  types_meters
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_types_meters = types_meters.guid  AND
  resources.name = '%s' AND   
  auth_user.id = %s
  and types_meters.name like '%s'
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name)

SELECT res_name, water_info.username, water_info.first_name, water_info.last_name, water_info.ab_name, date, value
From water_info
LEFT JOIN 
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name as ab_name,
  daily_values.date, 
   daily_values.value 
FROM 
  public.abonents, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.auth_user, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.daily_values,
  types_meters
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.id_taken_params = taken_params.id AND 
  params.guid_types_meters = types_meters.guid  AND
  resources.name = '%s' AND 
  daily_values.date = '%s' AND
  auth_user.id = %s
  and types_meters.name like '%s'
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name,
  daily_values.date,
  daily_values.value) as z
  ON z.ab_name = water_info.ab_name
   """%(params[0],id_user, params[1],     params[0],date_end,id_user, params[1])
    return sQuery

def get_water_impulse_daily_by_user(id_user, date_end):
    params=[u'Импульс', u'%Пульсар%']
    cursor = connection.cursor()
    data_table=[] 
    sQuery = MakeImpulseWaterQueryByUser(id_user, date_end, params)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table

def MakeElfWaterQueryByUser(id_user, date_end, params):
    sQuery="""
    WITH water_elf_info as (
SELECT 
  abonents.name as ab_name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.address, 
  meters.factory_number_manual,  
  types_meters.name as type_meter,
  CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter,
   CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res
FROM 
  public.abonents, 
  public.auth_user, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.types_meters,
  public.params
WHERE 
  taken_params.guid_params = params.guid AND
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  taken_params.guid_meters = meters.guid AND
  meters.guid_types_meters = types_meters.guid
  and (channel=1 or channel=2)
  and types_meters.name = '%s'
  and auth_user.id = %s
Group by abonents.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  meters.name, 
  meters.address, 
  meters.factory_number_manual, 
  meters.attr1, 
  meters.attr2, 
  types_meters.name,
  meters.attr2,
  meters.attr1,
  params.channel
)

Select water_elf_info.ab_name, water_elf_info.username, water_elf_info.first_name, water_elf_info.last_name,water_elf_info.meter, water_elf_info.type_res, z.value
From water_elf_info
LEFT JOIN 
(
SELECT  
  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
   CASE
            WHEN params.channel = 2 THEN meters.attr2
            WHEN params.channel = 1 Then meters.attr1
   END as meter,
   CASE
            WHEN params.channel = 2 THEN '%s'::text
            WHEN params.channel = 1 Then '%s'::text
   END as type_res,
  daily_values.date, 
  daily_values.value,
  abonents.name
  
FROM 
  public.abonents, 
  public.link_abonents_auth_user, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.auth_user, 
  public.params, 
  public.names_params, 
  public.resources, 
  public.daily_values,
  types_meters
WHERE 
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = auth_user.id AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  daily_values.id_taken_params = taken_params.id AND 
  params.guid_types_meters = types_meters.guid  AND
  daily_values.date = '%s' 
  and (channel=1 or channel=2)
  and types_meters.name = '%s'
  and auth_user.id = %s
  group by  resources.name, 
  auth_user.username, 
  auth_user.first_name, 
  auth_user.last_name, 
  abonents.name,
  daily_values.date,
  daily_values.value,
  types_meters.name,
  params.channel,
  meters.attr2,
  meters.attr1) z
  on z.meter = water_elf_info.meter"""%(params[0],params[1],params[2], id_user,params[0],params[1],date_end,params[2], id_user)
    #print sQuery
    return sQuery
def get_water_elf_daily_by_user(id_user, date_end):
    params=[u'ГВ', u'ХВ', u'Эльф 1.08']
    cursor = connection.cursor()
    data_table=[] 
    sQuery = MakeElfWaterQueryByUser(id_user, date_end, params)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table 

def MakeHeatDanfosQueryDaily_for_abon(obj_parent_title, obj_title, electric_data_end, params):
    sQuery = """
    Select obj_name, ab_name, heat_abons.factory_number_manual, 
    round(energy::numeric,3), 
    round(volume::numeric,3), 
    round(t_in::numeric,1), round(t_out::numeric,1)
from heat_abons
Left Join
(
SELECT 
objects.name,
abonents.name,
  resources.name,   
   
  meters.factory_number_manual, 
  sum(Case when names_params.name = '%s' then value  end) as energy,
            sum(Case when names_params.name = '%s' then value  end) as volume,
            sum(Case when names_params.name = '%s' then value  end) as t_in,
            sum(Case when names_params.name = '%s' then value  end) as t_out
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.names_params, 
  public.params, 
  public.meters, 
  public.daily_values
WHERE 
  objects.guid = abonents.guid_objects AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid = taken_params.guid_meters AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Тепло' 
  and date = '%s'  
  group by resources.name,   
  meters.name,   
  meters.factory_number_manual,
  objects.name,
  abonents.name) z
  on z.factory_number_manual = heat_abons.factory_number_manual
  where obj_name='%s'
  and ab_name = '%s'
  order by ab_name
    """%(params[0], params[1], params[2], params[3], electric_data_end,obj_parent_title, obj_title )
    return sQuery

def MakeHeatDanfosQueryDaily_for_obj(obj_parent_title, obj_title, electric_data_end, params):
    sQuery = """
    Select obj_name, ab_name, heat_abons.factory_number_manual, 
    round(energy::numeric,2), 
    round(volume::numeric,2), 
    round(t_in::numeric,1), 
    round(t_out::numeric,1)
from heat_abons
Left Join
(
SELECT 
objects.name,
abonents.name,
  resources.name,   
   
  meters.factory_number_manual, 
  sum(Case when names_params.name = '%s' then value  end) as energy,
            sum(Case when names_params.name = '%s' then value  end) as volume,
            sum(Case when names_params.name = '%s' then value  end) as t_in,
            sum(Case when names_params.name = '%s' then value  end) as t_out
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.names_params, 
  public.params, 
  public.meters, 
  public.daily_values
WHERE 
  objects.guid = abonents.guid_objects AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid = taken_params.guid_meters AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Тепло' 
  and date = '%s'  
  group by resources.name,   
  meters.name,   
  meters.factory_number_manual,
  objects.name,
  abonents.name) z
  on z.factory_number_manual = heat_abons.factory_number_manual
  where obj_name='%s'  
  order by ab_name
    """%(params[0], params[1], params[2], params[3], electric_data_end,obj_title)
    return sQuery

def get_data_table_heat_danfos_daily(obj_parent_title, obj_title, electric_data_end, isAbon,dc):
    params=[u'Энергия', u'Объем', u'Ti', u'To', u'Тепло']
    cursor = connection.cursor()
    data_table=[] 
    if isAbon:
        sQuery = MakeHeatDanfosQueryDaily_for_abon(obj_parent_title, obj_title, electric_data_end, params)
    else:
        sQuery = MakeHeatDanfosQueryDaily_for_obj(obj_parent_title, obj_title, electric_data_end, params)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    data_table = ChangeNull(data_table, None)
    return data_table 

def MakeHeatDanfosQueryPeriod_for_abon(obj_parent_title, obj_title,electric_data_start, electric_data_end, params):
    sQuery="""
     Select z_end.obj_name, z_end.ab_name, z_end.factory_number_manual, 
     round(z_start.energy::numeric,3),  
     round(z_end.energy::numeric,3), 
     round((z_end.energy- z_start.energy)::numeric,3) as delta_energy, 
     round(z_start.volume::numeric,3), 
     round(z_end.volume::numeric,3), round((z_end.volume-z_start.volume)::numeric,3) as delta_volume
FROM
(Select obj_name, ab_name, heat_abons.factory_number_manual, energy, volume, t_in, t_out
from heat_abons
Left Join
(
SELECT 
objects.name,
abonents.name,
  resources.name,   
   
  meters.factory_number_manual, 
  sum(Case when names_params.name = '%s' then value  end) as energy,
            sum(Case when names_params.name = '%s' then value  end) as volume,
            sum(Case when names_params.name = '%s' then value  end) as t_in,
            sum(Case when names_params.name = '%s' then value  end) as t_out
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.names_params, 
  public.params, 
  public.meters, 
  public.daily_values
WHERE 
  objects.guid = abonents.guid_objects AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid = taken_params.guid_meters AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Тепло'   
  and date = '%s'
  group by resources.name,   
  meters.name,   
  meters.factory_number_manual,
  objects.name,
  abonents.name) z
  on z.factory_number_manual = heat_abons.factory_number_manual
  where obj_name='%s'
  and ab_name = '%s'
  order by ab_name) z_end,
  (Select obj_name, ab_name, heat_abons.factory_number_manual, energy, volume, t_in, t_out
from heat_abons
Left Join
(
SELECT 
objects.name,
abonents.name,
  resources.name,   
   
  meters.factory_number_manual, 
  sum(Case when names_params.name = '%s' then value  end) as energy,
            sum(Case when names_params.name = '%s' then value  end) as volume,
            sum(Case when names_params.name = '%s' then value  end) as t_in,
            sum(Case when names_params.name = '%s' then value  end) as t_out
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.names_params, 
  public.params, 
  public.meters, 
  public.daily_values
WHERE 
  objects.guid = abonents.guid_objects AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid = taken_params.guid_meters AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Тепло'   
  and date = '%s'
  group by resources.name,   
  meters.name,   
  meters.factory_number_manual,
  objects.name,
  abonents.name) z
  on z.factory_number_manual = heat_abons.factory_number_manual
  where obj_name='%s'
  and ab_name = '%s'
  order by ab_name) z_start
  where z_end.factory_number_manual=z_start.factory_number_manual
    """%(params[0], params[1], params[2], params[3],electric_data_end, obj_parent_title,obj_title, params[0], params[1], params[2], params[3], electric_data_start,obj_parent_title, obj_title)
    return sQuery

def MakeHeatDanfosQueryPeriod_for_obj(obj_parent_title, obj_title,electric_data_start, electric_data_end, params):
    sQuery="""
    Select z_end.obj_name, z_end.ab_name, z_end.factory_number_manual, 
    round(z_start.energy::numeric,3),  
    round(z_end.energy::numeric,3), 
    round((z_end.energy- z_start.energy)::numeric,3) as delta_energy, 
    round(z_start.volume::numeric,3), round(z_end.volume::numeric,3), 
    round((z_end.volume-z_start.volume)::numeric,3) as delta_volume
FROM
(Select obj_name, ab_name, heat_abons.factory_number_manual, energy, volume, t_in, t_out
from heat_abons
Left Join
(
SELECT 
objects.name,
abonents.name,
  resources.name,   
   
  meters.factory_number_manual, 
  sum(Case when names_params.name = '%s' then value  end) as energy,
            sum(Case when names_params.name = '%s' then value  end) as volume,
            sum(Case when names_params.name = '%s' then value  end) as t_in,
            sum(Case when names_params.name = '%s' then value  end) as t_out
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.names_params, 
  public.params, 
  public.meters, 
  public.daily_values
WHERE 
  objects.guid = abonents.guid_objects AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid = taken_params.guid_meters AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Тепло'   
  and date = '%s'
  group by resources.name,   
  meters.name,   
  meters.factory_number_manual,
  objects.name,
  abonents.name) z
  on z.factory_number_manual = heat_abons.factory_number_manual
  where obj_name='%s'
  order by ab_name) z_end,
  (Select obj_name, ab_name, heat_abons.factory_number_manual, energy, volume, t_in, t_out
from heat_abons
Left Join
(
SELECT 
objects.name,
abonents.name,
  resources.name,   
   
  meters.factory_number_manual, 
  sum(Case when names_params.name = '%s' then value  end) as energy,
            sum(Case when names_params.name = '%s' then value  end) as volume,
            sum(Case when names_params.name = '%s' then value  end) as t_in,
            sum(Case when names_params.name = '%s' then value  end) as t_out
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.resources, 
  public.names_params, 
  public.params, 
  public.meters, 
  public.daily_values
WHERE 
  objects.guid = abonents.guid_objects AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_params = params.guid AND
  names_params.guid_resources = resources.guid AND
  params.guid_names_params = names_params.guid AND
  meters.guid = taken_params.guid_meters AND
  daily_values.id_taken_params = taken_params.id AND
  resources.name = 'Тепло'   
  and date = '%s'
  group by resources.name,   
  meters.name,   
  meters.factory_number_manual,
  objects.name,
  abonents.name) z
  on z.factory_number_manual = heat_abons.factory_number_manual
  where obj_name='%s'
  order by ab_name) z_start
  where z_end.factory_number_manual=z_start.factory_number_manual
  order by z_end.ab_name
    """%(params[0], params[1], params[2], params[3],electric_data_end, obj_title, params[0], params[1], params[2], params[3], electric_data_start,obj_title)
    return sQuery



def get_data_table_danfoss_period(obj_parent_title, obj_title, electric_data_start, electric_data_end, isAbon,dc):
    params=[u'Энергия', u'Объем', u'Ti', u'To', u'Тепло']
    cursor = connection.cursor()
    data_table=[] 
    if isAbon:
        sQuery = MakeHeatDanfosQueryPeriod_for_abon(obj_parent_title, obj_title, electric_data_start,electric_data_end, params)
    else:
        sQuery = MakeHeatDanfosQueryPeriod_for_obj(obj_parent_title, obj_title,electric_data_start, electric_data_end, params)
    #print sQuery
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    data_table = ChangeNull(data_table, None)
    return data_table 

def get_abonent_and_object_name_by_account(user_id):
    cursor = connection.cursor()
    data_table=[] 
    sQuery ="""
    SELECT 
  objects.name, 
  abonents.name, 
  link_abonents_auth_user.id_auth_user
FROM 
  public.abonents, 
  public.objects, 
  public.link_abonents_auth_user
WHERE 
  abonents.guid_objects = objects.guid AND
  link_abonents_auth_user.guid_abonents = abonents.guid AND
  link_abonents_auth_user.id_auth_user = %s;
    """ % user_id
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table 

def get_query_for_obj_water_impulse_consumption(obj_title, obj_parent_title,electric_data_start, electric_data_end):
    sQuery ="""    
SELECT  z.ab_name, 
substring(z.meter_name, 0, strpos(z.meter_name, ',')),
substring(z.meter_name, strpos(z.meter_name, '№')+1)
 ,z.date_st, z.meter_name,
z.type_energo,
round(z.value_st::numeric,3),
round(z.value_end::numeric,3),
round(delta::numeric,3), z.date_install, z.date_end, z.account_2
From
(Select z_st.ab_name, z_st.account_2,z_st.date as date_st, z_st.meter_name, z_st.type_energo, z_st.value as value_st,z_end.value as value_end,round(z_end.value::numeric-z_st.value::numeric,3) as delta, z_st.date_install, z_end.date as date_end
from
(Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='Импульс'
  and date='%s'

)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s'
order by obj_name, water_abons_report.ab_name, type_energo) z_st,
(
Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='Импульс'
  and date='%s'
)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s'
order by obj_name, water_abons_report.ab_name, type_energo) z_end
where z_st.meter_name=z_end.meter_name) z
order by ab_name, meter_name
    """%(electric_data_start, obj_title, electric_data_end, obj_title)
    #print sQuery
    return sQuery

def get_query_for_abon_water_impulse_consumption(obj_title, obj_parent_title,electric_data_start, electric_data_end):
    sQuery = """    
SELECT  z.ab_name, 
substring(z.meter_name, 0, strpos(z.meter_name, ',')),
substring(z.meter_name, strpos(z.meter_name, '№')+1)
 ,z.date_st, z.meter_name,
z.type_energo,
round(z.value_st::numeric,3),
round(z.value_end::numeric,3),
round(delta::numeric,3), z.date_install, z.date_end, z.account_2
From
(Select z_st.ab_name, z_st.account_2,z_st.date as date_st, z_st.meter_name, z_st.type_energo, z_st.value as value_st,z_end.value as value_end,round(z_end.value::numeric-z_st.value::numeric,3) as delta, z_st.date_install, z_end.date as date_end
from
(Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='Импульс'
  and date='%s'
)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s'
and water_abons_report.obj_name = '%s'
order by obj_name, water_abons_report.ab_name, type_energo) z_st,
(
Select  obj_name as ab_name, account_2,z2.date, water_abons_report.ab_name as meter_name,type_energo, z2.value,date_install
from water_abons_report
LEFT JOIN (
SELECT
  meters.name,
  daily_values.date,
  daily_values.value,
  abonents.name as ab_name,
  abonents.guid
FROM
  public.meters,
  public.taken_params,
  public.daily_values,
  public.abonents,
  public.link_abonents_taken_params,
  params,
  names_params,
  resources
WHERE
  taken_params.guid_meters = meters.guid AND
  daily_values.id_taken_params = taken_params.id AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid
and
  params.guid=taken_params.guid_params  and
  names_params.guid=params.guid_names_params and
  resources.guid=names_params.guid_resources and
  resources.name='Импульс'
  and date='%s'
)z2
on z2.ab_name=water_abons_report.ab_name
where water_abons_report.name='%s'
and water_abons_report.obj_name = '%s'
order by obj_name, water_abons_report.ab_name, type_energo) z_end
where z_st.meter_name=z_end.meter_name) z
order by ab_name, meter_name
    """%(electric_data_start, obj_parent_title, obj_title, electric_data_end, obj_parent_title, obj_title)
    return sQuery

def get_dt_water_impulse_consumption(obj_title, obj_parent_title,electric_data_start, electric_data_end, isAbon):
    cursor = connection.cursor()
    data_table=[] 
    sQuery =u''
    if isAbon:
        sQuery =get_query_for_abon_water_impulse_consumption(obj_title, obj_parent_title,electric_data_start, electric_data_end)
    else:
        sQuery =get_query_for_obj_water_impulse_consumption(obj_title, obj_parent_title,electric_data_start, electric_data_end)
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table 

def get_electric_register():
    cursor = connection.cursor()
    data_table=[] 
    sQuery = """
    SELECT 
  parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0,  
  abonents.name, 
  ''::text as askue,
  CASE When meters.name like '%М-200%' then  meters.password else ''::text end as lic_num, 
  meters.factory_number_manual, 
  meters.address, 
  replace(types_meters.name, 'Меркурий ','М-'),
  link_abonents_taken_params.coefficient, 
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port 
FROM 
  public.parent_objects_for_progruz, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.params, 
  public.resources, 
  public.names_params, 
  public.link_meters_tcpip_settings, 
  public.tcpip_settings,
  types_meters
WHERE 
  types_meters.guid = params.guid_types_meters and
  parent_objects_for_progruz.ab_guid = abonents.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  link_meters_tcpip_settings.guid_meters = meters.guid AND
  link_meters_tcpip_settings.guid_tcpip_settings = tcpip_settings.guid
  and resources.name = 'Электричество'
  group by 
parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0, 
  parent_objects_for_progruz.ab_name, 
  abonents.name, 
  abonents.account_1, 
  meters.factory_number_manual, 
  meters.address, 
  resources.name, 
  link_abonents_taken_params.coefficient,
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port, 
  meters.password,
  meters.name,
  types_meters.name
  order by parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0, 
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port, 
    meters.address, 
  parent_objects_for_progruz.ab_name
    """
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table 

def get_water_register():
    cursor = connection.cursor()
    data_table=[] 
    sQuery = """
    SELECT 
  parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0,  
  abonents.name, 
  ''::text as askue,
  ''::text as lic_num, 
  meters.factory_number_manual, 
  meters.address, 
  types_meters.name,
  link_abonents_taken_params.coefficient, 
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port 
FROM 
  public.parent_objects_for_progruz, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.params, 
  public.resources, 
  public.names_params, 
  public.link_meters_tcpip_settings, 
  public.tcpip_settings,
  types_meters
WHERE 
  types_meters.guid = params.guid_types_meters and
  parent_objects_for_progruz.ab_guid = abonents.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  link_meters_tcpip_settings.guid_meters = meters.guid AND
  link_meters_tcpip_settings.guid_tcpip_settings = tcpip_settings.guid
  and (resources.name = 'ХВС'or  resources.name = 'ГВС')
  group by 
parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0, 
  parent_objects_for_progruz.ab_name, 
  abonents.name, 
  abonents.account_1, 
  meters.factory_number_manual, 
  meters.address, 
  resources.name, 
  link_abonents_taken_params.coefficient,
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port, 
  meters.password,
  meters.name,
  types_meters.name
  order by parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0, 
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port, 
  parent_objects_for_progruz.ab_name
    """
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table 

def get_heat_register():
    cursor = connection.cursor()
    data_table=[] 
    sQuery = """
    SELECT 
  parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0,  
  abonents.name, 
  ''::text as askue,
  ''::text as lic_num, 
  meters.factory_number_manual, 
  meters.address, 
  types_meters.name,
  link_abonents_taken_params.coefficient, 
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port  
FROM 
  public.parent_objects_for_progruz, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.params, 
  public.resources, 
  public.names_params, 
  public.link_meters_tcpip_settings, 
  public.tcpip_settings,
  types_meters
WHERE 
  types_meters.guid = params.guid_types_meters and
  parent_objects_for_progruz.ab_guid = abonents.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  link_meters_tcpip_settings.guid_meters = meters.guid AND
  link_meters_tcpip_settings.guid_tcpip_settings = tcpip_settings.guid
  and resources.name = 'Тепло'
  group by 
parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0, 
  parent_objects_for_progruz.ab_name, 
  abonents.name, 
  abonents.account_1, 
  meters.factory_number_manual, 
  meters.address, 
  resources.name, 
  link_abonents_taken_params.coefficient,
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port, 
  meters.password,
  meters.name,
  types_meters.name
  order by parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0, 
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port, 
    meters.address, 
  parent_objects_for_progruz.ab_name
    """
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table 

def get_water_impulse_register():
    cursor = connection.cursor()
    data_table=[] 
    sQuery = """
   SELECT 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0,  
  abonents.name, 
  meters.factory_number_manual||'('||types_meters.name||')' as reg, 
  params.param_address,
  meters.address, 
  types_meters.name, 
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port
FROM 
  public.parent_objects_for_progruz, 
  public.abonents, 
  public.link_abonents_taken_params, 
  public.taken_params, 
  public.meters, 
  public.params, 
  public.resources, 
  public.names_params, 
  public.link_meters_tcpip_settings, 
  public.tcpip_settings,
  types_meters
WHERE 
  types_meters.guid = params.guid_types_meters and
  parent_objects_for_progruz.ab_guid = abonents.guid AND
  link_abonents_taken_params.guid_abonents = abonents.guid AND
  link_abonents_taken_params.guid_taken_params = taken_params.guid AND
  taken_params.guid_meters = meters.guid AND
  taken_params.guid_params = params.guid AND
  params.guid_names_params = names_params.guid AND
  names_params.guid_resources = resources.guid AND
  link_meters_tcpip_settings.guid_meters = meters.guid AND
  link_meters_tcpip_settings.guid_tcpip_settings = tcpip_settings.guid
  and (resources.name = 'Импульс')
  group by 
parent_objects_for_progruz.obj_name2, 
  parent_objects_for_progruz.obj_name1, 
  parent_objects_for_progruz.obj_name0, 
  parent_objects_for_progruz.ab_name, 
  abonents.name, 
  abonents.account_1, 
  meters.factory_number_manual, 
  meters.address, 
  resources.name, 
  link_abonents_taken_params.coefficient,
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port, 
  meters.password,
  meters.name,
  types_meters.name,
 params.param_address
  order by 
  parent_objects_for_progruz.obj_name1,
  meters.factory_number_manual, 
  params.param_address,
  tcpip_settings.ip_address, 
  tcpip_settings.ip_port 
    """
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table 

def get_80020_group_by_name(group_name):
    cursor = connection.cursor()
    data_table=[] 
    sQuery = """
      SELECT guid, name, name_sender, inn_sender, name_postavshik, inn_postavshik, dogovor_number
      FROM groups_80020
      WHERE name = '%s'
    """%(group_name)
    cursor.execute(sQuery)  
    data_table = cursor.fetchall()
    return data_table