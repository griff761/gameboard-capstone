from machine import ADC, Pin
from Pico_MCP23S17 import MCP23S17
import time

print("Begin ADC...")
adc = ADC(Pin(26))     # create ADC object on ADC pin
led = Pin("LED", Pin.OUT)
while True:
    print(adc.read_u16())         # read value, 0-65535 across voltage range 0.0v - 3.3v
    led.on()
    time.sleep_ms(500)
    led.off()
    time.sleep_ms(500)

