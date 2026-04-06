from django.shortcuts import render
from django.http import HttpResponse

import time
import socket
from .drivers import m23x_driver
from common_sql import get_connection_by_serial_number
import json
import simplejson 
from plotly.utils import PlotlyJSONEncoder
from django.template.loader import render_to_string 
import math
import plotly.graph_objects as go


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




def get_test_data():
    """
    Возвращает тестовые данные со счётчика (как на скриншоте конфигуратора).
    Потом заменишь на чтение реальных данных из БД/прибора.
    """
    return {
        'phases': {
            'phase1': {
                'name': 'Фаза-1',
                'color': '#F4D03F',  # Жёлтый
                'U': 234.22,          # Напряжение (В)
                'I': 1.34,            # Ток (А)
                'P': 65.80,           # Активная мощность (Вт)
                'Q': -306.67,         # Реактивная мощность (вар)
                'S': 313.68,          # Полная мощность (ВА)
                'cos_phi': 0.210,     # Коэффициент мощности
            },
            'phase2': {
                'name': 'Фаза-2',
                'color': '#2ECC71',   # Зелёный
                'U': 233.10,
                'I': 0.36,
                'P': 4.92,
                'Q': -82.93,
                'S': 83.13,
                'cos_phi': 0.058,
            },
            'phase3': {
                'name': 'Фаза-3',
                'color': '#E74C3C',   # Красный
                'U': 233.72,
                'I': 0.10,
                'P': 13.06,
                'Q': -19.40,
                'S': 23.27,
                'cos_phi': 0.562,
            },
        },
        'total': {
            'P': 83.78,
            'Q': -408.78,
            'S': 420.22,
            'cos_phi': 0.199,
        },
        'angles': {
            'f1_f2': 120.04,
            'f1_f3': 240.99,
            'f2_f3': 120.95,
        },
        'frequency': 49.96,
        'timestamp': '18.03.2026 12:34:56',
    }


# ============================================================================
# ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
# ============================================================================

def calculate_phi(cos_phi, Q):
    """
    Рассчитывает угол сдвига фаз в градусах.
    
    Args:
        cos_phi: Коэффициент мощности
        Q: Реактивная мощность (знак определяет характер нагрузки)

    Для Меркурия М-230: угол всегда положительный (откладывается по часовой стрелке)
    """
    cos_phi = max(-1, min(1, cos_phi))
    phi_radians = math.acos(cos_phi)
    phi_degrees = math.degrees(phi_radians)
    
    #  Убран зависимость от знака Q — как в оригинальном конфигураторе
    return phi_degrees  # Всегда положительный угол



def polar_to_cartesian(magnitude, angle_degrees):
    """
    Конвертирует полярные координаты в декартовы.
    
    Args:
        magnitude: Длина вектора
        angle_degrees: Угол в градусах (0 = вправо, 90 = вверх)
    
    Returns:
        (x, y) координаты
    """
    angle_rad = math.radians(angle_degrees)
    x = magnitude * math.cos(angle_rad)
    y = magnitude * math.sin(angle_rad)
    return x, y


# ============================================================================
# ПОФАЗНАЯ ВЕКТОРНАЯ ДИАГРАММА (левая на скрине)
# ============================================================================

