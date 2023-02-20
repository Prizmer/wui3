import libscrc


def calc_serial(raw_data):
    """Получаем серийный номер в виде десятичного числа из запроса"""
    ser_number = raw_data[2:10]

    byte_1 = ser_number[:2]
    part_1 = '{:02d}'.format((int(byte_1, 16)))

    byte_2 = ser_number[2:4]
    part_2 = '{:02d}'.format((int(byte_2, 16)))

    byte_3 = ser_number[4:6]
    part_3 = '{:02d}'.format((int(byte_3, 16)))

    byte_4 = ser_number[6:]
    part_4 = '{:02d}'.format((int(byte_4, 16)))

    return int(part_1+part_2+part_3+part_4)

def calc_energy_daily(raw_data):
    """ Получаем значения накопленной энергии на начало суток по сумме тарифов"""
    data = raw_data[2:-4]
    # A+
    energy_daily_t0_a_plus_raw = data[:8]
    n = 2
    energy_bytes = [energy_daily_t0_a_plus_raw[i:i+n] for i in range(0, len(energy_daily_t0_a_plus_raw), n)]
    energy_daily_t0_a_plus_shift = energy_bytes[1] + energy_bytes[0] + energy_bytes[3] + energy_bytes[2]
    energy_daily_t0_a_plus = int(energy_daily_t0_a_plus_shift, 16) * 0.001 # кВт*ч
    return energy_daily_t0_a_plus

def calc_crc_modbus(cmd_without_crc_bytes):
    crc = libscrc.modbus(cmd_without_crc_bytes)
    crc = hex(crc)[2:6]
    if len(crc) == 2:
        crc = '00' + crc
    if len(crc) == 3:
        crc = '0' + crc
    return (crc)[2:4].upper() + (crc)[0:2].upper()