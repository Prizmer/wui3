import sys
import time

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
        print(f"Канал связи с {addr} не открыт")
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
        print(f"Канал связи с {addr} не открыт")
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
        print(f"Канал связи с {addr} не открыт")
        return ''

def set_active_power_limit(sock, net_address, active_power_limit):
    """Запрос на установку лимита активной мощности"""
    if open_link(sock, net_address):
        command = SET_ACTIVE_POWER_LIMIT
        number_hex = "%02X" % net_address
        active_power_limit = active_power_limit
        cmd_without_crc = number_hex + command + active_power_limit
        request = cmd_without_crc + calc_crc_modbus(bytes.fromhex(cmd_without_crc))
        sock.sendall(bytes.fromhex(request))
        time.sleep(DELAY_WAIT_DATA)
        received = (sock.recv(80).hex())
    else:
        #print(f"Канал с прибором {net_address} не открыт")
        return ''

    if len(received) == 8:
        return "Успешная установка лимита мощности"            
    else:
        print(f"Канал связи с {addr} не открыт")
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
        print(f"Канал связи с {addr} не открыт")
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
        print(f"Канал связи с {addr} не открыт")
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
        print(f"Канал связи с {addr} не открыт")
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
        print(f"Канал связи с {addr} не открыт")
        return ''
