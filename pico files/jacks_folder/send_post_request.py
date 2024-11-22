import urequests
import json
import time

def send_post_request(array_2d, max_retries=5, retry_delay=2):
    """
    Sends a POST request to the server with retry logic.
    """
    url = "http://172.20.10.6:8080/data"  # Replace with actual server address
    headers = {"Content-Type": "application/json"}
    data = json.dumps(array_2d)

    for attempt in range(max_retries):
        try:
            response = urequests.post(url, headers=headers, data=data)
            if response.status_code == 200:
                print("POST Response:", response.text)
                response.close()
                return True  # Success
            else:
                print(f"POST failed with status code {response.status_code}. Retrying...")
                response.close()
        except Exception as e:
            print(f"Error during POST request: {e}. Retrying...")
        
        time.sleep(retry_delay)  # Wait before retrying

    print("POST request failed after maximum retries.")
    return False  # Failure
