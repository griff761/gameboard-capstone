# gameboard-capstone
Repository to track all of our work for the Computer Engineering capstone at the University of Utah Spring/Fall 2024.

# Firmware for Pi Pico W
Firmware files are written in MicroPython and are available in the pico files (using buttons and screen) folder. Upload the the contents of the folder to the Pico W and run main.py to start firmware.

# Android Software/Server
The Android App that runs the HTTP server and Android app companion for the board are written in Flutter and can be found in the Application folder.

# Pinout List
## Raspberry Pi Pico WH Pinout 
Pin 1/GP0 - I2C SDA for OLED Display  
Pin 2/GP1 - I2C SCL for OLED Display  
Pin 4/GP2 - Button 1  
Pin 5/GP3 - Button 2  
Pin 6/GP4 - Button 3  
Pin 7/GP5 - Button 4  
Pin 9/GP6 - NeoPixel LEDs  
Pin 20/GP15 - CS7  
Pin 21/GP16 - MISO  
Pin 22/GP17 - CS0  
Pin 24/GP18 - SCK  
Pin 25/GP19 - MOSI  
Pin 26/GP20 - CS1  
Pin 27/GP21 - CS2  
Pin 29/GP22 - CS3  
Pin 31/GP26 - CS4  
Pin 32/GP27 - CS5  
Pin 34/GP28 - CS6  

Every PCB shares the MOSI, MISO, and SCK lines.

## PCB Pinout
VREF - 2v Source
5V - 5V Source
GND - Ground

SCK - Pin 24/GP18
MISO - Pin 21/GP16
MOSI - Pin 25/GP19
CS - See above list for specific pin
