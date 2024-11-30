import time
from jacks_folder.wifi_connect import connect_wifi
from request_handler import send_post_request_with_get_response
from lib.mcp3008 import MCP3008
from machine import Pin
import lib.copy as copy
from led_handler import handle_leds  # Import the LED handler

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
chessboardLEDs = [[0 for _ in range(cols)] for _ in range(rows)]  # New variable for LED updates

defaultTriggerLow = 0.2  # Voltage where magnet definitely is being sensed
defaultTriggerHigh = 1.8  # Voltage where magnet definitely is being sensed
vRef = 2.048  # VREF of the ADC chips
steps = 1023  # Steps of the ADC chip
scaleFactor = vRef / steps
boardChange = False

# Main execution loop
while True:
    try:      
        # Read ADCs
        for row, adc in enumerate([adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7]):
            for y in range(8):
                read = scaleFactor * adc.read(y)
                chessBoardCurr[row][y] = 1 if (read < defaultTriggerLow or read > defaultTriggerHigh) else 0
                if chessBoardCurr[row][y] != chessBoardPrev[row][y]:
                    boardChange = True

        if boardChange:
            chessBoardPrev = copy.deepcopy(chessBoardCurr)
            boardChange = False
            
            print("ADCs: Change detected, incoming Chessboard:")
            for row in chessBoardCurr:
                print(row)

            # Send POST request and receive updated board via GET
            updated_board = send_post_request_with_get_response(chessBoardCurr)

            if updated_board is not None:
                # Update chessboardLEDs with the new board
                chessboardLEDs = copy.deepcopy(updated_board)

                print("LEDs: Chessboard Updated (via GET):")
                for row in chessboardLEDs:
                    print(row)

                # Pass the updated board to the LED handler
                handle_leds(chessboardLEDs)
            else:
                print("LEDs: No change, chessboard not updated yet...")
                
            
        # Pause before the next cycle
        time.sleep_ms(3000)

    except Exception as e:
        print(f"An error occurred: {e}")
