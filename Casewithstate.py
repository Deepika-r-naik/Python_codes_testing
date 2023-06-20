#To store the UIDs along with their corresponding states in a list, you can modify the uids list to hold tuples containing the UID and its corresponding state. Each tuple can be constructed using the uid and state variables.


import requests

def fetch_data(url, headers={}, params={}):
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

                    if state != 'canceled':  # Filter based on state not equal to 'canceled'
                        uid_states.append((uid, state))  # Append UID-state tuple to the list

            else:
                print("Response data is not a list.")

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

        return uid_states  # Return the list of UID-state tuples

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    uid_states = fetch_data(url, headers=headers, params=params)
    print(uid_states)  # Print the list of UID-state tuples

if __name__ == "__main__":
    main()
