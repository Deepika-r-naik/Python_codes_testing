import requests
from datetime import datetime, timezone
import logging

log = logging.getLogger(__name__)

def checkwarranty(serial_number):
    """
    Check warranty information for a given serial number.

    Args:
        serial_number (str): The serial number for which warranty information is to be checked.

    Returns:
        dict: A dictionary containing warranty information.
    """
    def parse_date(date_str):
        """
        Parse a date string with multiple format strings.

        Args:
            date_str (str): The date string to parse.

        Returns:
            datetime: A datetime object representing the parsed date.
        """
        formats = ["%Y-%m-%dT%H:%M:%S.%fZ", "%Y-%m-%dT%H:%M:%S.%fZ"]
        
        for fmt in formats:
            try:
                return datetime.strptime(date_str, fmt).replace(tzinfo=timezone.utc)
            except ValueError:
                pass
        
        raise ValueError("Could not parse date with any of the provided formats")

    try:
        servicetag = convert_to_base64(serial_number)
        authtoken = warranty_auth()
        warranty_url = f"{config['ASUS_Warranty_API']}{servicetag}"
        payload = {}
        headers = {"Authorization": f"Bearer {authtoken}"}
        
        warranty_info = {"manufacturer": "ABC", "SerialNumber": "", "WarrantyStartDate": "", "WarrantyEndDate": "", "underWarranty": "", "hardware_support": ""}
        
        response = requests.get(warranty_url, headers=headers, data=payload, verify=False)
        status_code = response.status_code
        
        if status_code == 200:
            result = response.json()
            log.info(f"Fetching the warranty details for ABC server with the serial number - {serial_number}")
            
            warranty_info["serialnumber"] = result["result"]["serviceInfo"]["productSn"]
            warranty_info["warrantyStartDate"] = parse_date(result["result"]["partWarrantyInfo"]["standardWarrantyStart"])
            warranty_info["warrantyEndDate"] = parse_date(result["result"]["partWarrantyInfo"]["standardWarrantyEnd"])
            
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

# You need to implement the following functions: convert_to_base64, warranty_auth, and config.
