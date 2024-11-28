from time import sleep
from time import sleep_ms
from mcp3008 import MCP3008
from machine import Pin
import lib.copy as copy

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
rows, cols = (8, 8)
chessBoardCurr = [[0 for _ in range(cols)] for _ in range(rows)]
chessBoardPrev = [[0 for _ in range(cols)] for _ in range(rows)]
defaultTriggerLow = 0.2 # Voltage where magnet definitely is being sensed
defaultTriggerHigh = 1.8 # Voltage where magnet definitely is being sensed
vRef = 2.048 # VREF of the ADC chips
steps = 1023 # of steps of the ADC chip 
scaleFactor = vRef / steps
boardChange = False

while True:
    # Read ADC0 (row 0)
    for y in range(0,8):
            #sleep_ms(3)
            read = scaleFactor * adc0.read(y)
            if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
                chessBoardCurr[0][y] = 1
            else:
                chessBoardCurr[0][y] = 0
            if (chessBoardCurr[0][y] != chessBoardPrev[0][y]):
                print("hit ADC0")
                boardChange = True
            else:
                if (y==0):
                    print(chessBoardCurr[0][y])
                    print(chessBoardPrev[0][y])
    # Read ADC1 (row 1)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc1.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoardCurr[1][y] = 1
        else:
            chessBoardCurr[1][y] = 0
        if (chessBoardCurr[1][y] != chessBoardPrev[1][y]):
            boardChange = True
    # Read ADC2 (row 2)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc2.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoardCurr[2][y] = 1
        else:
            chessBoardCurr[2][y] = 0
        if (chessBoardCurr[2][y] != chessBoardPrev[2][y]):
            boardChange = True

    # Read ADC3 (row 3)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc3.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoardCurr[3][y] = 1
        else:
            chessBoardCurr[3][y] = 0
        if (chessBoardCurr[3][y] != chessBoardPrev[3][y]):
            boardChange = True
    # Read ADC4 (row 4)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc4.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoardCurr[4][y] = 1
        else:
            chessBoardCurr[4][y] = 0
        if (chessBoardCurr[4][y] != chessBoardPrev[4][y]):
            boardChange = True
    # Read ADC5 (row 5)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc5.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoardCurr[5][y] = 1
        else:
            chessBoardCurr[5][y] = 0
        if (chessBoardCurr[5][y] != chessBoardPrev[5][y]):
            boardChange = True

    # Read ADC6 (row 6)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc6.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoardCurr[6][y] = 1
        else:
            chessBoardCurr[6][y] = 0
        if (chessBoardCurr[6][y] != chessBoardPrev[6][y]):
            boardChange = True

    # Read ADC7 (row 7)
    for y in range(0,8):
        #sleep_ms(3)
        read = scaleFactor * adc7.read(y)
        if ((read < defaultTriggerLow) or (read > defaultTriggerHigh)):
            chessBoardCurr[7][y] = 1
        else:
            chessBoardCurr[7][y] = 0
        if (chessBoardCurr[7][y] != chessBoardPrev[7][y]):
            boardChange = True

    print(boardChange)
    if (boardChange):
        print("test")
        chessBoardPrev = copy.deepcopy(chessBoardCurr)
        boardChange = False
        print("Post")
    sleep(1)
    #print(chessBoard)

