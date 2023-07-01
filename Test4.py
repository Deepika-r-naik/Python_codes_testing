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


###########################################################################################
if "application/json" in content_type:
                data = response.json()
                if isinstance(data, list):
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
                    print("Data is not in the expected format.")
            else:
                print("Data is not in JSON format.")
        else:
            print(f"Request was not successful. Status code: {response.status_code}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")
##############################################################################################

            if "application/json" in content_type:
                data = response.json()
                print(json.dumps(data, indent=4))  # Print data in JSON format
            else:
                data = {}  # Create an empty dictionary to store the parsed data

                # Adjust the parsing logic to match your response text format
                # Example parsing logic:
                try:
                    json_data = json.loads(response_text)
                    if isinstance(json_data, dict):
                        attributes = json_data.get("attributes", {})
                        if attributes.get("state") != "Closed":
                            data = attributes
                    else:
                        print("Data is not in the expected format.")
                except json.JSONDecodeError:
                    print("Unable to parse response data as JSON.")

                if data:
                    print(json.dumps(data, indent=4))  # Print parsed data in JSON format
                    ticket_uri = data.get("uri")
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

