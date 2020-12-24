# coding -*- coding: utf-8 -*-
from django.shortcuts import render, redirect
from django.contrib import auth
from django.views.decorators.csrf import csrf_protect
#from django.core.context_processors import csrf
import string, time, datetime, pytz

from django.contrib.auth.models import User

def remake(text, shift):
    spec = "!@#$%^&*({)}[]?><;.,/"
    small = string.ascii_lowercase
    big = string.ascii_uppercase
    digits = string.digits
    all_simb = 65*(spec+ digits + big + digits + small + digits)
    shifr = ""
    for s in text:    
        n = ord(s)
        shifr += all_simb[n + shift]
    return shifr

def check_pass(username):
    pass    
    # if username != 'user': return False
    # local_tz = pytz.timezone('Europe/Moscow')
    # td = datetime.datetime.now().astimezone(local_tz)
    # user = User.objects.filter(username = username)[0]
    # delta = td - user.date_joined        
    # if (delta.days * 24 + delta.seconds/3600) > 1: #delta.days
    #     obj_name = """ 
    #     ЖК "Среда"
    #     """
    #     obj_name = obj_name.strip()
    #     today = time.localtime()
    #     shift = 2
    #     if (today.tm_mday % 2 == 0):
    #         shift = 4
    #         if (today.tm_mon % 2 == 0):
    #             shift = 7
    #     my_date = chr(today.tm_mday) + '_' + chr(today.tm_mon) + '_' + chr(today.tm_year)
    #     hid_obj = remake(obj_name, shift)
    #     hid_date = remake(my_date, shift)        
    #     user.set_password(hid_date+hid_obj)
    #     user.date_joined = td
    #     user.save()
    # return True


# Create your views here.
@csrf_protect
def login(request):
    args={}
    #args.update(csrf(request))
    if request.POST:
        username = request.POST.get('username', '')
        password = request.POST.get('password', '')
        check_pass(username)
        user = auth.authenticate(username=username, password=password)
        if user is not None:
            auth.login(request, user)
            return redirect('/')
        else :
            args['login_error'] = "Пользователь не найден"
            return render(request, 'login.html', args)
    else:
        return render(request, 'login.html', args)
    
def logout(request):
    args={}
    return render(request, 'login.html', args)