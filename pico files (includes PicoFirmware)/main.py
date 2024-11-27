import time
from jacks_folder.request_handler import send_post_request_with_get_response
from jacks_folder.wifi_connect import connect_wifi

# Replace the placeholder chess board with a sample 8x10 array
chess_board = [[1] * 8 + [0, 0] for _ in range(8)]

# Test server connectivity
def test_server_connection():
    import usocket
    try:
        addr = usocket.getaddrinfo("172.20.10.6", 8080)[0][-1]
        s = usocket.socket()
        s.connect(addr)
        print("Successfully connected to the server!")
        s.close()
    except Exception as e:
        print(f"Error connecting to the server: {e}. Check if the server is running and accessible.")

# Ensure Wi-Fi is connected before starting
connect_wifi()

# Test server connectivity
test_server_connection()

# Main execution loop
while True:
    try:
        # Send POST and wait for GET
        send_post_request_with_get_response(chess_board)

        # Print the updated chess board state
        print("Chess Board Updated (Below)")
        for row in chess_board:
            print(row)

        # Pause before the next cycle
        time.sleep(5)

    except Exception as e:
        print(f"An error occurred: {e}")