def create_phase_vector_diagram(data):
    fig = go.Figure()
    
    base_angle = 90
    voltage_angles = {
        'phase1': base_angle,
        'phase2': base_angle - 120,
        'phase3': base_angle - 240,
    }
    
    max_U = max(p['U'] for p in data['phases'].values())
    max_I = max(p['I'] for p in data['phases'].values())
    
    TARGET_CURRENT_RATIO = 0.6
    MIN_VISIBLE_CURRENT = 1.5
    
    if max_I > 0:
        CURRENT_SCALE_FACTOR = (max_U * TARGET_CURRENT_RATIO) / max_I
    else:
        CURRENT_SCALE_FACTOR = 100
    
    for phase_key, angle in voltage_angles.items():
        phase_data = data['phases'][phase_key]
        U = phase_data['U']
        I = phase_data['I']
        cos_phi = phase_data['cos_phi']
        Q = phase_data['Q']
        color = phase_data['color']
        name = phase_data['name']
        
        # === ВЕКТОР НАПРЯЖЕНИЯ ===
        x_end_U, y_end_U = polar_to_cartesian(U, angle)
        
        fig.add_trace(go.Scatter(
            x=[0, x_end_U],
            y=[0, y_end_U],
            mode='lines',
            line=dict(color=color, width=3),
            name=f'{name} U={U:.1f}В',
            legendgroup=f'{name}',
            showlegend=True,
            hoverinfo='text',
            text=f'{name}<br>U={U:.2f}В',
        ))
        
        # === СТРЕЛКА напряжения ===
        fig.add_annotation(
            x=x_end_U,
            y=y_end_U,
            ax=x_end_U * 0.85,  # Начало стрелки (85% от длины)
            ay=y_end_U * 0.85,
            xref="x",
            yref="y",
            axref="x",
            ayref="y",
            showarrow=True,
            arrowhead=2,
            arrowsize=1.5,
            arrowwidth=3,
            arrowcolor=color,
        )
        
        # === ВЕКТОР ТОКА ===
        phi = calculate_phi(cos_phi, Q)
        if Q < 0:
            current_angle = angle + phi
        else:
            current_angle = angle - phi
        
        if I < MIN_VISIBLE_CURRENT:
            I_for_scale = MIN_VISIBLE_CURRENT
        else:
            I_for_scale = I
        
        I_scaled = I_for_scale * CURRENT_SCALE_FACTOR
        x_end_I, y_end_I = polar_to_cartesian(I_scaled, current_angle)
        
        fig.add_trace(go.Scatter(
            x=[0, x_end_I],
            y=[0, y_end_I],
            mode='lines',
            line=dict(color=color, width=2, dash='dash'),
            name=f'{name} I={I:.2f}А',
            legendgroup=f'{name}',
            showlegend=True,
            hoverinfo='text',
            text=f'{name}<br>I={I:.2f}А<br>φ={phi:.1f}°',
        ))
        
        # === СТРЕЛКА тока ===
        fig.add_annotation(
            x=x_end_I,
            y=y_end_I,
            ax=x_end_I * 0.85,  # Начало стрелки (85% от длины)
            ay=y_end_I * 0.85,
            xref="x",
            yref="y",
            axref="x",
            ayref="y",
            showarrow=True,
            arrowhead=2,
            arrowsize=1.2,
            arrowwidth=2,
            arrowcolor=color,
        )
    
    axis_range = max_U * 1.2
    
    fig.update_layout(
        title='',
        width=500,
        height=450,
        legend=dict(
            orientation="v",
            yanchor="top",
            y=0.98,
            xanchor="left",
            x=1.02,
            font=dict(size=9),
        ),
        margin=dict(l=40, r=110, t=30, b=40),
        xaxis=dict(
            range=[-axis_range, axis_range],
            zeroline=True,
            zerolinewidth=2,
            zerolinecolor='lightgray',
            showgrid=True,
            gridwidth=0.5,
            gridcolor='lightgray',
            showticklabels=False,
            ticks='',
        ),
        yaxis=dict(
            range=[-axis_range, axis_range],
            zeroline=True,
            zerolinewidth=2,
            zerolinecolor='lightgray',
            showgrid=True,
            gridwidth=0.5,
            gridcolor='lightgray',
            scaleanchor="x",
            scaleratio=1,
            showticklabels=False,
            ticks='',
        ),
        showlegend=True,
        hovermode='closest',
        plot_bgcolor='white',
    )
    
    return fig


# ============================================================================
# ДИАГРАММА ВЕКТОРА ПОЛНОЙ МОЩНОСТИ (правая на скрине)
# ============================================================================

