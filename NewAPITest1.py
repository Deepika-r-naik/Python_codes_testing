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
