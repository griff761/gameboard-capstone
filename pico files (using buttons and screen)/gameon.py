from machine import Pin, I2C
import sh1106
import time

# Set up the OLED display with I2C
WIDTH = 128  # Screen width
HEIGHT = 64  # Screen height
i2c = I2C(0, scl=Pin(1), sda=Pin(0), freq=200000)  # I2C on GP0 (SDA) and GP1 (SCL)
oled = sh1106.SH1106_I2C(WIDTH, HEIGHT, i2c)  # Create OLED object

# Rotate the display if it looks upside down
oled.rotate(True)

# Buttons setup (connect to GPIO pins)
button_up = Pin(2, Pin.IN, Pin.PULL_UP)     # Button to move up
button_down = Pin(3, Pin.IN, Pin.PULL_UP)   # Button to move down
button_select = Pin(5, Pin.IN, Pin.PULL_UP) # Button to select
button_back = Pin(4, Pin.IN, Pin.PULL_UP)   # Button to go back


# List of menu options
menu_options = ["Play AI", "Play Friend"]
selected_index = 0  # Start with the first menu option

# Global variables
inGame = False
exit_to_menu = False


# Function to display the menu
def display_menu():
    oled.fill(0)  # Clear the screen
    for i, option in enumerate(menu_options):
        if i == selected_index:
            oled.text("> " + option, 0, i * 10)  # Add ">" to show selected option
        else:
            oled.text(option, 10, i * 10)  # Regular menu text
    oled.show()  # Show everything on the screen

# Move up in the menu
def scroll_up():
    global selected_index
    if selected_index > 0:
        selected_index -= 1  # Move one option up

# Move down in the menu
def scroll_down():
    global selected_index
    if selected_index < len(menu_options) - 1:
        selected_index += 1  # Move one option down

# Select a menu option
def select_option():
    global inGame
    if menu_options[selected_index] == "Play Friend":
        inGame = True
    elif menu_options[selected_index] == "Play AI":
        inGame = True
