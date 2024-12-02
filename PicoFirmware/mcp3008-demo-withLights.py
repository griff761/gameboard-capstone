from time import sleep
from time import sleep_ms
from mcp3008 import MCP3008
from machine import Pin
from neopixel import NeoPixel


spi = machine.SPI(0, sck=Pin(18),mosi=Pin(19),miso=Pin(16), baudrate=100000)
cs = machine.Pin(17, machine.Pin.OUT)
cs2 = machine.Pin(20, machine.Pin.OUT)
led = Pin("LED", Pin.OUT)


chip = MCP3008(spi, cs)
chip2 = MCP3008(spi, cs2)

chessBoard = [0]*8
chessBoard2 = matrix = [[0 for _ in range(8)] for _ in range(2)]
# chessBoard2 = [[0]///*8]*2

# LED STRIP
p = machine.Pin.board.GP15
n = NeoPixel(p, 8)

# Draw a red gradient.
# for i in range(64):
#     n[i] = (0,0,0)
#     print(i)

# i = 0
# last = 63
# # Update the strip.
# while True:
#   n[i] = (255,0,0)
#   n.write()
#   n[i] = (0,0,0)
#   i = i+ 1
#   if i > last:
#       i = 0


while True:
    #print(chip.read(0))
    
    print(chessBoard)
    
    for i in range(0,8):
        
        temp = (3.3 / 1023) * chip.read(i)
        # print(temp)
        if (temp > 1.3) or (temp < 0.7):
            # led.on()
            # chessBoard[i] = temp
            chessBoard[i] = 1
            # chessBoard2[0][i] = 1
            # chessBoard2[1][7-i] = 1
            n[i] = (255, 0, 0)
        else:
            # led.off()
            # chessBoard[i] = 0
            # chessBoard2[0][i] = 0
            # chessBoard2[1][7-i] = 0
            # chessBoard[i] = temp
            chessBoard[i] = 0

            n[i] = (0,0,0)
        n.write()
        sleep_ms(12)

    # print((2 / 1023) * chip2.read(0))
    sleep_ms(12)
