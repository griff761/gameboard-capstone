import time
import urequests
from jacks_folder.wifi_connect import connect_wifi, disconnect_wifi
from jacks_folder.chess_move_interpreter import interpret_move

def main_method(array_2d):
    print("Running main logic from jacks_main.py...")

    # Connect to Wi-Fi
    print("Establishing Wi-Fi connection...")
    disconnect_wifi()
    connect_wifi()

    # Interpret and log chess moves
    interpret_and_log_moves(array_2d)

    # POST the 2D array
    post_to_server(array_2d)

    # GET updated 2D array
    fetch_updated_array(array_2d)


def interpret_and_log_moves(array_2d):
    print("Interpreting chess moves from the 2D array:")
    for row_index, row in enumerate(array_2d):
        for col_index, move in enumerate(row):
            if move == 1:
                result = interpret_move(
                    f"{chr(97 + col_index)}{8 - row_index}{chr(97 + col_index)}{8 - row_index}"
                )
            else:
                result = "Empty position"
            print(f"Interpreted move at {chr(97 + col_index)}{8 - row_index}: {result}")


def post_to_server(array_2d):
    server_url = "http://172.20.10.6:8080/data"
    print("Sending the 2D array to the server...")
    try:
        headers = {"Content-Type": "application/json"}
        response = urequests.post(server_url, json={"chess_moves": array_2d}, headers=headers)
        print(f"POST request sent. Response: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"Error during POST request: {e}")


def fetch_updated_array(array_2d):
    server_url = "http://172.20.10.6:8080/config"
    print("Fetching updated 2D array from the server...")
    try:
        response = urequests.get(server_url)
        print(f"GET request successful. Response: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"Error during GET request: {e}")
