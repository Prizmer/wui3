from django.shortcuts import render
from django.http import HttpResponse
from django.shortcuts import render
from django.http import JsonResponse
import datetime
import time
import socket
from .drivers import m23x_driver
from .drivers import crc_calc
from .drivers import sattelite


# Create your views here.

def current_m230(request):
    default_value = 'Нет данных'
    args={}
    args['curr_t0'] = default_value
    args['curr_t1'] = default_value
    args['curr_t2'] = default_value
    args['curr_t3'] = default_value
    args['curr_t4'] = default_value
    net_addr = 16
    HOST = '94.199.105.211'
    PORT = '14019'
    if request.is_ajax():
        #args={}
        if request.method == 'GET':
            request.session["net_addr"]    = net_addr    = request.GET['net_addr']
            print("Мы получили запрос текущих. Сетевой № " + str(net_addr))
            net_addr = int(net_addr)
            net_addr = 16
        try:

            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(m23x_driver.SOCKET_TIMEOUT)
                sock.connect((HOST, int(PORT)))
                time.sleep(0.2)

                curr_t0 = m23x_driver.polling_daily(sock, net_addr, m23x_driver.ENERGY_CURRENT_T0)
                args['curr_t0'] = curr_t0
                curr_t1 = m23x_driver.polling_daily(sock, net_addr, m23x_driver.ENERGY_CURRENT_T1)
                args['curr_t1'] = curr_t1
                curr_t2 = m23x_driver.polling_daily(sock, net_addr, m23x_driver.ENERGY_CURRENT_T2)
                args['curr_t2'] = curr_t2
                curr_t3 = m23x_driver.polling_daily(sock, net_addr, m23x_driver.ENERGY_CURRENT_T3)
                args['curr_t3'] = curr_t3
                curr_t4 = m23x_driver.polling_daily(sock, net_addr, m23x_driver.ENERGY_CURRENT_T4)
                args['curr_t4'] = curr_t4
        except:
            print("Нет связи")
                
    # return render(request, "polling/current_m23x.html", args)
    return HttpResponse("Сумма= "+str(args['curr_t0']) + " Тариф 1= "+str(args['curr_t1']) + " Тариф 2= "+str(args['curr_t2']))


 