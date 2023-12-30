import requests
from datetime import datetime, timedelta

def fetch_patch_details(server_list):
    for server in server_list:
        # Fetch patch details from API for each server
        patch_details = requests.get(f"https://api.example.com/patch_details/{server}")
        if patch_details.status_code == 200:
            patch_data = patch_details.json()
            
            # Extract patch date and time
            patch_date_time = patch_data.get('patch_date_time')
            if patch_date_time:
                # Convert patch date time to UTC
                utc_time = convert_to_utc(patch_date_time)
                
                # Convert patch date time to IST
                ist_time = convert_to_ist(patch_date_time)
                
                # Save UTC and IST times separately
                save_to_database(server, utc_time, ist_time)
            else:
                print(f"No patch date and time found for {server}")
        else:
            print(f"Failed to fetch patch details for {server}")

def convert_to_utc(time_string):
    utc_datetime = datetime.strptime(time_string, '%Y-%m-%d %H:%M:%S')  # Assuming date time format
    utc_datetime = utc_datetime - timedelta(hours=5, minutes=30)  # Subtract 5 hours 30 minutes for IST to get UTC
    return utc_datetime.strftime('%Y-%m-%d %H:%M:%S')

def convert_to_ist(time_string):
    ist_datetime = datetime.strptime(time_string, '%Y-%m-%d %H:%M:%S')  # Assuming date time format
    ist_datetime = ist_datetime + timedelta(hours=5, minutes=30)  # Add 5 hours 30 minutes for IST
    return ist_datetime.strftime('%Y-%m-%d %H:%M:%S')

def save_to_database(server, utc_time, ist_time):
    # You can implement the logic to save the times to your database here
    # For example:
    print(f"Server: {server}, UTC Time: {utc_time}, IST Time: {ist_time}")
    # Replace the print statement with your database saving logic

# Usage:
servers = ["server1", "server2", "server3"]  # List of server names
fetch_patch_details(servers)
