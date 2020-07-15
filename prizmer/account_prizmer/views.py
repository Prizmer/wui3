# -*- coding: utf-8 -*-
from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.contrib.auth.decorators import login_required
import common_sql

# Create your views here.
@login_required(login_url='/auth/login/') 
def account(request):
    args = {}
    dt =[]
    obj_name = ''
    ab_name = ''
    dt = common_sql.get_abonent_and_object_name_by_account(request.user.id)
    
    if len(dt)>0 :
        obj_name = dt[0][0]
        ab_name = dt[0][1]
 
    args['user_name'] = request.user.first_name + ' ' + request.user.last_name
    args['ab_name'] = ab_name
    args['obj_name'] = obj_name
    return render_to_response("account/base.html", args)

def go_out(request):
    auth.logout(request)
    return redirect(account)
    
def electric_info(request):
    args = {}
    date_end = ""
    date_start = ""
    period = "" #daily or period
    dt_electric = []
    if request.is_ajax():
        if request.method == 'GET':
            request.session["date_end"]    = date_end    = request.GET['date_end']
            request.session["date_start"]    = date_start    = request.GET['date_start']
            request.session["period"]    = period    = request.GET['period']
        if (period == 'daily'):
            dt_electric = common_sql.get_electric_daily_by_user(request.user.id, date_end)
        else:
            dt_electric = common_sql.get_electric_period_by_user(request.user.id, date_start, date_end)
    common_sql.ChangeNull(dt_electric, None)

    args['dt_electric'] = dt_electric
    args['date_end'] = date_end
    args['date_start'] = date_start
    args['period'] = period    
    return render_to_response("account/electric_info.html", args)


def heat_info(request):
    args = {}
    date_end = ""
    date_start = ""
    period = "" #daily or period
    dt_heat_pulsar = []
    dt_heat_sayany = []
    dt_heat_elf = []
    dt_heat_karat = []
    dt_heat_danfos = []
    if request.is_ajax():
        if request.method == 'GET':
            request.session["date_end"]    = date_end    = request.GET['date_end']
            request.session["date_start"]    = date_start    = request.GET['date_start']
            request.session["period"]    = period    = request.GET['period']
        #print period
        if (period == "daily"):
            #теплосчётчик Пульсар
            dt_heat_pulsar = common_sql.get_heat_daily_by_user_pulsar(request.user.id, date_end)
            #теплосчётчик Sayany
            dt_heat_sayany = common_sql.get_heat_daily_by_user_Sayany(request.user.id, date_end)
            #теплосчётчик Elf
            dt_heat_elf = common_sql.get_heat_daily_by_user_Elf(request.user.id, date_end)
            #теплосчётчик Karat
            dt_heat_karat = common_sql.get_heat_daily_by_user_Karat(request.user.id, date_end)
            #теплосчётчик Danfos
            dt_heat_danfos = common_sql.get_heat_daily_by_user_Danfos(request.user.id, date_end)
        else:
            pass
            #dt_electric = common_sql.get_heat_period_by_user_pulsar(request.user.id, date_start, date_end)
    common_sql.ChangeNull(dt_heat_pulsar, None)
    common_sql.ChangeNull(dt_heat_sayany, None)
    common_sql.ChangeNull(dt_heat_elf, None)
    common_sql.ChangeNull(dt_heat_karat, None)
    common_sql.ChangeNull(dt_heat_danfos, None)

    args['dt_heat_pulsar'] = dt_heat_pulsar 
    args['dt_heat_sayany'] = dt_heat_sayany 
    args['dt_heat_elf'] =  dt_heat_elf 
    args['dt_heat_karat'] = dt_heat_karat 
    args['dt_heat_danfos'] = dt_heat_danfos
    args['date_end'] = date_end
    args['date_start'] = date_start
    args['period'] = period   
    return render_to_response("account/heat_info.html", args)

def water_info(request):
    args = {}
    date_end = ""
    date_start = ""
    period = "" #daily or period
    dt_water_digital = []
    dt_water_impulse = []
    dt_water_elf = []
 
    if request.is_ajax():
        if request.method == 'GET':
            request.session["date_end"]    = date_end    = request.GET['date_end']
            request.session["date_start"]    = date_start    = request.GET['date_start']
            request.session["period"]    = period    = request.GET['period']
        #print period
        if (period == "daily"):
            #цифровые:
            dt_water_digital = common_sql.get_water_digital_daily_by_user(request.user.id, date_end)
            #импульсные:
            dt_water_impulse = common_sql.get_water_impulse_daily_by_user(request.user.id, date_end)
            #эльфs:
            dt_water_elf = common_sql.get_water_elf_daily_by_user(request.user.id, date_end)            
        else:
            pass
            #dt_electric = common_sql.get_heat_period_by_user_pulsar(request.user.id, date_start, date_end)
    common_sql.ChangeNull(dt_water_impulse, None)
    common_sql.ChangeNull(dt_water_digital, None)
    common_sql.ChangeNull(dt_water_elf, None)

    args['dt_water_impulse'] = dt_water_impulse
    args['dt_water_digital'] = dt_water_digital 
    args['dt_water_elf'] = dt_water_elf    
    args['date_end'] = date_end
    args['date_start'] = date_start
    args['period'] = period  
    return render_to_response("account/water_info.html", args)