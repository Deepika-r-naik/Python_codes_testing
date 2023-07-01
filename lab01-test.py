import requests

def fetch_ticket_details(management_server_IP):
    # Fetch ticket details from the first API endpoint
    tickets_url = f"https://{management_server_IP}/service/tickets"
    response = requests.get(tickets_url)
    tickets_data = response.json()

    # Store ticket details in a dictionary
    ticket_details = {}

    for ticket in tickets_data:
        ticket_id = ticket['ticketID']
        ticket_status = ticket['status']

        # Check if the ticket status is not equal to 'closed'
        if ticket_status != 'closed':
            # Fetch additional ticket details using the second API endpoint
            ticket_url = f"https://{management_server_IP}/service/tickets/{ticket_id}"
            response = requests.get(ticket_url)
            additional_ticket_details = response.json()

            # Store additional ticket details in the dictionary
            ticket_details[ticket_id] = additional_ticket_details

    return ticket_details

############################################################

    ticket_info = {
        'ticket_id': ticket_id,
        # Add other ticket attributes you want to include
    }

    # Access other ticket attributes as needed
    print(f"Ticket ID: {ticket_id}")
    print(ticket_info)
    print()

    return ticket_info
