import json
import requests

def getNextPatchWindowSub(fqdn, res_ob):
    sdi_user = config.get("app_config", "sdi_user")
    sdi_pw = config.get("app.config", "sdi_pw")
    response = requests.get("api_endpoint/" + fqdn, verify=False, auth=(sdi_user, sdi_pw), timeout=10)
    
    if response.status_code == 200:
        response_data = response.json()
        temp = {"Patch_Window": "", "Next_Patch": "", "UTC_TimeZone": "", "IST_TimeZone": ""}

        if "Patchgroup" in response_data:
            # Convert Patch Window time to UTC (+11:30 hours)
            patch_window = response_data["Patchgroup"]
            temp["Patch_Window"] = convert_to_timezone(patch_window, hours=11, minutes=30)

        if "next_patch" in response_data:
            # Convert Next Patch time to UTC (+5:30 hours)
            next_patch = response_data["next_patch"]
            temp["Next_Patch"] = convert_to_timezone(next_patch, hours=5, minutes=30)

        res_ob.append(temp)
    else:
        print(f"Failed to fetch data for {fqdn}. Status code: {response.status_code}")

def convert_to_timezone(time_string, hours, minutes):
    original_time = datetime.strptime(time_string, '%Y-%m-%dT%H:%M:%S')  # Adjust format accordingly
    converted_time = original_time + timedelta(hours=hours, minutes=minutes)
    return converted_time.strftime('%Y-%m-%dT%H:%M:%S')  # Return in desired format

# Usage example:
result_objects = []
fqdn_to_check = "AAAA"
getNextPatchWindowSub(fqdn_to_check, result_objects)
print(result_objects)


# Existing code...

# Define res_ob list
res_ob = []

# Call the function for a specific fqdn
fqdn_to_check = "AAAA"
getNextPatchWindowSub(fqdn_to_check, res_ob)

# Display the results
print(res_ob)
