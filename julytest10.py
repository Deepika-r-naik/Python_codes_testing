import requests

# Make API call to fetch ticket details
response = requests.get('https://api.example.com/tickets')

# Check if the API call was successful
if response.status_code == 200:
    # Convert the response JSON to a dictionary
    response_data = response.json()

    # Get the list of tickets from the "results" key
    tickets = response_data["results"]

    # Extract specific attributes from tickets
    extracted_tickets = []
    for ticket in tickets:
        extracted_ticket = {
            "id": ticket["id"],
            "eventID": ticket["eventID"],
            "componentName": ticket["componentName"],
            "createDate": ticket["createDate"],
            "PmrUID": ticket["PmrUID"],
            "state": ticket["state"],
            "ticketType": ticket["ticketType"],
            "PMRType": ticket["PMRType"]
        }
        extracted_tickets.append(extracted_ticket)

    # Perform further operations on the extracted_tickets
    # ...

else:
    print('Failed to fetch ticket details. Status code:', response.status_code)

###Create a dictionary with specific attributes

    filtered_tickets = {}
    for ticket in tickets:
        filtered_ticket = {
            "id": ticket["id"],
            "eventID": ticket["eventID"],
            "componentName": ticket["componentName"],
            "createDate": ticket["createDate"],
            "PmrUID": ticket["PmrUID"],
            "state": ticket["state"],
            "ticketType": ticket["ticketType"],
            "PMRType": ticket["PMRType"]
        }
        filtered_tickets[ticket["id"]] = filtered_ticket


##############################

import requests

def fetch_open_tickets(api_url, headers=None, params=None):
    response = requests.get(api_url, headers=headers, params=params)
    if response.status_code == 200:
        data = response.json()
        open_tickets = []
        for ticket in data["results"]:
            if ticket["state"] != "Closed":
                open_ticket = {
                    "PmrUID": ticket["PmrUID"],
                    "id": ticket["id"],
                    "state": ticket["state"]
                }
                open_tickets.append(open_ticket)
        return open_tickets
    else:
        print("Error: Unable to fetch data from the API")
        return []

def main():
    api_url = "https://example.com/api/tickets"
    headers = {
        "Authorization": "Bearer <your_token>"
    }
    params = {
        "param1": "value1",
        "param2": "value2"
    }

    open_tickets = fetch_open_tickets(api_url, headers=headers, params=params)
    for ticket in open_tickets:
        print(ticket)

if __name__ == "__main__":
    main()

