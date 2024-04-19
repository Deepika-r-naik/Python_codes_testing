import base64
import json
import requests
from datetime import datetime, timezone

def warranty_auth():
    """
    Authenticate with the ABC AuthAPI to obtain an access token.

    Returns:
        str: The access token obtained upon successful authentication.
    """
    auth_url = f"{config['ABC_AUTH_URI']}?username={parse_credentials.ABC_UCS_USERNAME}&Password={parse_credentials.ABC_UCS_PASSWORD}&grant_type=password"
    headers = {"content_Type": "Application/json", "Authorization": parese_credentials.ABC_UCS_AUTH_KEY}
    payload = json.dumps({"name": "Add your name in the body"})
    log.info("Trying to authenticate with the ABC AuthAPI.")
    try:
        response = requests.post(auth_url, headers=headers, data=payload, verify=False)
        status_code = response.status_code
        if status_code == 200:
            log.info("Successfully Authenticated with the ABC AuthAPI.")
            response_data = response.json()
            return response_data["result"]["access_token"]
        else:
            log.critical(f"{status_code}: Error generating auth token for ABC AuthAPI")
    except Exception as e:
        log.critical("Error generating auth token for ABC AuthAPI")

def convert_to_base64(serial_number):
    """
    Convert a serial number to its base64 encoded format.

    Args:
        serial_number (str): The serial number to be converted.

    Returns:
        str: The base64 encoded serial number.
    """
    encoded_string = f"sn={serial_number}"
    base64servicetag = base64.b64encode(encoded_string.encode("utf-8")).decode("utf-8")
    return base64servicetag

def checkwarranty(serial_number):
    """
    Check warranty information for a given serial number.

    Args:
        serial_number (str): The serial number for which warranty information is to be checked.

    Returns:
        dict: A dictionary containing warranty information.
    """
    servicetag = convert_to_base64(serial_number)
    authtoken = warranty_auth()
    warranty_url = f"{config['ASUS_Warranty_API']}{servicetag}"
    payload = {}
    headers = {"Authorization": f"Bearer {authtoken}"}
    try:
        warranty_info = {"manufacturer": "ABC", "SerialNumber": "", "WarrantyStartDate": "", "WarrantyEndDate": "", "underWarranty": "", "hardware_support": ""}
        response = requests.get(warranty_url, headers=headers, data=payload, verify=False)
        status_code = response.status_code
        if status_code == 200:
            result = response.json()
            log.info(f"Fetching the warranty details for ABC server with the serial number - {serial_number}")
            warranty_info["serialnumber"] = result["result"]["serviceInfo"]["productSn"]
            warranty_info["warrantyStartDate"] = datetime.strptime(result["result"]["partWarrantyInfo"]["standardWarrantyStart"], "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=timezone.utc)
            warranty_info["warrantyEndDate"] = datetime.strptime(result["result"]["partWarrantyInfo"]["standardWarrantyEnd"], "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=timezone.utc)
            current_date = datetime.now(timezone.utc)
            if current_date < warranty_info["warrantyEndDate"]:
                warranty_info["under_warranty"] = True
                warranty_info["hardware_support"] = "ASUS"
            else:
                warranty_info["under_warranty"] = False
                warranty_info["hardware_support"] = "Parkplace"
            log.info(f"{status_code} Successfully able to fetch the warranty details for ASUS server with the Serial number - {serial_number}")
            return warranty_info
    except Exception as e:
        log.critical(f"Error fetching warranty details for ASUS server with the Serial number - {serial_number}")
