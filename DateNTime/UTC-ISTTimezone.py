from datetime import datetime, timedelta
import requests

def fetch_single_detail():
    url = 'https://api.example.com/detail'  # Replace this with your API endpoint
    headers = {'Authorization': 'Bearer YOUR_ACCESS_TOKEN'}  # Include your authorization header if needed

    try:
        response = requests.get(url, headers=headers, verify=False)
        if response.status_code == 200:
            data = response.json()

            temp = {"Patch_Window": "", "Next_Patch": "", "UTC_TimeZone": "", "IST_TimeZone": ""}
            if "patchgroup" in data:
                temp["Patch_Window"] = data["patchgroup"]
            if "next_patch" in data:
                temp["Next_Patch"] = data["next_patch"]

                # Convert Next Patch time to UTC (+5:30 hours) and IST (+11:00 hours)
                next_patch_time = data["next_patch"]
                temp["UTC_TimeZone"] = convert_to_timezone(next_patch_time, hours=5, minutes=30)
                temp["IST_TimeZone"] = convert_to_timezone(next_patch_time, hours=11, minutes=0)

            return temp
        else:
            print(f"Failed to fetch data. Status code: {response.status_code}")
            return None
    except requests.RequestException as e:
        print(f"Request Exception: {e}")
        return None

def convert_to_timezone(time_string, hours, minutes):
    original_time = datetime.strptime(time_string, '%Y-%m-%d %H:%M')  
    converted_time = original_time + timedelta(hours=hours, minutes=minutes)
    return converted_time.strftime('%Y-%m-%d %H:%M')

temp = fetch_single_detail()
if temp:
    print(temp)
else:
    print("Failed to extract temp dictionary.")
