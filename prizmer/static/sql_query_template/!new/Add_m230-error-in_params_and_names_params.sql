INSERT INTO names_params(
            guid, name, guid_measurement, guid_resources)
    VALUES ('4d6bb331-7266-481d-9256-741850dd1518', 'Error_code', 'a3bf7d60-2b8e-43fc-aae0-c1c66106d660', 
    'ba710cff-e390-48ca-b442-70141c9864f7')

INSERT INTO params(
            guid, param_address, channel, guid_names_params, guid_types_meters, 
            guid_types_params, name)
    VALUES ('7175f6c7-b816-40f6-86f4-e08a309c08f6', 99, 0, '4d6bb331-7266-481d-9256-741850dd1518',
     '423b33a7-2d68-47b6-b4f6-5b470aedc4f4', '3242af58-ba57-4d8b-83fa-284bd8f4bd9b', 
     'Меркурий 230 Error_code Текущий -- adress: 99  channel: 0')

