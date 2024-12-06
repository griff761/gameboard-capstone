def send_post_request_with_get_response(chess_board):
    """
    Sends a POST request and waits for a GET response. Ensures persistent GET requests until success.
    """
    try:
        # Send POST request
        print("POST: Initiating request...")
        success = send_post_request(chess_board)
        if not success:
            print("POST: request failed. Skipping GET request.")
            return None  # Explicitly return None for failure

        # Persistent GET response retrieval
        print("GET: Waiting for server to provide AI move...")
        start_time = time.time()
        while time.time() - start_time <= 10:  # Retry for up to 10 seconds
            updated_array = send_get_request(chess_board)
            if updated_array is not current_array:  # Check if a valid update was received
                print("GET: Successfully retrieved AI move.")
                return updated_array

        print("GET: Timeout reached. Unable to retrieve AI move.")
        return None  # Return None if timeout occurs

    except Exception as e:
        print(f"Error in request handling: {e}")
        return None  # Return None if an exception occurs
