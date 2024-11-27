import time
from jacks_folder.send_post_request import send_post_request
from jacks_folder.send_get_request import send_get_request

def send_post_request_with_get_response(chess_board):
    """
    Sends a POST request and waits for a GET response. Ensures throttling between requests.
    """
    try:
        print("POST: Initiating request...")
        success = send_post_request(chess_board)
        if not success:
            print("POST: request failed --> GET: skipping request.")
            return

        print("GET: waiting for request response...")
        updated_array = send_get_request(chess_board)
        print("GET: Updated chess board (2D array)")

        # Update the chess board with the new state
        chess_board[:] = updated_array

        # Throttle requests to avoid excessive server load
        time.sleep(0.5)
    except Exception as e:
        print(f"Error in request handling: {e}")
