Brief Explanation
The ABC Warranty Checker is a Python script designed to authenticate with the ABC AuthAPI and fetch warranty information for products using the ABC Warranty API. It provides functions to authenticate, convert serial numbers to base64 format, and check warranty details for a given serial number.

Dependencies
requests: For making HTTP requests to the ABC AuthAPI and Warranty API.
json: For parsing JSON responses from the APIs.
base64: For encoding serial numbers to base64 format.
datetime: For working with dates and times.
Components
1. warranty_auth()
This function authenticates with the ABC AuthAPI to obtain an access token required for accessing the warranty information.
2. convert_to_base64(serial_number)
This function converts a serial number to its base64 encoded format, which is required for querying the ABC Warranty API.
3. checkwarranty(serial_number)
This function checks the warranty information for a given serial number. It retrieves warranty details from the ABC Warranty API and returns a dictionary containing warranty information such as manufacturer, serial number, warranty start and end dates, and hardware support status.
Example Usage of Functions
python
Copy code
from warranty_checker import checkwarranty

# Example serial number
serial_number = "ABC123456789"

# Call checkwarranty function
warranty_info = checkwarranty(serial_number)

# Print warranty information
print(warranty_info)
Example Outputs of Each Function
warranty_auth()
Upon successful authentication, it returns the access token obtained from the ABC AuthAPI.
convert_to_base64(serial_number)
For a given serial number, it returns the base64 encoded string.
checkwarranty(serial_number)
For a given serial number, it returns a dictionary containing warranty information including manufacturer, serial number, warranty start and end dates, and hardware support status.
Logging and Authentication
Authentication with the ABC AuthAPI is done using the provided username, password, and client authentication key.
Logging is implemented using the logging module, capturing critical errors and successful operations.
