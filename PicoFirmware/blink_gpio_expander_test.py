from Pico_MCP23S17 import MCP23S17
from machine import Pin
import time

try:
    mcp = MCP23S17(address=0x00, sck=18, mosi=19, miso=16, cs=17)
    #mcp = MCP23S17(address=0x00, sck=2, mosi=3, miso=4, cs=5)
    mcp.open()

    led = Pin("LED", Pin.OUT, value=0)

    mcp.setDirPORTA(mcp.DIR_OUTPUT)
    mcp.setDirPORTB(mcp.DIR_OUTPUT)

    """
    Alternatively, can also be done by:
    
    for x in range(0, 16):
        mcp.setDirection(x, mcp.DIR_OUTPUT)
        
    or:
    
    mcp.setDirByPort(mcp.MCP23S17_PORTA, mcp.DIR_OUTPUT)
    mcp.setDirByPort(mcp.MCP23S17_PORTB, mcp.DIR_OUTPUT)
    
    """


    print("Starting blinky on all pins (CTRL+C to quit)")
    while True:
        mcp.writeGPIO(0xFFFF)  # Set all pins high
        """
        Can also by achieved by:

        for x in range(0, 16):
            mcp.digitalWrite(x, MCP23S17.LEVEL_HIGH)
            
        """

        led.value(1)  # Write to the onboard LED, so we know code is executing
        time.sleep(0.2)

        mcp.writeGPIO(0x0000)  # Set all pins low

        """
        ... or like this:
        
        mcp.writePORTA(0x00)
        mcp.writePORTB(0x00)
        
        """

        led.value(0)  # Write to the onboard LED, so we know code is executing
        time.sleep(0.2)

finally:
  mcp.close()
