from Pico_MCP23S17 import MCP23S17
from machine import Pin

try:
    mcp = MCP23S17(address=0x00, sck=18, mosi=19, miso=16, cs=17)
    mcp1 = MCP23S17(address=0x01, sck=18, mosi=19, miso=16, cs=17)
    #mcp = MCP23S17(address=0x00, sck=2, mosi=3, miso=4, cs=5)
    mcp.open()
    mcp1.open()
    led = Pin("LED", Pin.OUT, value=0)



    mcp.setDirPORTA(mcp.DIR_INPUT)
    mcp.setDirPORTB(mcp.DIR_INPUT)

    mcp1.setDirPORTA(mcp1.DIR_INPUT)
    mcp1.setDirPORTB(mcp1.DIR_INPUT)

    mcp.setPullupPORTA(mcp.PULLUP_ENABLED)
    mcp.setPullupPORTB(mcp.PULLUP_ENABLED)

    mcp1.setPullupPORTA(mcp1.PULLUP_ENABLED)
    mcp1.setPullupPORTB(mcp1.PULLUP_ENABLED)

    """
    Alternatively, can also be done by:
    
    for x in range(0, 16):
        mcp.setDirection(x, mcp.DIR_INPUT)
        mcp.setPullupMode(x, mcp.PULLUP_ENABLED)

    or:

    mcp.setDirByPort(mcp.MCP23S17_PORTA, mcp.DIR_OUTPUT)
    mcp.setDirByPort(mcp.MCP23S17_PORTB, mcp.DIR_OUTPUT)
    
    mcp.setPullupByPort(mcp.MCP23S17_PORTA, mcp.PULLUP_ENABLED)
    mcp.setPullupByPort(mcp.MCP23S17_PORTB, mcp.PULLUP_ENABLED)

    """

    old_btn = 0

    print("Starting reading pin A7 (CTRL+C to quit)")
    while True:
        new_btn = mcp1.digitalRead(7)
        if new_btn != old_btn:
            if new_btn == 1:
                print("Button pressed!")
                led.value(1)
            else:
                print("Button released!")
                led.value(0)

        old_btn = new_btn

finally:
    mcp.close()
    mcp1.close()