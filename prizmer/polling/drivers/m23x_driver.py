import sys
import time
import struct
from typing import Dict, Any

from crc_calc import pretty_hex
from crc_calc import HexToByte
import socket
from sattelite import calc_crc_modbus, calc_serial, calc_energy_daily


SOCKET_TIMEOUT = 1.0
DELAY_WAIT_DATA = 0.2

INIT_CMD = '0102020202020202'
#init_cmd = '0101313131313131'
SERIAL_NUMBER_CMD          = '0800'

# Daily energy values
ENERGY_DAILY_T0_CMD  = '05C000'
ENERGY_DAILY_T1_CMD  = '05C001'
ENERGY_DAILY_T2_CMD  = '05C002'
ENERGY_DAILY_T3_CMD  = '05C003'
ENERGY_DAILY_T4_CMD  = '05C004'

# Current energy values
ENERGY_CURRENT_T0 = '050000'
ENERGY_CURRENT_T1 = '050001'
ENERGY_CURRENT_T2 = '050002'
ENERGY_CURRENT_T3 = '050003'
ENERGY_CURRENT_T4 = '050004'

PROFIL_LAST_ADDRESS        = '0813'

# Power limit
SET_ACTIVE_POWER_LIMIT     = '032C'   # установить лимит активной мощности
GET_STATE_POWER_LIMIT      = '0818'   # прочитать  слово состояния лимита активной мощности
GET_ACTIVE_POWER_LIMIT     = '0819'   # прочитать  лимит активной мощности
SET_ACTIVE_POWER_LIMIT_ON  = '032D01' # включить контроль превышения активной мощности
SET_ACTIVE_POWER_LIMIT_OFF = '032D00' # выключить контроль превышения активной мощности
SET_POWER_ON               = '033100' # включить нагрузку
SET_POWER_OFF              = '033101' # выключить нагрузку


def open_link(sock, number) -> bool:
    """Проверяем открывается ли канал связи до счётчика"""
    command = INIT_CMD
    number_hex = "%02X" % number
    cmd_without_crc = number_hex + command
    request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
    sock.sendall(bytes.fromhex(request))
    time.sleep(DELAY_WAIT_DATA) 
    try:
        received = (sock.recv(80).hex())
    except socket.timeout:
        #print('caught a timeout')
        return False
    if len(received) == 8:
        #print(f"Канал связи с прибором {number} открыт")
        return True
    else:
        #raise Exception("Мы не смогли открыть канал связи до прибора!!!")
        return False


def polling_serial(sock, net_address) -> str:
    """ Запрос серийного номера"""
    if open_link(sock, net_address):
        command = SERIAL_NUMBER_CMD
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 20:
        #print(f"Заводской номер запрошен с прибора {net_address}")
        return str(calc_serial(received))              
    else:
        # print(f"Канал связи с {addr} не открыт")
        return ""

def polling_daily(sock, net_address, command) -> str:
    """Запрос показаний на начало суток"""
    if open_link(sock, net_address):
        command = command
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 38:
        return str(calc_energy_daily(received))            
    else:
        # print(f"Канал связи с {addr} не открыт")
        return ''

def get_profil_last_address(sock, net_address):
    """Запрос адреса последней получасовки"""
    if open_link(sock, net_address):
        command = PROFIL_LAST_ADDRESS
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 24:
        return str(received)            
    else:
        # print(f"Канал связи с {addr} не открыт")
        return ''

def set_active_power_limit(sock, net_address, active_power_limit):
    """Запрос на установку лимита активной мощности"""
    if open_link(sock, net_address):
        command = SET_ACTIVE_POWER_LIMIT
        number_hex = "%02X" % net_address
        active_power_limit = "%06X" % (int(active_power_limit)*100)
        cmd_without_crc = number_hex + command + active_power_limit
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        print(request)
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 8:
        return "Успешная установка лимита мощности"            
    else:
        # print(f"Канал связи с {addr} не открыт")
        return ''

