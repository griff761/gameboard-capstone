import time
from jacks_folder.wifi_connect import connect_wifi, disconnect_wifi
from jacks_folder.chess_move_interpreter import interpret_move
from request_handler import send_post_request_with_get_response

def main_method(chess_board):
    print("Running main logic from jacks_main.py...")

    # Connect to Wi-Fi
    print("Establishing Wi-Fi connection...")
    disconnect_wifi()
    connect_wifi()

    # Interpret and log chess moves
    interpret_and_log_moves(chess_board)

    # Send POST and GET requests
    send_post_request_with_get_response(chess_board)

def interpret_and_log_moves(chess_board):
    print("Interpreting chess moves from the 2D array:")
    for row_index, row in enumerate(chess_board):
        for col_index, move in enumerate(row):
            if move == 1:
                result = interpret_move(
                    f"{chr(97 + col_index)}{8 - row_index}{chr(97 + col_index)}{8 - row_index}"
                )
            else:
                result = "Empty position"
            print(f"Interpreted move at {chr(97 + col_index)}{8 - row_index}: {result}")
