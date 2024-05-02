
# LXCO Case Management Module

The LXCO Case Management Module provides a set of functions to interact with the Lenovo XClarity Controller (LXCO) for managing service tickets and fetching case details. This module simplifies the process of accessing and manipulating data related to service tickets in LXCO.

## Installation

To use this module, you need to have Python installed on your system. Additionally, you need to install the `requests` library, which is used for making HTTP requests. You can install it using pip:

```bash
pip install requests

Usage
Import the module:

from lxco_module import lxco_countCase, lxco_getCases, fetch_lenovo_latest_comment
Use the functions to interact with LXCO:
lxco_countCase()
This function retrieves the count of service tickets from LXCO.

python
Copy code
count_data = lxco_countCase()
print(count_data)
lxco_getCases()
This function retrieves and processes service tickets from LXCO, extracting relevant information.

python
Copy code
cases_data = lxco_getCases()
print(cases_data)
fetch_lenovo_latest_comment(email, case_no)
This function fetches the latest comment for a specified Lenovo case.

python
Copy code
latest_comment = fetch_lenovo_latest_comment("example@email.com", "123456")
print(latest_comment)
Dependencies
Python 3.x
requests
