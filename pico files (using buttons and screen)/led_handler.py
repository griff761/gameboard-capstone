# Define a mapping of numbers to LED colors (shifted down by 1)
num_to_color = {
    0: "-",        # 0 means LED off
    1: "black",    # 1 is black
    2: "white",    # 2 is white
    3: "red",      # 3 is red
    4: "orange",   # 4 is orange
    5: "yellow",   # 5 is yellow
    6: "green",    # 6 is green
    7: "blue",     # 7 is blue
    8: "purple",   # 8 is purple
}

# Function to handle LED updates
def handle_leds(chessboard_leds):
    print("LED Handler: Received chessboard LEDs:")
    for row in chessboard_leds:
        print(row)  # Print the array passed into the function

    print("LED Handler: Processing chessboard LED updates...")

    # Create a new array for translated colors
    translated_leds = [[None for _ in range(len(chessboard_leds[0]))] for _ in range(len(chessboard_leds))]

    for row in range(len(chessboard_leds)):
        for col in range(len(chessboard_leds[row])):  # Process all columns
            value = chessboard_leds[row][col]
            if col < 8:  # For the first 8 columns, map the values to colors
                if value in num_to_color:
                    color = num_to_color[value]
                    translated_leds[row][col] = color
                    if color != "-":  # Only print if the color is not "-"
                        print(f"LED Handler: Row {row}, Col {col} set to {color}.")
                else:
                    print(f"LED Handler: Invalid value {value} at Row {row}, Col {col}. No LED set.")
            else:  # For the last two columns, copy the input value as is
                translated_leds[row][col] = value

    # Print the resulting translated chessboard LEDs
    print("LED Handler: Resulting translated chessboard LEDs:")
    for row in translated_leds:
        print(row)

    # Update the chessboardLEDs in main.py
    global chessboardLEDs
    chessboardLEDs = translated_leds
    print("LED Handler: chessboardLEDs updated.")
