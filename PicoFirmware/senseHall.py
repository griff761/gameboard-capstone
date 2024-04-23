from machine import ADC, Pin
import time

print("Begin ADC...")
adc = ADC(Pin(26))     # create ADC object on ADC pin
while True:
    print(adc.read_u16())         # read value, 0-65535 across voltage range 0.0v - 3.3v
    time.sleep_ms(500)