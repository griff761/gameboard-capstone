import urequests
import time
import json

def send_get_request(current_array, check_interval=2):
    """
    Sends a GET request repeatedly until a new 2D array is retrieved.
    """
    url = "http://172.20.10.6:8080/config"  # Replace with actual server address
    previous_array = current_array  # Store the array to compare against

    while True:
        try:
            response = urequests.get(url)
            if response.status_code == 200:
                new_array = json.loads(response.text)  # Parse the 2D array from the response
                if new_array != previous_array:
                    print("New array received from GET request:", new_array)
                    response.close()
                    return new_array  # Return the updated array
                else:
                    print("No change detected in the 2D array. Retrying...")
            else:
                print(f"GET failed with status code {response.status_code}. Retrying...")
            response.close()
        except Exception as e:
            print(f"Error during GET request: {e}. Retrying...")

        time.sleep(check_interval)  # Wait before checking again
