import requests

def fetch_data():
    url = "https://test"
    headers = {'Authorization': 'Basic ..’……….}
    params = {}

    try:
        response = requests.get(url, headers=headers, params=params, verify=False)
        response.raise_for_status()

        if response.status_code == 200:
            response_data = response.json()
            open_tickets = [
                {"id": ticket["id"], "state": ticket["state"]}
                for ticket in response_data.get("results", [])
                if ticket.get("state") != "Closed"
            ]
            for ticket in open_tickets:
                keys = ticket.keys()
                for key in keys:
                    print('{key}:\t{value}'.format(
                        key=key,
                        value=ticket[key]
                    ))
            return open_tickets
        else:
            print("Error: Unable to fetch data from the API")
            return []
    except Exception as e:
        print(f"Error occurred while fetching the count of cases on OME: {e}")

def main():
    fetch_data()

main()
