import urequests
import json
import time

def send_post_request(array_2d, max_retries=5, retry_delay=2):
    """
    Sends a POST request to the server with retry logic.
    """
    url = "http://172.20.10.6:8080/data"
    headers = {"Content-Type": "application/json"}
    data = json.dumps({"chess_moves": array_2d})

    for attempt in range(max_retries):
        try:
            print(f"POST: Sending Request... Attempt {attempt + 1} of {max_retries}")
            response = urequests.post(url, headers=headers, data=data)
            if response.status_code == 200:
                print("POST: Successful, sending array:")
                for row in array_2d:
                    print(row)
                response.close()
                return True  # Successfully sent the request
            else:
                print(f"POST: request failed with status code {response.status_code}: {response.text}")
                response.close()
        except Exception as e:
            print(f"POST: Error w/ request: {e}. Retrying in {retry_delay} seconds...")
        
        time.sleep(retry_delay)

    print("POST: request failed after maximum retries.")
    print("Ensure the server is running and accessible from the current Wi-Fi network.")
    return False  # Indicate failure
