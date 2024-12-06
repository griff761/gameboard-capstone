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
