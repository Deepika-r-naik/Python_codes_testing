import requests

def fetch_ticket_details(url, headers={}, params={}):
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        if response.status_code == 200:
            data = response.json()
            tickets = data['result']
            ticket_details = []

            for ticket in tickets:
                if ticket['state'] != 'Closed':
                    ticket_id = ticket['id']
                    ticket_info = fetch_ticket_info(ticket_id, url, headers=headers, params=params)
                    ticket_details.append(ticket_info)

            return ticket_details

        else:
            print(f"Request was not successful. Status code: {response.status_code}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

    return []

def fetch_ticket_info(ticket_id, url, headers={}, params={}):
    # Make API call or perform necessary operations to fetch ticket details by ticket ID
    # Return the specific ticket details as a dictionary
    ticket_info = {
        'ticket_id': ticket_id,
        # Add other ticket attributes you want to include
    }

    # Access other ticket attributes as needed
    print(f"Ticket ID: {ticket_id}")
    print(ticket_info)
    print()

    return ticket_info

def main():
    url = "https://test"
    headers = {'Authorization': 'Basic .........'}
    params = {'param1': 'value1', 'param2': 'value2'}

    ticket_details = fetch_ticket_details(url, headers=headers, params=params)

if __name__ == "__main__":
    main()
