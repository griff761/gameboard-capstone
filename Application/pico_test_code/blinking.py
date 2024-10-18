import machine
from machine import bitstream
import time

#################################################################
#         CODE FROM MICROPYTHON LIBRARY            #
#################################################################
class NeoPixel:
    # G R B W
    ORDER = (1, 0, 2, 3)

    def __init__(self, pin, n, bpp=3, timing=1):
        self.pin = pin
        self.n = n
        self.bpp = bpp
        self.buf = bytearray(n * bpp)
        self.pin.init(pin.OUT)
        # Timing arg can either be 1 for 800kHz or 0 for 400kHz,
        # or a user-specified timing ns tuple (high_0, low_0, high_1, low_1).
        self.timing = (
            ((400, 850, 800, 450) if timing else (800, 1700, 1600, 900))
            if isinstance(timing, int)
            else timing
        )

    def __len__(self):
        return self.n

    def __setitem__(self, i, v):
        offset = i * self.bpp
        for i in range(self.bpp):
            self.buf[offset + self.ORDER[i]] = v[i]

    def __getitem__(self, i):
        offset = i * self.bpp
        return tuple(self.buf[offset + self.ORDER[i]] for i in range(self.bpp))

    def fill(self, v):
        b = self.buf
        l = len(self.buf)
        bpp = self.bpp
        for i in range(bpp):
            c = v[i]
            j = self.ORDER[i]
            while j < l:
                b[j] = c
                j += bpp

    def write(self):
        # BITSTREAM_TYPE_HIGH_LOW = 0
        bitstream(self.pin, 0, self.timing, self.buf)

#################################################################
#       END CODE FROM MICROPYTHON LIBRARY            #
#################################################################


# 32 LED strip connected to X8.
p = machine.Pin.board.GP15
n = NeoPixel(p, 64)

# Draw a red gradient.
for i in range(64):
    n[i] = (0,0,0)
    print(i)

i = 0
last = 63
# Update the strip.
while True:
  n[i] = (255,0,0)
  n.write()
  n[i] = (0,0,0)
  i = i+ 1
  if i > last:
      i = 0
  time.sleep(0.5)



# from machine import Pin
# from time import sleep

# # import neopixel

# # led = Pin('LED', Pin.OUT)
# # print('Blinking LED Example')

# # while True:
# #   led.value(not led.value())
# #   sleep(0.5)


# #include all necessary packages to get LEDs to work with Raspberry Pi
# import time
# # import board
# import neopixel

# #Initialise a strips variable, provide the GPIO Data Pin
# #utilised and the amount of LED Nodes on strip and brightness (0 to 1 value)
# pixels1 = neopixel.NeoPixel(machine.Pin.board.X8, 55, brightness=1)

# #Also create an arbitrary count variable
# x=0

# #Focusing on a particular strip, use the command Fill to make it all a single colour
# #based on decimal code R, G, B. Number can be anything from 255 - 0. Use an RGB Colour
# #Code Chart Website to quickly identify the desired fill colour.
# pixels1.fill((0, 220, 0))

# #Below demonstrates how to individual address a colour to a LED Node, in this case
# #LED Node 10 and colour Blue was selected
# pixels1[10] = (0, 20, 255)

# #Sleep for three seconds, You should now have all LEDs showing light with the first node
# #Showing a different colour
# time.sleep(4)

# #Little Light slider script, will produce a nice loading bar effect that goes all the way up a small Strip 
# #and then all the way back
# #This was created using a While Loop taking advantage of that arbitrary variable to determine
# #which LED Node we will target/index with a different colour

# #Below will loop until variable x has a value of 35
# while x<35:
    
#     pixels1[x] = (255, 0, 0)
#     pixels1[x-5] = (255, 0, 100)
#     pixels1[x-10] = (0, 0, 255)
#     #Add 1 to the counter
#     x=x+1
#     #Add a small time pause which will translate to 'smoothly' changing colour
#     time.sleep(0.05)

# #Below section is the same process as the above loop just in reverse
# while x>-15:
#     pixels1[x] = (255, 0, 0)
#     pixels1[x+5] = (255, 0, 100)
#     pixels1[x+10] = (0, 255, 0)
#     x=x-1
#     time.sleep(0.05)

# #Add a brief time delay to appreciate what has happened    
# time.sleep(4)

# #Complete the script by returning all the LED to off
# pixels1.fill((0, 0, 0))