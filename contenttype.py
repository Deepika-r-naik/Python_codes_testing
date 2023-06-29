import requests
import json

def fetch_data(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        content_type = response.headers.get("Content-Type", "")
        if "application/json" in content_type:
            data = response.json()
            print(json.dumps(data, indent=4))  # Print data in JSON format
        else:
            print(f"Response content is not JSON. Content-Type: {content_type}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    fetch_data(url, headers=headers, params=params)

if __name__ == "__main__":
    main()
