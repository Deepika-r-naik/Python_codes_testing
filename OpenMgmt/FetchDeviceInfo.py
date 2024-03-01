import requests

def get_device_count(api_url):
    response = requests.get(api_url)

    if response.status_code == 200:
        return response.json().get('@odaa.count')  # Adjust the key based on the actual API response
    else:
        print(f"Error fetching device count. Status code: {response.status_code}")
        return None

def fetch_devices(api_url, offset, limit):
    params = {
        'offset': offset,
        'limit': limit
        # Add any other required parameters
    }

    response = requests.get(api_url, params=params)

    if response.status_code == 200:
        return response.json().get('devices', [])
    else:
        print(f"Error fetching devices. Status code: {response.status_code}")
        return []

def get_all_devices_info(api_url, batch_size=100):
    total_device_count = get_device_count(api_url)

    if total_device_count is None:
        print("Unable to fetch device count. Exiting.")
        return []

    offset = 0
    all_devices_info = []

    while offset < total_device_count:
        devices_in_batch = fetch_devices(api_url, offset, batch_size)
        all_devices_info.extend(devices_in_batch)
        offset += batch_size

    return all_devices_info

# Replace 'your_api_endpoint' with the actual URL for fetching devices
api_endpoint = 'your_api_endpoint'

# Get all device information
all_devices_info = get_all_devices_info(api_endpoint)

# Process all device information
for device_info in all_devices_info:
    print(f"Device Info: {device_info}")
