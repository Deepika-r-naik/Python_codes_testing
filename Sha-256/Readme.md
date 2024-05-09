# SHA-256 Hash Calculator

## Overview

This Python script calculates the SHA-256 hash of a given string using the hashlib module. The SHA-256 hash is a cryptographic hash function that produces a fixed-size output (256 bits), typically represented as a hexadecimal string. It is commonly used for secure storage and verification of data integrity.

## Dependencies

This script requires Python 3.x to be installed on your system.

## How to Use

1. Clone or download this repository to your local machine.

2. Open a terminal or command prompt and navigate to the directory where you saved the script.

3. Run the script by typing `python sha256_hash_calculator.py` and pressing Enter.

4. Enter the string for which you want to calculate the SHA-256 hash when prompted.

5. The script will output the SHA-256 hash in hexadecimal representation.

## Example

# Example usage:
data = "Hello, world!"
sha256_hash = get_sha256_hash(data)
print("SHA-256 hash of", data, ":", sha256_hash)
