import sys
import requests

def get_device_detail(url, device_name, headers={}):
    uri = f"https://{url}/api/.....= DeviceName eq '{device_name}'"
    payload = {}

    try:
        response = requests.get(uri, headers=headers, data=payload, verify=False)
        status_code = response.status_code

        if status_code == 200:
            response_data = response.json()
            data_value = response_data['value']
            dict_data = []
            data = {
                'Id': data_value[0]['Id'],
                'DeviceName': data_value[0]['DeviceName'],
                'Model': data_value[0]['Model'],
                'DeviceServiceTag': data_value[0]['DeviceServiceTag'],
                'NetworkAddress': data_value[0]['DeviceManagement'][0]['NetworkAddress'],
                'MacAddress': data_value[0]['DeviceManagement'][0]['MacAddress'],
                'AgentName': data_value[0]['DeviceManagement'][0]['ManagementProfile'][0]['AgentName']
            }
            dict_data.append(data)
            return dict_data
        else:
            print(f"{status_code}: Error occurred while fetching info about server {device_name} on OME {url}")
    except Exception as e:
        print(f"Error occurred while fetching info about server {device_name} on OME {url}: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py url device_name authorization_header")
        sys.exit(1)

    url = sys.argv[1]
    device_name = sys.argv[2]
    authorization_header = sys.argv[3]

    headers = {'Authorization': authorization_header}

    result = get_device_detail(url, device_name, headers=headers)
    print(result)
