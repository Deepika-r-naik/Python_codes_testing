import requests
import json
import urllib3
import base64
import logging.config
from os import path
from config.config import load_config, read_environment
from auth import  parse_credentials
import hashlib

load_file_path = path.join(path.dirname(__file__),
                           logging.fileConfig(log_file_path, disable_existing_files=False))
log = logging.getLogger("logfile")
ENV = read_environment()
config = load_config
PATH = path.join(path.dirname(__file__))

def convert_to_sha256(asus_password):
    hashed_password - hashlib.sha256(asus_password.encode('utf8')).hexdigest()
    return hashed_password

def aus_authentication():
    asus_api = f"""asus_api"""
    asus_username = f"""asus_username"""
    asus_password = f"""asus_password"""
    asus_password = convert_to_sha256(asus_password)
    payload = json.dumps({"username": asus_username, "password":  asus_password})
    response = requests.post(asus_api, data=payload, headers=headers)
    if response.status_code == 200:
        log.info(f"Authentication Successful")
        return True
    else:
        log.info(f"Authentication Failed")
        return False


def create_case(serial_number, short_desc, description):
    asus_case_create_api = f"""asus_api"""
    payload = json.dumps({"apply_user":"userame", "customer_id": "cust_011",
                          "memo": short_desc, "description": description, "serial_no": serial_number},
                          "claimcode": [
                              {"claimcode": "sdfd", "climit":"sdfsddf"}

                          ])
    authtoken = asus_authentication()
    headers = {
        "Authorization": f"Bearer{authtoken}",
        "content_type": "application/json",

    }
    log.info(f"Trying to create a case with the given serial_number:{serial_number}, case_title:{short_desc} and case_description: {description}")

    try:
        case_details = {
            "case_id":"",
            "serial_number":"",
            DeviceName:"",
        }
                          
                          
