# Define a mapping of numbers to LED colors (RGBA values from Flutter)
'''
RGBA VALUES FROM FLUTTER (so they can match)
possible1: 64    255    196    255
possible2: 3    244    169    255
continue1: 178    89    255    255
continue2: 139    74    195    255
error1: 255    82    82    255
error2: 244    54    67    255
exempt1: 255    64    171    255
exempt2: 255    0    152    255
tentative1: 179    250    255    255
tentative2: 134    187    191    255
aIMoveFrom1: 194    255    133    255
aIMoveFrom2: 149    196    102    255
aIMoveTo1: 255    145    246    255
aIMoveTo2: 189    106    182    255

// let 0 be lights OFF (neutral state)
// let 1 be for possible moves
// let 2 be for continued move requirements
// let -1 be for error state
// let -2 be exempt error state (tells user which pieces to swap again)
// let 3 be tentative move (before move confirmation)
// let 4 be AI MOVE FROM
// let 5 be AI MOVE TO
'''

num_to_color = {
    0: (0, 0, 0),            # LED off
    1: (64, 255, 196),       # Possible moves
    2: (178, 89, 255),       # Continued move requirements
    3: (179, 250, 255),      # Tentative move (before move confirmation)
    4: (194, 255, 133),      # AI MOVE FROM
    5: (255, 145, 246),      # AI MOVE TO
    -1: (255, 82, 82),       # Error state
    -2: (255, 64, 171),      # Exempt error state (tells user which pieces to swap again)
}

# Function to handle LED updates
def handle_leds(chessboard_leds):
    print("LED Handler: Received chessboard LEDs:")
    for row in chessboard_leds:
        print(row)  # Print the array passed into the function

    print("LED Handler: Processing chessboard LED updates...")

    # Create a new array for translated LED states
    translated_leds = [[None for _ in range(len(chessboard_leds[0]))] for _ in range(len(chessboard_leds))]

    for row in range(len(chessboard_leds)):
        for col in range(len(chessboard_leds[row])):
            value = chessboard_leds[row][col]

            if col < 8:  # Apply color mapping only to the first 8 columns
                if value in num_to_color and value != 0:
                    color = num_to_color[value]
                    translated_leds[row][col] = color
                    print(f"LED Handler: Row {row}, Col {col} set to {color}.")
                else:
                    # Keep zero or invalid values as-is
                    translated_leds[row][col] = value
                    if value == 0:
                        print(f"LED Handler: Row {row}, Col {col} set to OFF (value remains 0).")
                    else:
                        print(f"LED Handler: Invalid value {value} at Row {row}, Col {col}. No LED set.")
            else:
                # Copy the flag index values for the last two columns without alteration
                translated_leds[row][col] = value
                print(f"LED Handler: Row {row}, Col {col} preserved as flag with value {value}.")

    # Print the resulting translated chessboard LEDs
    print("LED Handler: Resulting translated chessboard LEDs:")
    for row in translated_leds:
        print(row)

    # Update the chessboardLEDs in main.py
    global chessboardLEDs
    chessboardLEDs = translated_leds
    print("LED Handler: chessboardLEDs updated.")

