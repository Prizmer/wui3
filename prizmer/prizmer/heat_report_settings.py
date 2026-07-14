# heat_report_settings.py
"""
Конфигурация статических параметров для отчёта "175. Месячный протокол учета тепловой энергии".
Значения, которых нет в БД (потребитель, адрес, ответственное лицо и т.д.).
"""

# Значения по умолчанию (используются, если для конкретного объекта не задано иное)
DEFAULT = {
    'consumer_name': 'ООО "Управляющая компания"',
    'consumer_address': 'г. Москва, ул. Примерная, д. 1',
    'abonent_name':'Неизвестный',
    'responsible_person': 'Иванов И.И.',
    'phone': '+7 (495) 123-45-67',
    
    # Параметры прибора (если не берутся из БД)
    'calculator_name': 'ТС-401-5-5-3-Е',
    'flow_supply': '0.64..160.00 м3/ч',
    'flow_supply_du': '100',
    'flow_return': '0.64..160.00 м3/ч',
    'flow_return_du': '100',
    'flow_loose': 'ротор 10.00 л/имп',
    'flow_loose_du': '20',   

    'report_day': '1',
    'report_time':'00:00'

}

# Переопределения для конкретных ПУ
# Ключ — meters.factory_number_manual
OVERRIDES = {
    '11821271': {
        'consumer_name': 'ООО "УК"',
        'consumer_address': 'г. Москва, ул. Примерная, д. 10',
        'responsible_person': 'Петров П.П.',
        'phone': '+7 (495) 987-65-43',
        'abonent_name':'Загадочный',
    },
    # Можно добавить сколько угодно записей
}


def get_config(meters=None):
    """
    Возвращает словарь параметров для отчёта.
    Берёт DEFAULT и накладывает сверху OVERRIDES по obj_title или obj_key.
    """
    config = DEFAULT.copy()
    
    # Ищем переопределение по obj_title
    if meters in OVERRIDES:
        config.update(OVERRIDES[meters])
        
    return config