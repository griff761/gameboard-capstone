from time import sleep
from lib.mcp3008 import MCP3008
from machine import Pin
import lib.copy as copy

# SPI and pin configuration
spi = machine.SPI(0, sck=Pin(18), mosi=Pin(19), miso=Pin(16), baudrate=100000)
cs_pins = [Pin(pin, Pin.OUT) for pin in (17, 20, 21, 22, 26, 27, 28, 15)]
adc_list = [MCP3008(spi, cs) for cs in cs_pins]
leds = [[Pin(f"LED_{r}_{c}", Pin.OUT) for c in range(8)] for r in range(8)]

# Chessboard configuration
rows, cols = (8, 8)
chessBoardCurr = [[0 for _ in range(cols)] for _ in range(rows)]
chessBoardPrev = [[0 for _ in range(cols)] for _ in range(rows)]
defaultTriggerLow = 0.2
defaultTriggerHigh = 1.8
vRef = 2.048
steps = 1023
scaleFactor = vRef / steps
boardChange = False


def get_user_input():
    
    
    
# Main loop
while True:
    try:
        boardChange = True

        # If the board changed, log the new state
        if boardChange:
            chessBoardPrev = copy.deepcopy(chessBoardCurr)
            boardChange = False
            print("Updated chessboard state:")
            for row in chessBoardCurr:
                print(row)

        sleep(1)

    except Exception as e:
        print(f"An error occurred: {e}")
