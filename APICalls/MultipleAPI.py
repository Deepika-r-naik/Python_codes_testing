
def fetch_lenovo_warranty(serial_number):

      return "Warranty details for Lenovo hardware"


def fetch_hp_warranty(serial_number):
       return "Warranty details for HP hardware"


def fetch_dell_warranty(serial_number):
    return "Warranty details for Dell hardware"


def fetch_asus_warranty(serial_number):
     return "Warranty details for ASUS hardware"


def get_hardware_type(serial_number):

    hardware_mapping = {
        "123456789": "Lenovo",
        "987654321": "HP",
        "456789123": "Dell",
        "789123456": "ASUS"
    }
    return hardware_mapping.get(serial_number, "Unknown")


def fetch_warranty_details(serial_number):
    hardware_type = get_hardware_type(serial_number)
    
    if hardware_type == "Lenovo":
        return fetch_lenovo_warranty(serial_number)
    elif hardware_type == "HP":
        return fetch_hp_warranty(serial_number)
    elif hardware_type == "Dell":
        return fetch_dell_warranty(serial_number)
    elif hardware_type == "ASUS":
        return fetch_asus_warranty(serial_number)
    else:
        return "Unable to determine hardware type for given serial number"


serial_number = "123456789"
print(fetch_warranty_details(serial_number))
