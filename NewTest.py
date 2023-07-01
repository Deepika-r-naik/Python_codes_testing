import requests

def fetch_data(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        if response.status_code == 200:
            data = response.json()
            print(json.dumps(data, indent=4))  # Print data in JSON format
        else:
            print(f"Request was not successful. Status code: {response.status_code}")

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
