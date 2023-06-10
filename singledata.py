import requests

def fetch_data(url, identifier, headers={}, params={}):
    try:
        url = f"{url}/{identifier}"
        response = requests.get(url, headers=headers, params=params, verify=False)
        response.raise_for_status()

        if response.status_code == 200:
            data = response.text
            print(data)  # Print data as plain text
        else:
            print(f"Request was not successful. Status code: {response.status_code}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}
    identifier = '123456'  # Replace with the specific identifier you want to fetch

    fetch_data(url, identifier, headers=headers, params=params)

if __name__ == "__main__":
    main()
