def getDeviceDetail(ome_instance, deviceName):
    token = authentication(url)
    uri = f"https://{url}/api/.....= DeviceName eq '{deviceName}'"
    payload={}
    headers = {
        'content-type': 'application/json', 'X-Auth-Token': token
        }
    
    try:
        response = requests.request("GET", uri, headers=headers, data=payload, verify=False)
        status_code = response.status_code

        if status_code == 200:
            response_data = response.json()
            data_value = response_data['value']
            dict_data = []
            data = {'Id': data_value[0]['Id'], 'DeviceName': data_value[0]['DeviceName'], 'Model': data_value[0]['Model'],
                'DeviceServiceTag': data_value[0]['DeviceServiceTag'], 'NetworkAddress': data_value[0]['DeviceManagement'][0]['NetworkAddress'],
                'MacAddress': data_value[0]['DeviceManagement'][0]['MacAddress'], 'AgentName': data_value[0]['DeviceManagement'][0]['ManagementProfile'][0]['AgentName']}
            #print(data_value)
            dict_data.append(data)
            return dict_data
        else:
            log.critical(f"{status_code}: Error occured while fetching info about server {deviceName} on OME {ome_instance}")
    except Exception as e:
        log.critical(f"Error occured while fetching info about server {deviceName} on OME {ome_instance} : {e}")
