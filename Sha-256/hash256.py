import hashlib

def get_sha256_hash(data):
    """
    Returns the SHA-256 hash of the input data.

    Parameters:
        data (str): The input string to be hashed.

    Returns:
        str: The SHA-256 hash in hexadecimal representation.
    """
    sha256_hash = hashlib.sha256()
    sha256_hash.update(data.encode())
    return sha256_hash.hexdigest()

# Example usage:
data = "Hello, world!"
sha256_hash = get_sha256_hash(data)
print("SHA-256 hash of", data, ":", sha256_hash)
