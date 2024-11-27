from time import sleep
from time import sleep_ms
from mcp3008 import MCP3008
from machine import Pin

spi = machine.SPI(0, sck=Pin(18),mosi=Pin(19),miso=Pin(16), baudrate=100000)
cs0 = machine.Pin(17, machine.Pin.OUT)
cs1 = machine.Pin(20, machine.Pin.OUT)
cs2 = machine.Pin(21, machine.Pin.OUT)
cs3 = machine.Pin(22, machine.Pin.OUT)
cs4 = machine.Pin(26, machine.Pin.OUT)
cs5 = machine.Pin(27, machine.Pin.OUT)
cs6 = machine.Pin(28, machine.Pin.OUT)
cs7 = machine.Pin(15, machine.Pin.OUT)
led = Pin("LED", Pin.OUT)


adc0 = MCP3008(spi, cs0)
adc1 = MCP3008(spi, cs1)
adc2 = MCP3008(spi, cs2)
adc3 = MCP3008(spi, cs3)
adc4 = MCP3008(spi, cs4)
adc5 = MCP3008(spi, cs5)
adc6 = MCP3008(spi, cs6)
adc7 = MCP3008(spi, cs7)
rows, cols = (4, 8)
chessBoard = chessBoard = [[0 for _ in range(cols)] for _ in range(rows)]
defaultTriggerLow = 0.2 # Voltage where magnet definitely is being sensed
defaultTriggerHigh = 1.8 # Voltage where magnet definitely is being sensed
vRef = 2.048 # VREF of the ADC chips
steps = 1023 # of steps of the ADC chip 
scaleFactor = vRef / steps

while True:
    # Read ADC0 (row 0)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc0.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoard[0][y] = 1
        else:
            chessBoard[0][y] = 0
    # Read ADC1 (row 1)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc1.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoard[1][y] = 1
        else:
            chessBoard[1][y] = 0

    # Read ADC2 (row 2)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc2.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoard[2][y] = 1
        else:
            chessBoard[2][y] = 0

    # Read ADC3 (row 3)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc3.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoard[3][y] = 1
        else:
            chessBoard[3][y] = 0

    # # Read ADC4 (row 4)
    # for y in range(0,8):
    #     #sleep_ms(3)
    #     read = scaleFactor * adc4.read(y)
    #     if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
    #         chessBoard[4][y] = 1
    #     else:
    #         chessBoard[4][y] = 0

    # # Read ADC5 (row 5)
    # for y in range(0,8):
    #     #sleep_ms(3)
    #     read = scaleFactor * adc5.read(y)
    #     if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
    #         chessBoard[5][y] = 1
    #     else:
    #         chessBoard[5][y] = 0

    # # Read ADC6 (row 6)
    # for y in range(0,8):
    #     #sleep_ms(3)
    #     read = scaleFactor * adc6.read(y)
    #     if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
    #         chessBoard[6][y] = 1
    #     else:
    #         chessBoard[6][y] = 0

    # # Read ADC7 (row 7)
    # for y in range(0,8):
    #     #sleep_ms(3)
    #     read = scaleFactor * adc7.read(y)
    #     if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
    #         chessBoard[7][y] = 1
    #     else:
    #         chessBoard[7][y] = 0

    print(chessBoard)

