import time
from jacks_folder.send_post_request import send_post_request
from jacks_folder.send_get_request import send_get_request

def send_post_request_with_get_response(chess_board):
    """
    Sends a POST request and waits for a GET response. Ensures throttling between requests.
    """
    try:
        # Send POST request
        print("Initiating POST request...")
        success = send_post_request(chess_board)
        if not success:
            print("POST request failed. Skipping GET request.")
            return

        # Wait for GET response
        print("Waiting for GET request response...")
        updated_array = send_get_request(chess_board)
        print("Updated chess board received via GET:")
        for row in updated_array:
            print(row)

        # Throttle POST requests to one every 500 ms
        time.sleep(0.5)

    except Exception as e:
        print(f"Error in request handling: {e}")

