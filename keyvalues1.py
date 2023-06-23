import requests

def fetch_data():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        uid_states = []  # Create an empty list to store UID-state tuples

        if response.status_code == 200:
            data = response.json()

            if isinstance(data, list):
                for item in data:
                    uid = item.get('uid')
                    state = item.get('state')
                    uid_states.append((uid, state))  # Append UID-state tuple to the list

                    # Print key values of the item
                    for key, value in item.items():
                        print(f"Key: {key}, Value: {value}")

            else:
                print("Response data is not a list.")

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

        return uid_states  # Return the list of UID-state tuples

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    uid_states = fetch_data()
    print(uid_states)  # Print the list of UID-state tuples

if __name__ == "__main__":
    main()


#################################################

import requests

def fetch_data():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        cases = []  # Create an empty list to store case dictionaries
        uri = url
        result = None

        if response.status_code == 200:
            result = response.json()

            # Access keys
            keys = result.keys()
            print("Keys:")
            for key in keys:
                print(key)

            # Access values
            values = result.values()
            print("Values:")
            for value in values:
                print(value)

            # Process case data
            case_list = result.get('value')
            if isinstance(case_list, list):
                for item in case_list:
                    uid = item.get('uid')
                    state = item.get('state')

                    if state != 'canceled':
                        cases.append({
                            'uid': uid,
                            'msg': item.get('msg'),
                            'status': item.get('status')
                        })

            if "@odata.nextLink" in result.keys():
                uri = f"https://{ome_instance}" + result['@odata.nextLink']

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

        return cases, uri, result

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    cases, uri, result = fetch_data()
    print("Cases:")
    for case in cases:
        print(case)
    print("URI:", uri)
    print("Result:", result)

if __name__ == "__main__":
    main()
#############################################################

import requests

def fetch_data():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        cases = []  # Create an empty list to store case dictionaries
        uri = url
        result = None

        if response.status_code == 200:
            result = response.json()

            # Extract values from result
            group_uuid = result.get('groupUUID')
            serial_number = result.get('serialNumber')
            component_id = result.get('componentID')
            ticket_type = result.get('ticketType')
            case_type = result.get('Type')
            state = result.get('state')

            if state != 'canceled':
                cases.append({
                    'groupUUID': group_uuid,
                    'serialNumber': serial_number,
                    'componentID': component_id,
                    'ticketType': ticket_type,
                    'Type': case_type,
                    'state': state
                })

            if "@odata.nextLink" in result.keys():
                uri = f"https://{ome_instance}" + result['@odata.nextLink']

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

        return cases, uri

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    cases, uri = fetch_data()
    print("Cases:")
    for case in cases:
        print(case)
    print("URI:", uri)

if __name__ == "__main__":
    main()
####################################

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        cases = []  # Create an empty list to store case dictionaries
        uri = url
        result = None

        if response.status_code == 200:
            try:
                result = response.json()
            except ValueError:
                print("Invalid JSON response.")
                return cases, uri

            if isinstance(result, dict):
                # Extract values from result
                group_uuid = result.get('groupUUID')
                serial_number = result.get('serialNumber')
                component_id = result.get('componentID')
                ticket_type = result.get('ticketType')
                case_type = result.get('Type')
                state = result.get('state')

                if state != 'canceled':
                    cases.append({
                        'groupUUID': group_uuid,
                        'serialNumber': serial_number,
                        'componentID': component_id,
                        'ticketType': ticket_type,
                        'Type': case_type,
                        'state': state
                    })

                if "@odata.nextLink" in result.keys():
                    uri = f"https://{ome_instance}" + result['@odata.nextLink']

            else:
                print("Response data is not a dictionary.")

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

        return cases, uri

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    cases, uri = fetch_data()
    print("Cases:")
    for case in cases:
        print(case)
    print("URI:", uri)

if __name__ == "__main__":
    main()
#########################################################################

import requests

def fetch_data(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        cases = {}  # Create an empty dictionary to store the cases

        if response.status_code == 200:
            data = response.json()

            if isinstance(data, list):
                for case in data:
                    case_id = case.get('id')
                    state = case.get('state')
                    uid = case.get('uid')
                    case_type = case.get('type')
                    machine_model = case.get('machineModel')
                    source_id_url = case.get('sourceIDURL')
                    group_name = case.get('groupName')
                    component_id_url = case.get('componentIDURL')
                    device_uuid = case.get('deviceUUID')
                    created_date = case.get('createdDate')
                    ticket_type = case.get('ticketType')
                    component_id = case.get('componentID')
                    serial_number = case.get('serialNumber')
                    event_id = case.get('eventID')

                    if state != 'canceled':  # Filter based on state not equal to 'canceled'
                        cases[case_id] = {
                            'state': state,
                            'uid': uid,
                            'type': case_type,
                            'machineModel': machine_model,
                            'sourceIDURL': source_id_url,
                            'groupName': group_name,
                            'componentIDURL': component_id_url,
                            'deviceUUID': device_uuid,
                            'createdDate': created_date,
                            'ticketType': ticket_type,
                            'componentID': component_id,
                            'serialNumber': serial_number,
                            'eventID': event_id
                        }

            else:
                print("Response data is not a list.")

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

        return cases  # Return the dictionary of cases

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    cases = fetch_data(url, headers=headers, params=params)
    print(cases)  # Print the dictionary of cases

if __name__ == "__main__":
    main()

###########################################################################

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        cases = {}  # Create an empty dictionary to store the cases

        if response.status_code == 200:
            data = response.json()

            if isinstance(data, list):
                for case in data:
                    case_id = case.get('id')
                    state = case.get('state')
                    uid = case.get('uid')
                    case_type = case.get('type')
                    machine_model = case.get('machineModel')
                    source_id_url = case.get('sourceIDURL')
                    group_name = case.get('groupName')
                    component_id_url = case.get('componentIDURL')
                    device_uuid = case.get('deviceUUID')
                    created_date = case.get('createdDate')
                    ticket_type = case.get('ticketType')
                    component_id = case.get('componentID')
                    serial_number = case.get('serialNumber')
                    event_id = case.get('eventID')

                    if state != 'canceled':  # Filter based on state not equal to 'canceled'
                        cases[case_id] = {
                            'state': state,
                            'uid': uid,
                            'type': case_type,
                            'machineModel': machine_model,
                            'sourceIDURL': source_id_url,
                            'groupName': group_name,
                            'componentIDURL': component_id_url,
                            'deviceUUID': device_uuid,
                            'createdDate': created_date,
                            'ticketType': ticket_type,
                            'componentID': component_id,
                            'serialNumber': serial_number,
                            'eventID': event_id
                        }

            else:
                print("Response data is not a list.")

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

        return cases  # Return the dictionary of cases

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    cases = fetch_data(url, headers=headers, params=params)
    print(cases)  # Print the dictionary of cases

if __name__ == "__main__":
    main()
