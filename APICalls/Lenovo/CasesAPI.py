import requests
import json
import urllib3
from datetime import datetime
from os import path
import logging.config
from configs.config import load_config, read_env
from auth import parse_credentials

def lxco_countCase():
    """
    Function to count the number of service tickets in LXCO.

    Returns:
        dict: Response data containing the count of service tickets.
    """
    uri = f"https://{lxco_instance}/api/v1/data/serviceTickets"
    payload = {}
    headers = {'Authorization': lxco_api_key}
    try:
        response = requests.request("GET", uri, headers=headers, data=payload, verify=False) 
        status_code = response.status_code
        if status_code == 200:
            response_data = response.json()
            return response_data
        else:
            log.critical(f"{status_code} returned") 
    except Exception as e:
        log.critical(f"Error occurred while fetching the count of cases from LXCO:{e}")


def lxco_getCases():
    """
    Function to retrieve and process service tickets from LXCO.

    Returns:
        list: Extracted ticket data.
    """
    lxco_cases = []
    uri = f"https://{lxco_instance}/api/V1/data/serviceTickets"
    payload = {}
    headers = {'Authorization': lxco_api_key}
    try:
        response = requests.request("GET", uri, headers=headers, data=payload, verify=False) 
        status_code = response.status_code
        if status_code == 200:
            result = response.json()
            cases_list = result['results']
            cases_count = len(cases_list)
            for i in range(cases_count):
                if cases_list[i]['state'] != 'closed':
                    lxco_cases.append({'id': cases_list[i]['id'],'status': cases_list[i]['state']})

            extracted_data = []
            for ticket_data in lxco_cases:
                ticket_id = ticket_data['id']
                ticket_url = f"{uri}/{ticket_id}"
                ticket_response = requests.get(ticket_url, headers=headers, verify=False)
                ticket_response_data = ticket_response.json()
                extracted_ticket_data = {"id": ticket_data['id'], "title": ticket_response_data["event"]["description"], "status": ticket_data["status"],
                                         "sources": "Service", "saDeviceId": "1696668", "deviceName": ticket_response_data["componentName"],
                                         "deviceType": "Server", "serviceTag": ticket_response_data.get("serialNumber"),
                                         "caseCreationDate": 1632341803000, "entitlementDescription": ticket_response_data.get("PMRType")}
                extracted_data.append(extracted_ticket_data)
            
            for ticket_data in lxco_cases:
                ticket_data["status"] = ticket_data.pop("status")
                return extracted_data
            else:
                log.critical(f"Error occurred while fetching the cases from LXCO:{e}")
    except Exception as e:
        log.critical(f"Error occurred while fetching the cases from LXCO:{e}")


def fetch_lenovo_latest_comment(email, case_no):
    """
    Function to fetch the latest comment for a Lenovo case.

    Args:
        email (str): Email of the case owner.
        case_no (str): Case number.

    Returns:
        str: Latest comment for the case.
    """
    url = f"https://uatsupport/main/api/v1/cases/{case_no}/comments?caseOwnerEmail={email}&case"
    payload = {}
    headers = {
        'apiKey': lenovo_key,
        'Authorization': 'lenovo_auth'
    }
    response = requests.request("GET", url, headers=headers, data=payload, verify=False)
    if response.status_code == 200:
        comments = response.json()["data"]
        if comments:
            sorted_comments = sorted(comments, key=lambda x: x["createTime"], reverse=True)
            latestcomment = sorted_comments[0]
            return latestcomment['comments']
        else:
            return "No comments found for this case"
    else:
        return f"Failed to fetch comments. Status code:{response.status_code}"

