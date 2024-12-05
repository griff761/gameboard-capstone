# References:
# - "Get Started with MicroPython on Raspberry Pi Pico: The Official Raspberry Pi Pico Guide (2nd Edition)"
#   Author: Raspberry Pi Foundation
#   Edition: 2nd
#   Use: Guidance on button integration and OLED screen programming with MicroPython.
#   URL: https://www.raspberrypi.org/documentation/microcontrollers/from machine import Pin, I2C

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
button_up = Pin(15, Pin.IN, Pin.PULL_UP)     # Button to move up
button_down = Pin(14, Pin.IN, Pin.PULL_UP)   # Button to move down
button_select = Pin(13, Pin.IN, Pin.PULL_UP) # Button to select
button_back = Pin(12, Pin.IN, Pin.PULL_UP)   # Button to go back

# List of menu options
menu_options = ["Start Game", "Play AI", "Play Friend"]
selected_index = 0  # Start with the first menu option

# Timers for chess players (in seconds)
player1_time = 300  # Player 1 gets 5 minutes
player2_time = 300  # Player 2 gets 5 minutes
current_player = 1  # Player 1 starts
last_switch_time = time.time()  # Record the last time we switched players

# A flag to check if we should return to the menu
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
    if menu_options[selected_index] == "Play Friend":
        play_friend_timer()  # Start the chess timer game
    else:
        oled.fill(0)  # Clear the screen
        oled.text("Selected:", 0, 0)
        oled.text(menu_options[selected_index], 0, 10)
        oled.show()
        time.sleep(2)

# Function for the "Play Friend" chess timer
def play_friend_timer():
    global player1_time, player2_time, current_player, last_switch_time, exit_to_menu
    player1_time = 20  # Reset player times for a new game
    player2_time = 20
    current_player = 1  # Player 1 starts
    last_switch_time = time.time()
    exit_to_menu = False

    while player1_time > 0 and player2_time > 0:
        if exit_to_menu:  # If back button is pressed, return to menu
            return

        # Show timers and current player's turn
        oled.fill(0)
        oled.text("P1: {}s".format(player1_time), 0, 0)
        oled.text("P2: {}s".format(player2_time), 0, 10)
        oled.text("Turn: P{}".format(current_player), 0, 20)
        oled.show()

        # Update the timers
        now = time.time()
        elapsed = int(now - last_switch_time)
        if current_player == 1:
            player1_time -= elapsed
        else:
            player2_time -= elapsed

        # Reset the last time we switched
        last_switch_time = now

        # Check if the select button is pressed to switch players
        if not button_select.value():  # Button pressed
            current_player = 1 if current_player == 2 else 2
            last_switch_time = time.time()
            time.sleep(0.2)  # Wait to avoid accidental presses

        # Check if the back button is pressed to exit the game
        if not button_back.value():
            exit_to_menu = True
            time.sleep(0.2)

    # When the game is over, show who won
    oled.fill(0)
    if player1_time <= 0:
        oled.text("Player 2 Wins!", 0, 20)
    elif player2_time <= 0:
        oled.text("Player 1 Wins!", 0, 20)
    else:
        oled.text("Game Over", 0, 20)
    oled.show()
    time.sleep(5)

# Main loop to handle menu navigation
while True:
    display_menu()

    if not button_up.value():  # If the up button is pressed
        scroll_up()
        time.sleep(0.2)  # Debounce (wait to avoid repeated presses)

    if not button_down.value():  # If the down button is pressed
        scroll_down()
        time.sleep(0.2)  # Debounce

    if not button_select.value():  # If the select button is pressed
        select_option()
        time.sleep(0.2)  # Debounce

    if not button_back.value():  # If the back button is pressed
        selected_index = 0  # Go back to the first menu option
        time.sleep(0.2)  # Debounce

