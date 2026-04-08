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


def draw_arrowhead(fig, x_tip, y_tip, angle_deg, size, color, legendgroup=None):
    """
    Рисует закрашенный треугольный наконечник стрелки на конце вектора.

    Все координаты в пространстве данных — независимо от масштаба и версии Plotly.

    Args:
        x_tip, y_tip  — конец вектора (остриё наконечника)
        angle_deg     — направление вектора в градусах (стандарт: 0=вправо, 90=вверх)
        size          — длина наконечника в единицах данных
        color         — цвет заливки
    """
    angle_rad = math.radians(angle_deg)
    perp_rad  = angle_rad + math.pi / 2

    # Центр основания треугольника (отступаем назад от острия)
    bx = x_tip - size * math.cos(angle_rad)
    by = y_tip - size * math.sin(angle_rad)

    # Полуширина основания
    hw = size * 0.45

    x1 = bx + hw * math.cos(perp_rad)
    y1 = by + hw * math.sin(perp_rad)
    x2 = bx - hw * math.cos(perp_rad)
    y2 = by - hw * math.sin(perp_rad)

    kwargs = dict(legendgroup=legendgroup) if legendgroup else {}
    fig.add_trace(go.Scatter(
        x=[x1, x_tip, x2, x1],
        y=[y1, y_tip, y2, y1],
        mode='lines',
        fill='toself',
        fillcolor=color,
        line=dict(color=color, width=0),
        showlegend=False,
        hoverinfo='skip',
        **kwargs,
    ))



def create_phase_vector_diagram(data):
    fig = go.Figure()
    
    base_angle = 90
    
    # Получаем реальные углы между фазами из данных (f1_f2 и f1_f3)
    # По умолчанию используем идеальные 120 и 240 градусов
    angles_data = data.get('angles', {})
    angle12 = angles_data.get('f1_f2', 120.0)
    angle13 = angles_data.get('f1_f3', 240.0)
    
    # Если прибор вернул нули или данные некорректны, используем идеал
    if angle12 <= 0: angle12 = 120.0
    if angle13 <= 0: angle13 = 240.0

    voltage_angles = {
        'phase1': base_angle,
        'phase2': base_angle - angle12,
        'phase3': base_angle - angle13,
    }
    
    max_U = max(p['U'] for p in data['phases'].values())
    max_I = max(p['I'] for p in data['phases'].values())

    # Токи масштабируются так, чтобы максимальный ток занимал
    # TARGET_CURRENT_RATIO от максимального напряжения.
    # Таким образом ни один вектор тока не выйдет за пределы осей.
    TARGET_CURRENT_RATIO = 0.75   # максимальный ток = 75% от max_U
    MIN_I_RATIO = 0.10            # минимально видимый ток = 10% от max_U

    if max_I > 0:
        CURRENT_SCALE_FACTOR = (max_U * TARGET_CURRENT_RATIO) / max_I
    else:
        CURRENT_SCALE_FACTOR = 1.0

    min_I_length = max_U * MIN_I_RATIO  # минимальная длина вектора тока в единицах U

    # Размеры наконечников стрелок: увеличены в 2 раза
    axis_range  = max_U * 1.2
    arrow_size_U = axis_range * 0.09   # наконечник напряжения
    arrow_size_I = axis_range * 0.07   # наконечник тока

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

        # Формируем текст для легенды напряжения (угол относительно Фазы-1)
        if phase_key == 'phase1':
            v_name = f'{name} U={U:.1f}В'
        elif phase_key == 'phase2':
            v_name = f'{name} U={U:.1f}В ∠{angle12:.1f}°'
        else: # phase3
            v_name = f'{name} U={U:.1f}В ∠{angle13:.1f}°'

        fig.add_trace(go.Scatter(
            x=[0, x_end_U],
            y=[0, y_end_U],
            mode='lines',
            line=dict(color=color, width=3),
            name=v_name,
            legendgroup=f'{name}',
            showlegend=True,
            hoverinfo='text',
            text=f'{name}<br>U={U:.2f}В',
        ))

        # СТРЕЛКА напряжения: закрашенный треугольник в координатах данных
        draw_arrowhead(fig, x_end_U, y_end_U, angle, arrow_size_U, color, legendgroup=name)

        # === ВЕКТОР ТОКА ===
        phi = calculate_phi(cos_phi, Q)
        if Q < 0:
            current_angle = angle + phi
        else:
            current_angle = angle - phi

        # Масштабируем ток: применяем единый коэффициент,
        # затем ограничиваем сверху напряжением этой фазы (U),
        # снизу — минимально видимой длиной.
        I_scaled = I * CURRENT_SCALE_FACTOR
        I_scaled = max(I_scaled, min_I_length)   # не меньше минимума
        I_scaled = min(I_scaled, U * TARGET_CURRENT_RATIO)  # не больше U*ratio данной фазы

        x_end_I, y_end_I = polar_to_cartesian(I_scaled, current_angle)

        fig.add_trace(go.Scatter(
            x=[0, x_end_I],
            y=[0, y_end_I],
            mode='lines',
            line=dict(color=color, width=2, dash='dash'),
            name=f'{name} I={I:.2f}А φ={phi:.1f}°',
            legendgroup=f'{name}',
            showlegend=True,
            hoverinfo='text',
            text=f'{name}<br>I={I:.2f}А<br>φ={phi:.1f}°',
        ))

        # СТРЕЛКА тока: закрашенный треугольник в координатах данных
        draw_arrowhead(fig, x_end_I, y_end_I, current_angle, arrow_size_I, color, legendgroup=name)

    # axis_range уже вычислен выше (= max_U * 1.2)
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
        name=f'S={S:.1f} ВА',
        hoverinfo='text',
        text=f'P={P:.1f} Вт<br>Q={Q:.1f} вар<br>S={S:.1f} ВА',
    ))

    # СТРЕЛКА: закрашенный треугольник в координатах данных (размер увеличен в 2 раза)
    power_angle_deg = math.degrees(math.atan2(Q, P))
    draw_arrowhead(fig, P, Q, power_angle_deg, max_range * 0.12, 'red')

    
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