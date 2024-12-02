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

while True:
    #print(chip.read(0))
    temp = (2.048 / 1023) * adc2.read(1)
    print(temp)
    if (temp > 1.3) or (temp < 0.7):
        led.on()
    else:
        led.off()
    sleep_ms(12)
    # print((2 / 1023) * chip2.read(0))
    # sleep_ms(12)
