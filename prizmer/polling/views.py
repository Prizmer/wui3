from django.shortcuts import render
from django.http import HttpResponse

import time
import socket
from .drivers import m23x_driver
from common_sql import get_connection_by_serial_number


def current_m230(request):
    default_value = 'Нет данных'
    args={}
    args['curr_t0'] = default_value
    args['curr_t1'] = default_value
    args['curr_t2'] = default_value
    args['curr_t3'] = default_value
    args['curr_t4'] = default_value

    if request.is_ajax():
        #args={}
        if request.method == 'GET':
            factory_number = request.GET.get('factory_number')
            # print("Мы получили запрос на текущие показания. Заводской № " + str(factory_number))
            factory_number = int(factory_number)
            conn = get_connection_by_serial_number(factory_number)
            host = conn[0][0]
            port = conn[0][1]
            net_addr = conn[0][2]
        try:

            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(m23x_driver.SOCKET_TIMEOUT)
                sock.connect((host, int(port)))
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
            return HttpResponse('Нет связи c прибором')
                
    
    sRec = f"""    		<p>
							<div class="row">
								<div class="col-md-6">Сумма</div>
								<div  class="col-md-6">{curr_t0}</div>
                                <div class="col-md-6">Tариф 1</div>
								<div  class="col-md-6">{curr_t1}</div>
                                <div class="col-md-6">Tариф 2</div>
								<div  class="col-md-6">{curr_t2}</div>
                                <div class="col-md-6">Tариф 3</div>
								<div  class="col-md-6">{curr_t3}</div>								
							</div> <p>
							
    """
    return HttpResponse(sRec)
    #return HttpResponse("Сумма= "+str(args['curr_t0']) + " Тариф 1= "+str(args['curr_t1']) + " Тариф 2= "+str(args['curr_t2']))
    #return render(request, "polling/current_m23x.html", args)


def power_on(request):
    result = 'Нет связи c прибором'

    if request.is_ajax():

        if request.method == 'GET':
            factory_number = request.GET.get('factory_number')
            # print("Мы получили запрос на включение нагрузки. Заводской № " + str(factory_number))
            factory_number = int(factory_number)
            conn = get_connection_by_serial_number(factory_number)
            host = conn[0][0]
            port = conn[0][1]
            net_addr = conn[0][2]
        try:

            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(m23x_driver.SOCKET_TIMEOUT)
                sock.connect((host, int(port)))
                time.sleep(0.2)
                result = m23x_driver.set_power_on(sock, net_addr) 

        except:
            return HttpResponse(str(result))
                
    #return render(request, "polling/current_m23x.html", args)
    return HttpResponse(str(result))

def power_off(request):
    result = 'Нет связи c прибором'

    if request.is_ajax():

        if request.method == 'GET':
            factory_number = request.GET.get('factory_number')
            # print("Мы получили запрос на выключение нагрузки. Заводской № " + str(factory_number))
            factory_number = int(factory_number)
            conn = get_connection_by_serial_number(factory_number)
            host = conn[0][0]
            port = conn[0][1]
            net_addr = conn[0][2]
        try:

            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(m23x_driver.SOCKET_TIMEOUT)
                sock.connect((host, int(port)))
                time.sleep(0.2)
                result = m23x_driver.set_power_off(sock, net_addr) 

        except:
            return HttpResponse(str(result))
                
    return HttpResponse(str(result))

def set_active_power_limit_value(request):
    result = 'Нет связи c прибором'

    if request.is_ajax():
        if request.method == 'GET':
            print("Запрос на установку значения контроля мощности")
            value = request.GET.get('power_value')
            value = str(value)
            control_state = request.GET.get('control_state')
            factory_number = request.GET.get('factory_number')
            factory_number = int(factory_number)
            conn = get_connection_by_serial_number(factory_number)
            host = conn[0][0]
            port = conn[0][1]
            net_addr = conn[0][2]
        try:

            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(m23x_driver.SOCKET_TIMEOUT)
                sock.connect((host, int(port)))
                time.sleep(0.2)
                result = m23x_driver.set_active_power_limit(sock, net_addr, value)

                if control_state == '1':
                    print("Включаем контроль")
                    m23x_driver.set_active_power_limit_off(sock, net_addr)
                elif control_state == '2':
                    print("Отключаем контроль")
                    m23x_driver.set_active_power_limit_on(sock, net_addr)
                else:
                    pass 

        except Exception as e:
            # print(e)
            return HttpResponse(str(result))
                
    return HttpResponse(str(result))

def get_active_power_limit_value(request):
    result = 'Нет связи c прибором'

    if request.is_ajax():
        if request.method == 'GET':
            # print("Запрос на чтение значения контроля мощности")
            factory_number = request.GET.get('factory_number')
            factory_number = int(factory_number)
            conn = get_connection_by_serial_number(factory_number)
            host = conn[0][0]
            port = conn[0][1]
            net_addr = conn[0][2]
        try:

            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(m23x_driver.SOCKET_TIMEOUT)
                sock.connect((host, int(port)))
                time.sleep(0.2)
                result = m23x_driver.get_active_power_limit(sock, net_addr)
                time.sleep(0.1)
                status = m23x_driver.get_power_limit_state(sock, net_addr)

        except Exception as e:
            # print(e)
            return HttpResponse(str(result), str(status))
                
    # return HttpResponse(str(result), "1")
    return HttpResponse(str(result)+ ','+ str(status))

def get_power_state(request):
    result = 'Нет связи c прибором'

    if request.is_ajax():
        if request.method == 'GET':
            # print("Запрос на чтение сотояния реле нагрузки")
            factory_number = request.GET.get('factory_number')
            factory_number = int(factory_number)
            conn = get_connection_by_serial_number(factory_number)
            host = conn[0][0]
            port = conn[0][1]
            net_addr = conn[0][2]
        try:

            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(m23x_driver.SOCKET_TIMEOUT)
                sock.connect((host, int(port)))
                time.sleep(0.2)
                result = m23x_driver.get_power_state(sock, net_addr)

        except Exception as e:
            # print(e)
            return HttpResponse(str(result))
                
    return HttpResponse(str(result))
