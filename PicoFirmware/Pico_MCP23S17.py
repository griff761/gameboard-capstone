# Pi Pico MCP23S17 SPI Implementation
# 2022 Kyle Nahas
# Forked from jebentancour's version of Pi_MCP23S17
# https://github.com/jebentancour/Pi_MCP23S17
# Modified with the help of https://docs.micropython.org/en/latest/library/machine.SPI.html#machine-spi
from builtins import bytearray

import micropython
from micropython import const
from machine import Pin, SPI


class MCP23S17(object):
    """This class provides an abstraction of the GPIO expander MCP23S17
    for the Raspberry Pi Pico.
    """
    DIR_INPUT = const(1)
    DIR_OUTPUT = const(0)
    PULLUP_ENABLED = const(1)
    PULLUP_DISABLED = const(0)
    LEVEL_LOW = const(0)
    LEVEL_HIGH = const(1)

    """Register addresses (ICON.BANK = 0) as documented in the technical data sheet at
    http://ww1.microchip.com/downloads/en/DeviceDoc/20001952C.pdf
    """
    MCP23S17_IODIRA = const(0x00)
    MCP23S17_IODIRB = const(0x01)
    MCP23S17_IPOLA = const(0x02)
    MCP23S17_IPOLB = const(0x03)
    MCP23S17_GPIOA = const(0x12)
    MCP23S17_GPIOB = const(0x13)
    MCP23S17_OLATA = const(0x14)
    MCP23S17_OLATB = const(0x15)
    MCP23S17_IOCON = const(0x0A)
    MCP23S17_GPPUA = const(0x0C)
    MCP23S17_GPPUB = const(0x0D)

    """Port References
    http://ww1.microchip.com/downloads/en/DeviceDoc/20001952C.pdf
    """
    MCP23S17_PORTA = const(0x00)
    MCP23S17_PORTB = const(0x01)

    """Bit field flags as documented in the technical data sheet at
    http://ww1.microchip.com/downloads/en/DeviceDoc/20001952C.pdf

    bit 0 Unimplemented: Read as ‘0’

    bit 1 INTPOL: This bit sets the polarity of the INT output pin
        1 = Active-high
        0 = Active-low

    bit 2 ODR: Configures the INT pin as an open-drain output
        1 = Open-drain output (overrides the INTPOL bit.)
        0 = Active driver output (INTPOL bit sets the polarity.)

    bit 3 HAEN: Hardware Address Enable bit (MCP23S17 only) (Note 1)
        1 = Enables the MCP23S17 address pins.
        0 = Disables the MCP23S17 address pins.

    bit 4 DISSLW: Slew Rate control bit for SDA output
        1 = Slew rate disabled
        0 = Slew rate enabled

    bit 5 SEQOP: Sequential Operation mode bit
        1 = Sequential operation disabled, address pointer does not increment.
        0 = Sequential operation enabled, address pointer increments.

    bit 6 MIRROR: INT Pins Mirror bit
        1 = The INT pins are internally connected
        0 = The INT pins are not connected. INTA is associated with PORTA and INTB is associated with PORTB

    bit 7 BANK: Controls how the registers are addressed
        1 = The registers associated with each port are separated into different banks.
        0 = The registers are in the same bank (addresses are sequential).
    """

    IOCON_UNUSED = const(0x01)
    IOCON_INTPOL = const(0x02)
    IOCON_ODR = const(0x04)
    IOCON_HAEN = const(0x08)
    IOCON_DISSLW = const(0x10)
    IOCON_SEQOP = const(0x20)
    IOCON_MIRROR = const(0x40)
    IOCON_BANK_MODE = const(0x80)

    IOCON_INIT = const(0x00)  # IOCON_BANK_MODE = 0, IOCON_HAEN = 0 address pins disabled

    MCP23S17_CMD_WRITE = const(0x40)
    MCP23S17_CMD_READ = const(0x41)

    def __init__(self, spi=None, address=None, bus=0, speed=1000000,
                 sck=2, mosi=3, miso=4, cs=5):
        """
        Constructor

        :param address: The device ID of the component, i.e., the hardware address (default 0.0)
        :param spi: optional argument which passes pre-initialized SPI bus
        :param bus: The SPI Bus to Initialize
        :param speed: The speed to run the SPI bus at; default 1MHz
        :param sck: The pin number for the spi clock pin
        :param mosi: The pin number for the MOSI pin
        :param miso: The pin number for the MISO pin
        :param cs: The pin number for the chip-enable pin

        """
        if not spi:
            self.spi = SPI(bus,
                           baudrate=speed,
                           polarity=0,
                           phase=0,
                           bits=8,
                           firstbit=SPI.MSB,
                           sck=Pin(sck),
                           mosi=Pin(mosi),
                           miso=Pin(miso))
        else:
            self.spi = spi

        self._ha_en = True
        if not address:
            self.device_address = 0x00
        else:
            self.device_address = address
            self._ha_en = True

        self.cs = Pin(cs, Pin.OUT, value=1)

        self._buf_rx_word = [0, 0]
        self._buf_tx_word = [0, 0]
        self._buf_rx = bytearray(3)
        self._buf_tx = bytearray(3)
        self._buf_register = 0
        self._buf_command = 0

        self._GPIOA = 0x00
        self._GPIOB = 0x00
        self._IODIRA = 0xFF
        self._IODIRB = 0xFF
        self._GPPUA = 0x00
        self._GPPUB = 0x00
        self.isInitialized = False

    def open(self):
        """Initializes the MCP23S17 with hardware-address access
        and sequential operations mode.
        """
        # self.spi.open(self.bus, self.ce)
        # self.spi.max_speed_hz = 10000000
        self.isInitialized = True

        config = MCP23S17.IOCON_INIT

        if self._ha_en:
            config |= MCP23S17.IOCON_HAEN

        self._writeRegister(MCP23S17.MCP23S17_IOCON, config)

    def close(self):
        """Closes the SPI connection that the MCP23S17 component is using.
        """
        # self.spi.close()
        self.isInitialized = False

    def setPullupMode(self, pin, mode):
        """
        Enables or disables the pull-up mode for input pins.

        :param pin: The pin index (0 - 15)
        :param mode: The pull-up mode (MCP23S17.PULLUP_ENABLED, MCP23S17.PULLUP_DISABLED)
        """
        assert pin < 16
        assert ((mode == MCP23S17.PULLUP_ENABLED)
                or (mode == MCP23S17.PULLUP_DISABLED))
        assert self.isInitialized

        if pin < 8:
            register = MCP23S17.MCP23S17_GPPUA
            data = self._GPPUA
            noshifts = pin
        else:
            register = MCP23S17.MCP23S17_GPPUB
            noshifts = pin & 0x07
            data = self._GPPUB

        if (mode == MCP23S17.PULLUP_ENABLED):
            data |= (1 << noshifts)
        else:
            data &= (~(1 << noshifts))

        self._writeRegister(register, data)

        if pin < 8:
            self._GPPUA = data
        else:
            self._GPPUB = data

    def setPullupPORTA(self, data):
        assert self.isInitialized

        self._writeRegister(MCP23S17.MCP23S17_GPPUA, data)
        self._GPPUA = data

    def setPullupPORTB(self, data):
        assert self.isInitialized

        self._writeRegister(MCP23S17.MCP23S17_GPPUB, data)
        self._GPPUB = data

    def setPullupByPort(self, port, data):
        assert ((port == MCP23S17.MCP23S17_PORTA)
                or (port == MCP23S17.MCP23S17_PORTB))

        if port is MCP23S17.MCP23S17_PORTA:
            self._writeRegister(MCP23S17.MCP23S17_GPPUA, data)
            self._GPPUA = data
        elif port is MCP23S17.MCP23S17_PORTB:
            self._writeRegister(MCP23S17.MCP23S17_GPPUB, data)
            self._GPPUB = data

    def setDirection(self, pin, direction):
        """
        Sets the direction for a given pin.

        :param pin: The pin index (0 - 15)
        :param direction: The direction of the pin (MCP23S17.DIR_INPUT, MCP23S17.DIR_OUTPUT)
        """
        assert pin < 16
        assert ((direction == MCP23S17.DIR_INPUT)
                or (direction == MCP23S17.DIR_OUTPUT))
        assert self.isInitialized

        if pin < 8:
            register = MCP23S17.MCP23S17_IODIRA
            data = self._IODIRA
            noshifts = pin
        else:
            register = MCP23S17.MCP23S17_IODIRB
            noshifts = pin & 0x07
            data = self._IODIRB

        if direction == MCP23S17.DIR_INPUT:
            data |= (1 << noshifts)
        else:
            data &= (~(1 << noshifts))

        self._writeRegister(register, data)

        if pin < 8:
            self._IODIRA = data
        else:
            self._IODIRB = data

    def setDirPORTA(self, data):
        """
        Sets the direction for the entire port A in one shot.

        :param data: bitfield representing pin directions. Set (1) indicates input, Cleared (0) indicates output
        """
        assert self.isInitialized

        self._writeRegister(MCP23S17.MCP23S17_IODIRA, data)
        self._IODIRA = data

    def setDirPORTB(self, data):
        """
        Sets the direction for the entire port B in one shot.

        :param data: bitfield representing pin directions. Set (1) indicates input, Cleared (0) indicates output
        """
        assert self.isInitialized

        self._writeRegister(MCP23S17.MCP23S17_IODIRB, data)
        self._IODIRB = data

    def setDirByPort(self, port, data):
        """
        Sets the direction for an entire port in one shot.

        :param port: MCP23S17_PORTA or MCP23S17_PORTB
        :param data: bitfield representing pin directions. Set (1) indicates input, Cleared (0) indicates output
        """
        assert ((port == MCP23S17.MCP23S17_PORTA)
                or (port == MCP23S17.MCP23S17_PORTB))

        if port is MCP23S17.MCP23S17_PORTA:
            self._writeRegister(MCP23S17.MCP23S17_IODIRA, data)
            self._IODIRA = data
        elif port is MCP23S17.MCP23S17_PORTB:
            self._writeRegister(MCP23S17.MCP23S17_IODIRB, data)
            self._IODIRB = data

    def digitalRead(self, pin):
        """
        Reads the logical level of a given pin.

        :param pin: The pin index (0 - 15)
        :return: MCP23S17.LEVEL_LOW, if the logical level of the pin is low, otherwise MCP23S17.LEVEL_HIGH.
        """
        assert self.isInitialized
        assert pin < 16

        if pin < 8:
            self._GPIOA = self._readRegister(MCP23S17.MCP23S17_GPIOA)
            if ((int.from_bytes(self._GPIOA, "big") & (1 << pin)) != 0):
                return MCP23S17.LEVEL_HIGH
            else:
                return MCP23S17.LEVEL_LOW
        else:
            self._GPIOB = self._readRegister(MCP23S17.MCP23S17_GPIOB)
            pin &= 0x07
            if ((int.from_bytes(self._GPIOB, "big") & (1 << pin)) != 0):
                return MCP23S17.LEVEL_HIGH
            else:
                return MCP23S17.LEVEL_LOW

    def readPORTA(self):
        assert self.isInitialized
        # It is unclear why we are only reading the second byte.
        data = self._readRegister(MCP23S17.MCP23S17_GPIOA)
        self._GPIOA = data[2]
        return data[2]

    def readPORTB(self):
        assert self.isInitialized

        data = self._readRegister(MCP23S17.MCP23S17_GPIOB)
        self._GPIOB = data[2]
        return data[2]

    def readGPIO(self):
        """Reads the data port value of all pins.

        :return: The 16-bit data port value
        """
        assert self.isInitialized

        data = self._readRegisterWord(MCP23S17.MCP23S17_GPIOA)
        self._GPIOA = (data & 0xFF)
        self._GPIOB = (data >> 8)
        return data

    def digitalWrite(self, pin, level):
        """
        Sets the level of a given pin.

        :param pin: The pin index (0 - 15)
        :param level: The logical level to be set (MCP23S17.LEVEL_LOW, MCP23S17.LEVEL_HIGH)
        """
        assert self.isInitialized
        assert pin < 16
        assert ((level == MCP23S17.LEVEL_HIGH) or (level == MCP23S17.LEVEL_LOW))

        if pin < 8:
            register = MCP23S17.MCP23S17_GPIOA
            data = self._GPIOA
            num_shifts = pin
        else:
            register = MCP23S17.MCP23S17_GPIOB
            num_shifts = pin & 0x07
            data = self._GPIOB

        if (level == MCP23S17.LEVEL_HIGH):
            data |= (1 << num_shifts)
        else:
            data &= (~(1 << num_shifts))

        self._writeRegister(register, data)

        if pin < 8:
            self._GPIOA = data
        else:
            self._GPIOB = data

    def writePORTA(self, data):
        assert self.isInitialized

        self._writeRegister(MCP23S17.MCP23S17_GPIOA, data)
        self._GPIOA = data

    def writePORTB(self, data):
        assert self.isInitialized

        self._writeRegister(MCP23S17.MCP23S17_GPIOB, data)
        self._GPIOB = data

    def writeNibble(self, data, half, port):
        """
        Writes to half of (a nibble) a port

            :param data: The data to be written. Must be positive and less than or equal to 0xF (0b1111)
            :param half: Low or High, indicating which nibble to be written. Accepts LEVEL_LOW or LEVEL_HIGH
            :param port: The port to be written to. Accepts MCP23S17_PORTA or MCP23S17_PORTB
        """
        assert self.isInitialized
        assert 0 <= data <= 0xF
        assert ((half == MCP23S17.LEVEL_HIGH) or (half == MCP23S17.LEVEL_LOW))
        assert ((port == MCP23S17.MCP23S17_PORTA) or (port == MCP23S17.MCP23S17_PORTB))
        if port is MCP23S17.MCP23S17_PORTA:
            if half is MCP23S17.LEVEL_LOW:
                self._GPIOA &= 0xF0
                self._GPIOA |= data
            else:
                self._GPIOA &= 0xF
                self._GPIOA |= (data << 4)
            self._writeRegister(MCP23S17.MCP23S17_GPIOA, self._GPIOA)
        else:
            if half is MCP23S17.LEVEL_LOW:
                self._GPIOB &= 0xF0
                self._GPIOB |= data
            else:
                self._GPIOB &= 0xF
                self._GPIOB |= (data << 4)
            self._writeRegister(MCP23S17.MCP23S173_GPIOB, self._GPIOB)

    def writeGPIO(self, data):
        """
        Sets the data port value for all pins.

        :param data: The 16-bit value to be set.
        """
        assert self.isInitialized

        self._GPIOA = (data & 0xFF)
        self._GPIOB = (data >> 8)
        self._writeRegisterWord(MCP23S17.MCP23S17_GPIOA, data)

    @micropython.native
    def _writeRegister(self, register, value):
        # assert self.isInitialized

        cmd = MCP23S17.MCP23S17_CMD_WRITE | ((self.device_address) << 1)
        tx = bytearray([cmd, register, value])
        # self.spi.xfer2([command, register, value])
        try:
            self.cs.value(0)
            self.spi.write(tx)
        finally:
            self.cs.value(1)

    @micropython.native
    def _readRegister(self, register):
        # assert self.isInitialized

        cmd = MCP23S17.MCP23S17_CMD_READ | ((self.device_address) << 1)
        tx = bytearray([cmd, register, 0])
        rx = bytearray(3)
        # data = self.spi.xfer2([command, register, 0])
        # return data[2]
        try:
            self.cs.value(0)
            self.spi.write_readinto(tx, rx)
        finally:
            self.cs.value(1)
            return rx

    @micropython.native
    def _readRegisterWord(self, register):
        # assert self.isInitialized

        self._buf_rx_word[0] = self._readRegister(register)
        self._buf_rx_word[1] = self._readRegister(register + 1)
        return (self._buf_rx_word[1] << 8) | self._buf_rx_word[0]

    @micropython.native
    def _writeRegisterWord(self, register, data):
        # assert self.isInitialized
        self._writeRegister(register, data & 0xFF)
        self._writeRegister(register + 1, data >> 8)
