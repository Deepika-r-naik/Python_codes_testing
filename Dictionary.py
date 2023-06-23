import requests

def fetch_data():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        cases = []  # Create an empty list to store case dictionaries
        uri = None  # Initialize uri as None

        if response.status_code == 200:
            result = response.json()
            case_list = result['value']
            cases_count = len(case_list)

            for i in range(cases_count):
                if case_list[i]['state'] != 'canceled':
                    cases.append({
                        'uid': case_list[i]['id'],
                        'msg': case_list[i]['msg'],
                        'status': case_list[i]['status']
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
