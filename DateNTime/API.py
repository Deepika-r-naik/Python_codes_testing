def fetch_single_detail():
    url = 'https://api.example.com/detail'  # Replace this with your API endpoint
    headers = {'Authorization': 'Bearer YOUR_ACCESS_TOKEN'}  # Include your authorization header if needed

    try:
        response = requests.get(url, headers=headers)
        if response.status_code == 200:  # Check if the request was successful
            data = response.json()  # Assuming the response is in JSON format
            
            # Extracting specific keys from the API response to form the 'temp' dictionary
            temp = {
                "Patch_Window": data.get("Patch_Window", ""),
                "Next_Patch": data.get("Next_Patch", ""),
                # Add other required keys similarly
            }
            return temp
        else:
            print(f"Failed to fetch data. Status code: {response.status_code}")
            return None
    except requests.RequestException as e:
        print(f"Request Exception: {e}")
        return None

# Call the function to fetch detail and display 'temp' dictionary
temp = fetch_single_detail()
if temp:
    print("Extracted temp dictionary:")
    print(temp)
else:
    print("Failed to extract temp dictionary.")
