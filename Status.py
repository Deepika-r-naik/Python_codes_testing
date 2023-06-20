#filtering the service tickets by their state not equal to Canceled
import requests

def fetch_data(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        uids = []  # Create an empty list to store the uids

        if response.status_code == 200:
            data = response.json()

            if isinstance(data, list):
                for item in data:
                    uid = item.get('uid')
                    state = item.get('state')

                    if state != 'canceled':  # Filter based on state not equal to 'canceled'
                        uids.append(uid)  # Append uid to the list

            else:
                print("Response data is not a list.")

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

        return uids  # Return the list of uids

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    uids = fetch_data(url, headers=headers, params=params)
    print(uids)  # Print the list of uids

if __name__ == "__main__":
    main()
