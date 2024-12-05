import time
from jacks_folder.wifi_connect import connect_wifi
from request_handler import send_post_request_with_get_response
from lib.mcp3008 import MCP3008
from machine import Pin
import lib.copy as copy
from led_handler import handle_leds
import gameon

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
test_server_connection()

# Define pins
spi = machine.SPI(0, sck=Pin(18), mosi=Pin(19), miso=Pin(16), baudrate=100000)
cs0 = machine.Pin(17, machine.Pin.OUT)
cs1 = machine.Pin(20, machine.Pin.OUT)
cs2 = machine.Pin(21, machine.Pin.OUT)
cs3 = machine.Pin(22, machine.Pin.OUT)
cs4 = machine.Pin(26, machine.Pin.OUT)
cs5 = machine.Pin(27, machine.Pin.OUT)
cs6 = machine.Pin(28, machine.Pin.OUT)
cs7 = machine.Pin(15, machine.Pin.OUT)
led = Pin("LED", Pin.OUT)

# Define discrete ADCs
adc0 = MCP3008(spi, cs0)
adc1 = MCP3008(spi, cs1)
adc2 = MCP3008(spi, cs2)
adc3 = MCP3008(spi, cs3)
adc4 = MCP3008(spi, cs4)
adc5 = MCP3008(spi, cs5)
adc6 = MCP3008(spi, cs6)
adc7 = MCP3008(spi, cs7)

rows, cols = (8, 10)
chessBoardCurr = [[0 for _ in range(cols)] for _ in range(rows)]
chessBoardPrev = [[0 for _ in range(cols)] for _ in range(rows)]
chessboardLEDs = [[0 for _ in range(cols)] for _ in range(rows)]

defaultTriggerLow = 0.2
defaultTriggerHigh = 1.8
vRef = 2.048
steps = 1023
scaleFactor = vRef / steps
boardChange = False
TestingMode = False
reset_board_occurred = False
startOfProgram = True

last_button_poll_time = 0  # For frequent button polling
last_button_press_time = 0  # For debouncing


# Debounce function for buttons
def is_debounced_button_pressed(button):
    global last_button_press_time
    current_time = time.ticks_ms()
    if not button.value():  # Button is pressed
        if time.ticks_diff(current_time, last_button_press_time) > 200:  # 200ms debounce
            last_button_press_time = current_time
            return True
    return False

# Logic to reset the board
def reset_board_logic():
    global chessBoardCurr, chessBoardPrev, chessboardLEDs, boardChange, TestingMode, reset_board_occurred
    gameon.inGame = False  # Reset inGame to False

    # Display "Game Over"
    gameon.oled.fill(0)
    gameon.oled.text("Game Over", 10, 20)
    gameon.oled.show()
    time.sleep(2)  # Wait for 2 seconds

    # Display "Please Reset Pieces"
    gameon.oled.fill(0)
    gameon.oled.text("Please Reset", 10, 10)
    gameon.oled.text("Pieces", 10, 30)
    gameon.oled.show()
    time.sleep(2)  # Wait for 2 seconds

    # Clear LEDs for the board
    for row in range(8):
        for col in range(10):  # Clear all columns including flag bits
            chessboardLEDs[row][col] = 0

    # Indicate to later set the reset flag bit to 1 (row 1, column 9)
    reset_board_occurred = True

    boardChange = True  # Indicate board state has changed
    print("Resetting the board... Reset flag set to 1. Board LEDs cleared.")

# Main execution loop
while True:
    try:
        current_time = time.ticks_ms()
        if time.ticks_diff(current_time, last_button_poll_time) > 50:  # Poll every 50ms
            last_button_poll_time = current_time

            # Handle back button press
            if is_debounced_button_pressed(gameon.button_back):
                print("Back button detected!")
                if gameon.inGame:
                    reset_board_logic()

        # Start the gameon menu loop first
        if not gameon.inGame:
            gameon.display_menu()
            if not gameon.button_up.value():
                gameon.scroll_up()
                time.sleep(0.2)  # Debounce
            if not gameon.button_down.value():
                gameon.scroll_down()
                time.sleep(0.2)  # Debounce
            if not gameon.button_select.value():
                gameon.select_option()

                # Set the game mode flag bits based on the selected mode
                if gameon.menu_options[gameon.selected_index] == "Play AI":
                    chessBoardCurr[1][8] = 1  # Row 2, column 9
                    chessBoardCurr[1][9] = 0  # Ensure only Play AI mode selected
                elif gameon.menu_options[gameon.selected_index] == "Play Friend":
                    chessBoardCurr[1][9] = 1  # Row 2, column 10
                    chessBoardCurr[1][8] = 0  # Ensure only Play Friend mode selected

                time.sleep(0.2)  # Debounce
            if not gameon.button_back.value():
                gameon.exit_to_menu = True
                time.sleep(0.2)  # Debounce
            continue  # Skip the rest of the loop if in gameon menu

        # Proceed only if inGame is True
        if gameon.inGame:
            if not TestingMode:
                # Only copy changes for the first 8 columns (ignoring flag bits)
                for row in range(8):
                    for col in range(8):
                        chessBoardCurr[row][col] = chessboardLEDs[row][col]

                # ADC reading logic
                for row, adc in enumerate([adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7]):
                    for y in range(8):
                        read = scaleFactor * adc.read(y)
                        chessBoardCurr[row][y] = 1 if (read < defaultTriggerLow or read > defaultTriggerHigh) else 0
                        if chessBoardCurr[row][y] != chessBoardPrev[row][y]:
                            boardChange = True

            # Ensure the reset flag is only set after ADC updates
            if reset_board_occurred or startOfProgram:
                chessBoardCurr[0][8] = 1
                reset_board_occurred = False  # Reset the state
                startOfProgram = False

            if boardChange:
                chessBoardPrev = copy.deepcopy(chessBoardCurr)
                boardChange = False

                print("ADCs: Change detected, incoming Chessboard:")
                for row in chessBoardCurr:
                    print(row)

                # POST request with the reset flag bit
                updated_board = send_post_request_with_get_response(chessBoardCurr)

                if updated_board is not None:
                    chessBoardCurr[0][8] = 0  # Clear reset flag
                    handle_leds(updated_board)  # Process LEDs and update global chessboardLEDs
                    print("LEDs: Chessboard Updated and processed.")
                else:
                    print("LEDs: No change, chessboard not updated yet...")


            TestingMode = False

    except Exception as e:
        print(f"An error occurred: {e}")
