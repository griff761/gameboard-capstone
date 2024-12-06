import time
import uselect
import sys
from jacks_folder.wifi_connect import connect_wifi
from request_handler import send_post_request_with_get_response
from lib.mcp3008 import MCP3008
from machine import Pin
import lib.copy as copy
from led_handler import handle_leds  # Import the LED handler

# Setup for reading shell console input using uselect
spoll = uselect.poll()
spoll.register(sys.stdin, uselect.POLLIN)

def wait_for_user_input():
    """
    Waits for user input from the shell console and returns it as a string.
    """
    print("Enter your input and press Enter:")
    while True:
        if spoll.poll(0):  # Check if there's input ready to be read
            input_line = sys.stdin.readline().strip()  # Read the input line
            if input_line:  # Ensure non-empty input
                return input_line
            else:
                print("No input detected. Try again:")

# Test server connectivity
def test_server_connection():
    import usocket
    try:
        addr = usocket.getaddrinfo("172.20.10.13", 8080)[0][-1]
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
chessboardLEDs = [[0 for _ in range(cols)] for _ in range(rows)]  # New variable for LED updates

defaultTriggerLow = 0.2  # Voltage where magnet definitely is being sensed
defaultTriggerHigh = 1.8  # Voltage where magnet definitely is being sensed
vRef = 2.048  # VREF of the ADC chips
steps = 1023  # Steps of the ADC chip
scaleFactor = vRef / steps
boardChange = False
TestingMode = False  # Initialize TestingMode to False

chessBoardCur = [[1, 1, 1, 1, 1, 1, 1, 1,   0,0],
                [1, 1, 1, 1, 1, 1, 1, 1,   0,0],
                [0, 0, 0, 0, 0, 0, 0, 0,   0,0],
                [0, 0, 0, 0, 0, 0, 0, 0,   0,0],
                [0, 0, 0, 0, 0, 0, 0, 0,   0,0],
                [0, 0, 0, 0, 0, 0, 0, 0,   0,0],
                [-1, -1, -1, -1, -1, -1, -1, -1,   0,0],
                [-1, -1, -1, -1, -1, -1, -1, -1,   0,0]]
                
for row in chessBoardCur:
            print(row)

# Main execution loop
print("Enter the change (row, col, value):")



while True:
    try:
        # Get input from the user
        print("Enter the change (row, col, value):")
        input_line = wait_for_user_input()

        # Parse input into a list of integers
        input_values = input_line.strip().split()
        num_values = len(input_values)
        
        if num_values < 3 or num_values > 3:
            print(f"Invalid input: Only {num_values} values entered. Expected 3. Try again.")
        
        try:
            # Convert to integers
            input_values = list(map(int, input_values))
        except ValueError:
            print("Invalid input: Non-numeric values detected. Try again.")
            continue

        # change chessboardCur with input values
        chessBoardCur[input_values[0]][input_values[1]] = input_values[2]
        # for row in range(8):
        #     chessBoardCurr[row] = input_values[row * 10:(row + 1) * 10]

        # if num_values < 80:
        #     print(f"Invalid input: Only {num_values} values entered. Expected 80. Try again.")
        #     continue
        # elif num_values > 80:
        #     print(f"Invalid input: {num_values} values entered. Expected 80. Try again.")
        #     continue

        # try:
        #     # Convert to integers
        #     input_values = list(map(int, input_values))
        # except ValueError:
        #     print("Invalid input: Non-numeric values detected. Try again.")
        #     continue

        # # Populate chessBoardCurr with input values
        # for row in range(8):
        #     chessBoardCurr[row] = input_values[row * 10:(row + 1) * 10]

        print("Complete 8x10 board entered by user:")
        for row in chessBoardCur:
            print(row)

        # Send the 2D array via POST request and retrieve the response via GET
        updated_board = send_post_request_with_get_response(chessBoardCur)

        if updated_board is not None:
            print("GET Response: Updated Board")
            for row in updated_board:
                print(row)

            # Update the chessboard LEDs
            chessboardLEDs = copy.deepcopy(updated_board)
            handle_leds(chessboardLEDs)
        else:
            print("Failed to retrieve updated board from GET response.")

        # Reset for the next input
        print("Ready for new input.")

        if input_values[0] == 0 and input_values[1] == 8 and input_values[3] == 1:
            print("reset")
            chessBoardCur = [[1, 1, 1, 1, 1, 1, 1, 1,   0,0],
                [1, 1, 1, 1, 1, 1, 1, 1,   0,0],
                [0, 0, 0, 0, 0, 0, 0, 0,   0,0],
                [0, 0, 0, 0, 0, 0, 0, 0,   0,0],
                [0, 0, 0, 0, 0, 0, 0, 0,   0,0],
                [0, 0, 0, 0, 0, 0, 0, 0,   0,0],
                [-1, -1, -1, -1, -1, -1, -1, -1,   0,0],
                [-1, -1, -1, -1, -1, -1, -1, -1,   0,0]]

        # Wait before the next iteration
        # time.sleep(3)

    except Exception as e:
        print(f"An error occurred: {e}")
