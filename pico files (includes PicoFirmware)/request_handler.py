import time
import copy  # Ensure deep copying
from jacks_folder.send_post_request import send_post_request
from jacks_folder.send_get_request import send_get_request

def send_post_request_with_get_response(chess_board):
    """
    Sends a POST request and waits for a GET response. Ensures throttling between requests.
    Returns the updated array if successful, or None if an error occurs.
    """
    try:
        # Send POST request
        print("Initiating POST request...")
        success = send_post_request(chess_board)
        if not success:
            print("POST request failed. Skipping GET request.")
            return None  # Explicitly return None for failure

        # Wait for GET response
        print("Waiting for GET request response...")
        updated_array = send_get_request(chess_board)

        if updated_array is not None:
            print("Updated chess board received via GET:")
            for row in updated_array:
                print(row)
            return copy.deepcopy(updated_array)  # Return a deep copy to prevent pointer issues
        else:
            print("GET request failed to retrieve an updated board.")
            return None  # Explicitly return None for failure

    except Exception as e:
        print(f"Error in request handling: {e}")
        return None  # Return None if an exception occurs