def create_power_vector_diagram(data):
    """
    Создаёт диаграмму вектора полной мощности (4 квадранта P/Q).
    """
    fig = go.Figure()
    
    P = data['total']['P']
    Q = data['total']['Q']
    S = data['total']['S']
    
    max_range = max(abs(P), abs(Q)) * 1.5
    if max_range < 100:
        max_range = 500
    
    # === Круг (граница) ===
    theta = [i * math.pi / 180 for i in range(0, 361)]
    circle_x = [S * 1.2 * math.cos(t) for t in theta]
    circle_y = [S * 1.2 * math.sin(t) for t in theta]
    
    fig.add_trace(go.Scatter(
        x=circle_x,
        y=circle_y,
        mode='lines',
        line=dict(color='lightgray', width=1, dash='dot'),
        name='Граница',
        showlegend=False,
        hoverinfo='skip',
    ))
    
    # === Оси ===
    fig.add_trace(go.Scatter(
        x=[-max_range, max_range],
        y=[0, 0],
        mode='lines',
        line=dict(color='black', width=1),
        showlegend=False,
        hoverinfo='skip',
    ))
    
    fig.add_trace(go.Scatter(
        x=[0, 0],
        y=[-max_range, max_range],
        mode='lines',
        line=dict(color='black', width=1),
        showlegend=False,
        hoverinfo='skip',
    ))
    
    # === Вектор полной мощности СО СТРЕЛКОЙ ===
    # Основная линия
    fig.add_trace(go.Scatter(
        x=[0, P],
        y=[0, Q],
        mode='lines',
        line=dict(color='red', width=3),
        showlegend=True,
        name=f'S={S:.2f} ВА',
        hoverinfo='text',
        text=f'P={P:.2f} Вт<br>Q={Q:.2f} вар<br>S={S:.2f} ВА',
    ))

    # === Наконечник стрелки (треугольник из линий) ===
    # Вычисляем угол вектора
    vector_angle = math.atan2(Q, P)

    # Размер наконечника
    arrow_head_size = 30  # пикселей

    # Координаты двух сторон наконечника
    arrow_angle = math.pi / 6  # 30 градусов угол наконечника

    # Точка 1 наконечника (левая сторона)
    x1 = P - arrow_head_size * math.cos(vector_angle - arrow_angle)
    y1 = Q - arrow_head_size * math.sin(vector_angle - arrow_angle)

    # Точка 2 наконечника (правая сторона)  
    x2 = P - arrow_head_size * math.cos(vector_angle + arrow_angle)
    y2 = Q - arrow_head_size * math.sin(vector_angle + arrow_angle)

    # Рисуем наконечник (две линии)
    fig.add_trace(go.Scatter(
        x=[x1, P, x2],
        y=[y1, Q, y2],
        mode='lines',
        line=dict(color='red', width=3),
        showlegend=False,
        hoverinfo='skip',
    ))
    
    # === Квадранты ===
    quadrant_size = max_range * 0.6
    for i, (qx, qy) in enumerate([(1,1), (-1,1), (-1,-1), (1,-1)], 1):
        fig.add_annotation(
            x=qx*quadrant_size*0.7, y=qy*quadrant_size*0.7,
            text=str(i), showarrow=False,
            font=dict(size=14, color='green', family='Arial Black')
        )
    
    # === Подписи осей ===
    fig.add_annotation(x=max_range*0.95, y=0, text="P", showarrow=False, font=dict(size=12, weight='bold'))
    fig.add_annotation(x=0, y=max_range*0.95, text="Q", showarrow=False, font=dict(size=12, weight='bold'))
    
    # === Легенда ===
    fig.update_layout(
        title='',
        width=380,
        height=380,
        legend=dict(
            orientation="h",
            yanchor="bottom",
            y=-0.15,
            xanchor="center",
            x=0.5,
            font=dict(size=9),
        ),
        margin=dict(l=40, r=40, t=30, b=60),
        xaxis=dict(
            range=[-max_range, max_range],
            zeroline=False,
            visible=False,
            showticklabels=False,
            ticks='',
        ),
        yaxis=dict(
            range=[-max_range, max_range],
            zeroline=False,
            visible=False,
            scaleanchor="x",
            scaleratio=1,
            showticklabels=False,
            ticks='',
        ),
        showlegend=True,
        hovermode='closest',
        plot_bgcolor='white',
    )
    
    return fig

def get_vector_diagrams(request):
    """AJAX endpoint: диаграммы + таблица данных"""
    data = None
    if request.is_ajax():
        if request.method == 'GET':
            # print("Запрос на чтение значения контроля мощности")
            factory_number = request.GET.get('factory_number')
            print(factory_number)
            try:
                factory_number = int(factory_number)
                conn = get_connection_by_serial_number(factory_number)
                if conn and len(conn) > 0:
                    host = conn[0][0]
                    port = int(conn[0][1])
                    net_addr = int(conn[0][2])
                    # Запршиваем реальные данные
                    data = m23x_driver.get_real_vector_data(host, port, net_addr)
                else:
                    print("Не найдены настройки для заводского номера:", factory_number)
            except Exception as e:
                print(f"Ошибка получения данных для вектора: {e}")

    # Проверка, что данные получены и не пустые
    if not data or data.get('frequency', 0.0) == 0.0:
        return HttpResponse(
            json.dumps({'status': 'error', 'message': 'Не удалось опросить счётчик (нет ответа или связи)'}),
            content_type='application/json'
        )
    
    # Строим диаграммы
    phase_fig = create_phase_vector_diagram(data)
    power_fig = create_power_vector_diagram(data)
    
    # === Рендерим таблицу данных в HTML ===
    # Создаём простой список для таблицы
    table_rows = []
    for phase_key in ['phase1', 'phase2', 'phase3']:
        p = data['phases'][phase_key]
        table_rows.append({
            'phase': p['name'],
            'color': p['color'],
            'U': p['U'],
            'I': p['I'],
            'P': p['P'],
            'Q': p['Q'],
            'S': p['S'],
            'cos_phi': p['cos_phi'],
        })
    
    # Рендерим мини-шаблон таблицы (встроим его прямо в ответ)
    table_html = render_to_string('data_table/vector_data_table.html', {
        'rows': table_rows,
        'total': data['total'],
        'frequency': data.get('frequency'),
        'timestamp': data.get('timestamp'),
    })
    
    response_data = {
        'status': 'ok',
        'phase_diagram': json.dumps(phase_fig, cls=PlotlyJSONEncoder),
        'power_diagram': json.dumps(power_fig, cls=PlotlyJSONEncoder),
        'data_table_html': table_html,  # <-- готовая таблица
    }
    
    return HttpResponse(
        json.dumps(response_data),
        content_type='application/json'
    )