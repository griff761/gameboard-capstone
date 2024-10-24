from time import sleep
from time import sleep_ms
from mcp3008 import MCP3008
from machine import Pin

spi = machine.SPI(0, sck=Pin(18),mosi=Pin(19),miso=Pin(16), baudrate=100000)
cs = machine.Pin(17, machine.Pin.OUT)
cs2 = machine.Pin(20, machine.Pin.OUT)
led = Pin("LED", Pin.OUT)


chip = MCP3008(spi, cs)
chip2 = MCP3008(spi, cs2)

while True:
    #print(chip.read(0))
    temp = (2 / 1023) * chip.read(0)
    print(temp)
    if (temp > 1.3) or (temp < 0.7):
        led.on()
    else:
        led.off()
    sleep_ms(12)
    print((2 / 1023) * chip2.read(0))
    sleep_ms(12)
