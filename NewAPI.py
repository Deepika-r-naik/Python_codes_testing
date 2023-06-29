import requests
import json

def fetch_case_details(case_id, headers={}):
    try:
        url = f"https://test/{case_id}"  # Update the URL to fetch case details for a specific case ID
        response = requests.get(url, headers=headers)
        response.raise_for_status()

        if response.status_code == 200:
            case_details = response.json()
            return case_details

        else:
            print(f"Request for case {case_id} was not successful. Status code: {response.status_code}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching case details for case {case_id}: {e}")

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

                    if state != 'canceled':  # Filter based on state not equal to 'canceled'
                        cases[case_id] = {
                            'state': state,
                            'uid': case.get('uid'),
                            'type': case.get('type'),
                            'machineModel': case.get('machineModel'),
                            'sourceIDURL': case.get('sourceIDURL'),
                            'groupName': case.get('groupName'),
                            'componentIDURL': case.get('componentIDURL'),
                            'deviceUUID': case.get('deviceUUID'),
                            'createdDate': case.get('createdDate'),
                            'ticketType': case.get('ticketType'),
                            'componentID': case.get('componentID'),
                            'serialNumber': case.get('serialNumber'),
                            'eventID': case.get('eventID'),
                            'details': {}  # Placeholder for case details
                        }

            else:
                print("Response data is not a list.")

            # Fetch and store case details for each case
            for case_id in cases.keys():
                case_details = fetch_case_details(case_id, headers=headers)
                if case_details is not None:
                    cases[case_id]['details'] = case_details

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
    print(json.dumps(cases, indent=None))  # Print the dictionary of cases without numerical indices

if __name__ == "__main__":
    main()