def get_active_power_limit(sock, net_address):
    """Запрос на чтение лимита активной мощности"""
    if open_link(sock, net_address):
        command = GET_ACTIVE_POWER_LIMIT
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 12:
        res = int(received[2:4] + received[6:8] + received[4:6], 16)//100
        return res
    else:
        # print(f"Канал связи с {net_address} не открыт")
        return ''

def set_power_on(sock, net_address):
    """Включение нагрузки"""
    if open_link(sock, net_address):
        command = SET_POWER_ON
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 8:
        return "Нагрузка включена"            
    else:
        # print(f"Канал связи с {addr} не открыт")
        return ''

def set_power_off(sock, net_address):
    """Выключение нагрузки"""
    if open_link(sock, net_address):
        command = SET_POWER_OFF
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 8:
        return "Нагрузка выключена"            
    else:
        # print(f"Канал связи с {addr} не открыт")
        return ''

def set_active_power_limit_on(sock, net_address):
    """Включение контроля превышения лимита активной мощности"""
    if open_link(sock, net_address):
        command = SET_ACTIVE_POWER_LIMIT_ON
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 8:
        return "Контроль лимита активной мощности включен"            
    else:
        # print(f"Канал связи с {addr} не открыт")
        return ''

def set_active_power_limit_off(sock, net_address):
    """Выключение контроля превышения лимита активной мощности"""
    if open_link(sock, net_address):
        command = SET_ACTIVE_POWER_LIMIT_OFF
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())

    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 8:
        return "Контроль лимита активной мощности выключен"            
    else:
        # print(f"Канал связи с {addr} не открыт")
        return ''

def get_power_state(sock, net_address):
    """Запрос слово состояния управления нагрузкой"""
    if open_link(sock, net_address):
        command = GET_STATE_POWER_LIMIT
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 10:
        state_big_1 = received[2:6]
        res_big = bin(int(state_big_1,16))[2:].zfill(16)
        # 9 bit должен отвечать за состояние нагрузки 1-выкл 0-вкл
        return res_big[9]
    else:
        # print(f"Канал связи с {net_address} не открыт")
        return ''

def get_power_limit_state(sock, net_address):
    """Запрос флага контроля лимита мощности"""
    if open_link(sock, net_address):
        command = GET_STATE_POWER_LIMIT
        number_hex = "%02X" % net_address
        cmd_without_crc = number_hex + command
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 10:
        state_big_1 = received[2:6]
        res_big = bin(int(state_big_1,16))[2:].zfill(16)
        # 6 bit должен отвечать за состояние контроля мощности
        # print(res_big)
        return res_big[6]
    else:
        # print(f"Канал связи с {net_address} не открыт")
        return ''

def calc_crc16(data: bytes) -> bytes:
    crc = 0xFFFF
    for b in data:
        crc ^= b
        for _ in range(8):
            if crc & 0x0001:
                crc = (crc >> 1) ^ 0xA001
            else:
                crc >>= 1
    return struct.pack('<H', crc)

def build_packet(addr: int, cmd: int, payload: bytes = b'') -> bytes:
    packet = bytes([addr, cmd]) + payload
    return packet + calc_crc16(packet)

def send_and_recv(sock: socket.socket, packet: bytes, timeout: float = 2.0) -> bytes:
    sock.setblocking(False)
    try:
        while sock.recv(1024): pass
    except:
        pass
    sock.setblocking(True)
    
    try:
        sock.sendall(packet)
        # Пауза, чтобы модем успел прислать пакет целиком (минимизация фрагментации)
        time.sleep(0.2)
        sock.settimeout(timeout)
        resp = sock.recv(256)
        
        # Цикл дочитывания пакета, если он разорвался на уровне TCP
        try:
            sock.settimeout(0.1)
            while True:
                chunk = sock.recv(256)
                if not chunk: break
                resp += chunk
        except Exception:
            pass
            
        return resp
    except (socket.timeout, Exception) as e:
        print(f"send_and_recv timeout/error: {e}")
        return b''

