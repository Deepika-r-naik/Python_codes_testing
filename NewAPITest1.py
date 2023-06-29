import requests

def fetch_data(case_id):
    url = f"https://test/{case_id}"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        if response.status_code == 200:
            data = response.json()
            return data  # Return the fetched data

        else:
            print(f"Request for case ID {case_id} was not successful. Status code: {response.status_code}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data for case ID {case_id}: {e}")

def main():
    uid_states = fetch_data()
    case_ids = []

    for uid, state in uid_states:
        if state != 'canceled':
            case_ids.append(uid)  # Store the case ID in the list

    fetched_data = {}

    for case_id in case_ids:
        data = fetch_data(case_id)
        fetched_data[case_id] = data

    print(fetched_data)  # Print the dictionary of fetched data

if __name__ == "__main__":
    main()


################################## Key Values filter###############################

import requests

def fetch_data(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        content_type = response.headers.get("Content-Type", "")
        if "application/json" in content_type:
            data = response.json()
            print(json.dumps(data, indent=4))  # Print data in JSON format
        else:
            response_text = response.text
            data = {}

            # Adjust the parsing logic to match your response text format
            json_data = json.loads(response_text)
            metadata = json_data.get("_metadata", {})
            attributes = metadata.get("attributes", {})

            for key, value in attributes.items():
                if key in ["PmrUID", "state", "PMRType", "eventID", "sourceName", "componentName"]:
                    data[key] = value

            print(data)

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    fetch_data(url, headers=headers, params=params)

if __name__ == "__main__":
    main()



#####################################################################

import requests

def fetch_data(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        content_type = response.headers.get("Content-Type", "")
        if "application/json" in content_type:
            data = response.json()
            print(json.dumps(data, indent=4))  # Print data in JSON format
        else:
            response_text = response.text
            data = {}

            # Example: Parsing text in the format "key1:value1, key2:value2, key3:value3"
            pairs = response_text.split(", ")
            for pair in pairs:
                key, value = pair.split(":")
                data[key] = value

            print(data)

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    fetch_data(url, headers=headers, params=params)

if __name__ == "__main__":
    main()
#################################################### Parsing text format to Json and then storing values in dictionary


import requests

def fetch_data(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        content_type = response.headers.get("Content-Type", "")
        if "application/json" in content_type:
            data = response.json()
            print(json.dumps(data, indent=4))  # Print data in JSON format
        else:
            response_text = response.text
            data = {}

            # Adjust the parsing logic to match your response text format
            # Example: Parsing text in the format "PmrUID:value1, state:value2, PMRType:value3, eventID:value4, sourceName:value5, componentName:value6"
            pairs = response_text.split(", ")
            for pair in pairs:
                key, value = pair.split(":")
                # Check if the key is one of the specified attributes
                if key in ["PmrUID", "state", "PMRType", "eventID", "sourceName", "componentName"]:
                    data[key] = value

            print(data)

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    fetch_data(url, headers=headers, params=params)

if __name__ == "__main__":
    main()

