def handle_gpio_state_changes(chess_board, gpio_pins):
    """
    Handles GPIO state changes and updates the corresponding flags in the chess board.
    """
    if gpio_pins["reset"].value() == 0:  # Reset/new game button pressed
        chess_board[1][9] = 0  # Reset the flag
        print("GPIO Reset: New game started. Flag row 1, column 9 set to 0.")

    if gpio_pins["game_mode"].value() == 0:  # Game mode toggle button pressed
        chess_board[2][9] = 1  # Switch to game mode 2
        print("GPIO Game Mode: Flag row 2, column 9 set to 1 (Game mode 2).")

    if gpio_pins["enter"].value() == 0:  # Enter button pressed
        chess_board[1][10] = 1  # Indicate enter
        print("GPIO Enter: Flag row 1, column 10 set to 1 (Enter command).")

    if gpio_pins["end_turn"].value() == 0:  # End turn button pressed
        chess_board[3][9] = 1  # Indicate end of turn
        print("GPIO End Turn: Flag row 3, column 9 set to 1 (End of turn).")