def decode_3bytes_val(data: bytes) -> int:
    if len(data) < 3: return 0
    return (data[0] << 16) | (data[2] << 8) | data[1]

def decode_2bytes_val(data: bytes) -> int:
    if len(data) < 2: return 0
    return (data[0] << 8) | data[1]

def get_real_vector_data(host: str, port: int, address: int, passw: str = "222222") -> Dict[str, Any] | None:
    result: Dict[str, Any] = {
        'phases': {
            'phase1': {'name': 'Фаза-1', 'color': '#F4D03F', 'U': 0.0, 'I': 0.0, 'P': 0.0, 'Q': 0.0, 'S': 0.0, 'cos_phi': 0.0},
            'phase2': {'name': 'Фаза-2', 'color': '#2ECC71', 'U': 0.0, 'I': 0.0, 'P': 0.0, 'Q': 0.0, 'S': 0.0, 'cos_phi': 0.0},
            'phase3': {'name': 'Фаза-3', 'color': '#E74C3C', 'U': 0.0, 'I': 0.0, 'P': 0.0, 'Q': 0.0, 'S': 0.0, 'cos_phi': 0.0},
        },
        'total': {'P': 0.0, 'Q': 0.0, 'S': 0.0, 'cos_phi': 0.0},
        'angles': {'f1_f2': 0.0, 'f1_f3': 0.0, 'f2_f3': 0.0},
        'frequency': 0.0,
        'timestamp': time.strftime('%d.%m.%Y %H:%M:%S')
    }

    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.settimeout(10.0) # increased timeout
            sock.connect((host, port))
            time.sleep(0.3) # delay after connection to allow modem init

            # Авторизация
            if len(passw) == 6 and passw.isdigit():
                pwd_bytes = bytes([int(c) for c in passw])
            elif len(passw) == 12:
                pwd_bytes = bytes.fromhex(passw)
            else:
                pwd_bytes = passw.encode('ascii')
                
            send_and_recv(sock, build_packet(address, 0x01, b'\x02' + pwd_bytes))

            # Спец. операция фиксации значений вектора (08 14 E0)
            send_and_recv(sock, build_packet(address, 0x08, b'\x14\xE0'))
            time.sleep(0.1)

            # 1. Чтение напряжений (08 14 10)
            resp_u = send_and_recv(sock, build_packet(address, 0x08, b'\x14\x10'))
            if len(resp_u) >= 10:
                result['phases']['phase1']['U'] = decode_3bytes_val(resp_u[1:4]) / 100.0
                result['phases']['phase2']['U'] = decode_3bytes_val(resp_u[4:7]) / 100.0
                result['phases']['phase3']['U'] = decode_3bytes_val(resp_u[7:10]) / 100.0

            # 2. Чтение токов (08 14 20)
            resp_i = send_and_recv(sock, build_packet(address, 0x08, b'\x14\x20'))
            if len(resp_i) >= 10:
                result['phases']['phase1']['I'] = decode_3bytes_val(resp_i[1:4]) / 1000.0
                result['phases']['phase2']['I'] = decode_3bytes_val(resp_i[4:7]) / 1000.0
                result['phases']['phase3']['I'] = decode_3bytes_val(resp_i[7:10]) / 1000.0

            # 3. Чтение углов (08 14 51)
            resp_a = send_and_recv(sock, build_packet(address, 0x08, b'\x14\x51'))
            if len(resp_a) >= 10:
                result['angles']['f1_f2'] = decode_3bytes_val(resp_a[1:4]) / 100.0
                result['angles']['f1_f3'] = decode_3bytes_val(resp_a[4:7]) / 100.0
                result['angles']['f2_f3'] = decode_3bytes_val(resp_a[7:10]) / 100.0

            # 4. Чтение частоты (08 11 40)
            resp_f = send_and_recv(sock, build_packet(address, 0x08, b'\x11\x40'))
            if len(resp_f) >= 4:
                result['frequency'] = decode_3bytes_val(resp_f[1:4]) / 100.0

            def decode_power_3bytes(data: bytes, sign_bit: int = 7) -> float:
                """Декодирует 3-байтное значение мощности с учётом знакового бита."""
                if len(data) < 3:
                    return 0.0
                raw = decode_3bytes_val(data)
                value = raw & 0x3FFFFF
                if sign_bit >= 0 and (raw & (1 << sign_bit)):
                    value = -value
                return value / 100.0

            def decode_cos_3bytes(data: bytes) -> float:
                """Декодирует 3-байтное значение cos φ."""
                if len(data) < 3:
                    return 0.0
                raw = decode_3bytes_val(data)
                value = raw & 0x3FFFFF
                return value / 1000.0

            def read_power_all_phases(bwri: int, sign_bit: int = 7) -> tuple:
                """Читает мощность одним запросом 08 16 BWRI.
                Ответ: addr(1) + 4×3 данные(12) + CRC(2) = 15 байт.
                """
                resp = send_and_recv(sock, build_packet(address, 0x08, bytes([0x16, bwri])))
                if len(resp) >= 15:
                    s  = decode_power_3bytes(resp[1:4],   sign_bit)
                    p1 = decode_power_3bytes(resp[4:7],   sign_bit)
                    p2 = decode_power_3bytes(resp[7:10],  sign_bit)
                    p3 = decode_power_3bytes(resp[10:13], sign_bit)
                    return (s, p1, p2, p3)
                return (0.0, 0.0, 0.0, 0.0)

            def read_cos_all_phases() -> tuple:
                """Читает cos φ одним запросом 08 16 30."""
                resp = send_and_recv(sock, build_packet(address, 0x08, bytes([0x16, 0x30])))
                if len(resp) >= 15:
                    s  = decode_cos_3bytes(resp[1:4])
                    p1 = decode_cos_3bytes(resp[4:7])
                    p2 = decode_cos_3bytes(resp[7:10])
                    p3 = decode_cos_3bytes(resp[10:13])
                    return (s, p1, p2, p3)
                return (0.0, 0.0, 0.0, 0.0)

            # P (BWRI=0x00), знак по биту 7 byte[0] = бит 23 после decode_3bytes_val
            p_sum, p1, p2, p3 = read_power_all_phases(0x00, sign_bit=23)
            result['total']['P'] = p_sum
            result['phases']['phase1']['P'] = p1
            result['phases']['phase2']['P'] = p2
            result['phases']['phase3']['P'] = p3
            
            # Q (BWRI=0x04), знак по биту 6 byte[0] = бит 22 после decode_3bytes_val
            q_sum, q1, q2, q3 = read_power_all_phases(0x04, sign_bit=22)
            result['total']['Q'] = q_sum
            result['phases']['phase1']['Q'] = q1
            result['phases']['phase2']['Q'] = q2
            result['phases']['phase3']['Q'] = q3

            # S (BWRI=0x08), без знака
            s_sum, s1, s2, s3 = read_power_all_phases(0x08, sign_bit=-1)
            result['total']['S'] = s_sum
            result['phases']['phase1']['S'] = s1
            result['phases']['phase2']['S'] = s2
            result['phases']['phase3']['S'] = s3

            # cos φ (BWRI=0x30)
            c_sum, c1, c2, c3 = read_cos_all_phases()
            result['total']['cos_phi'] = c_sum
            result['phases']['phase1']['cos_phi'] = c1
            result['phases']['phase2']['cos_phi'] = c2
            result['phases']['phase3']['cos_phi'] = c3

            # Закрытие сессии
            send_and_recv(sock, build_packet(address, 0x02))

    except Exception as e:
        print(f"Ошибка связи (векторная диаграмма): {e}")
        return None

    return result