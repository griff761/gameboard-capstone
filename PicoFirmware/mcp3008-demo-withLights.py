from time import sleep
from time import sleep_ms
from mcp3008 import MCP3008
from machine import Pin
from neopixel import NeoPixel


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

# chessBoard = [0]*8
chessboard = matrix = [[0 for _ in range(8)] for _ in range(8)]
# chessBoard2 = [[0]///*8]*2

# LED STRIP
p = machine.Pin.board.GP6
n = NeoPixel(p, 64)

defaultTriggerLow = 0.2 # Voltage where magnet definitely is being sensed
defaultTriggerHigh = 1.8 # Voltage where magnet definitely is being sensed
vRef = 2.048 # VREF of the ADC chips
steps = 1023 # of steps of the ADC chip 
scaleFactor = vRef / steps



while True:
    #print(chip.read(0))
    
    print(chessboard)
    #for i in range (0, 64):
        #n[i]=(255, 0, 0)

        # Read ADCs for columns 1-8
    for row, adc in enumerate([adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7]):
        for y in range(8):
            read = scaleFactor * adc.read(y)
            if (read < defaultTriggerLow ):
                chessboard[row][y] = -1
                n[(row * 8 ) + y] = (0, 255, 0)
            elif (read > defaultTriggerHigh):
                chessboard[row][y] = 1
                n[(row * 8 ) + y] = (0, 0, 255)
            else:
                chessboard[row][y] = 0
                n[(row * 8 ) + y] = (0,0,0)
        n.write()
            
            
    
    # for i in range(0,8):
        
    #     temp = (2.048 / 1023) * chip.read(i)
    #     # print(temp)
    #     if (temp > 1.3) or (temp < 0.7):
    #         # led.on()
    #         # chessBoard[i] = temp
    #         chessboard[0][i] = 1
    #         # chessBoard2[0][i] = 1
    #         # chessBoard2[1][7-i] = 1
    #         n[i] = (255, 0, 0)
    #     else:
    #         # led.off()
    #         # chessBoard[i] = 0
    #         # chessBoard2[0][i] = 0
    #         # chessBoard2[1][7-i] = 0
    #         # chessBoard[i] = temp
    #         chessboard[0][i] = 0

    #         n[i] = (0,0,0)
    #     n.write()
    #     # sleep_ms(12)

    # for i in range(0,8):
        
    #     temp = (2.048 / 1023) * chip2.read(i)
    #     # print(temp)
    #     if (temp > 1.3) or (temp < 0.7):
    #         # led.on()
    #         # chessBoard[i] = temp
    #         chessboard[1][i] = 1
    #         # chessBoard2[0][i] = 1
    #         # chessBoard2[1][7-i] = 1
    #         n[8+i] = (255, 0, 0)
    #     else:
    #         # led.off()
    #         # chessBoard[i] = 0
    #         # chessBoard2[0][i] = 0
    #         # chessBoard2[1][7-i] = 0
    #         # chessBoard[i] = temp
    #         chessboard[1][i] = 0

    #         n[8+i] = (0,0,0)
    #     n.write()
    #     # sleep_ms(12)
    # # print((2 / 1023) * chip2.read(0))
    # # sleep_ms(12)
