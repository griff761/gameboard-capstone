try:
    import urequests
except ImportError as e:
    print(f"Error: urequests module not found. {e}")
    urequests = None

import json
import time

def send_get_request(current_array, check_interval=2):
    """
    Sends a GET request and retrieves the 2D array from the server, whether or not it has changed.
    """
    if not urequests:
        print("Error: urequests is not available. Cannot send GET requests.")
        return current_array  # Return the current array as a fallback

    url = "http://172.20.10.6:8080/config"  # Correct server address

    try:
        response = urequests.get(url)
        if response.status_code == 200:
            new_array = json.loads(response.text)["chess_moves"]  # Parse the 2D array from the response
            print("GET: Successful")
            response.close()
            return new_array  # Return the updated array (even if unchanged)
        else:
            print(f"GET: failed with status code {response.status_code}. Returning current array.")
            response.close()
    except Exception as e:
        print(f"Error during GET request: {e}. Returning current array.")

    # Return the current array if there's an error or no update
    return current_array
