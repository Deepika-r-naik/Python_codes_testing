import requests
import json

def fetch_data(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        if response.status_code == 200:
            content_type = response.headers.get("Content-Type", "")
            if "application/json" in content_type:
                data = response.json()
                filtered_data = [ticket for ticket in data if ticket.get("state") != "Closed"]
                print(json.dumps(filtered_data, indent=4))  # Print filtered data in JSON format
                
                for ticket in filtered_data:
                    ticket_uri = ticket.get("uri")
                    if ticket_uri:
                        ticket_details = requests.get(ticket_uri, headers=headers)
                        if ticket_details.status_code == 200:
                            ticket_data = ticket_details.json()
                            print(json.dumps(ticket_data, indent=4))  # Print ticket details in JSON format
                        else:
                            print(f"Failed to retrieve ticket details. Status code: {ticket_details.status_code}")
                    else:
                        print("Ticket URI not found.")
            else:
                response_text = response.text
                data = {}

                # Adjust the parsing logic to match your response text format
                json_data = json.loads(response_text)
                filtered_data = [ticket for ticket in json_data.values() if ticket != "Closed"]
                print(json.dumps(filtered_data, indent=4))  # Print filtered data in JSON format

                for ticket in filtered_data:
                    ticket_uri = ticket.get("uri")
                    if ticket_uri:
                        ticket_details = requests.get(ticket_uri, headers=headers)
                        if ticket_details.status_code == 200:
                            ticket_data = ticket_details.json()
                            print(json.dumps(ticket_data, indent=4))  # Print ticket details in JSON format
                        else:
                            print(f"Failed to retrieve ticket details. Status code: {ticket_details.status_code}")
                    else:
                        print("Ticket URI not found.")

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    fetch_data(url, headers=headers, params=params)

if __name__ == "__main__":
    main()
