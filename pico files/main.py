import sys
import os

# Add the current working directory to the Python path
sys.path.append(os.getcwd())

from jacks_folder.jacks_main import main_method

def main():
    # Define the 2D array (8x8 chessboard + 2 rows for flags)
    array_2d = [
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
    ]

    # Call main_method to handle logic
    main_method(array_2d)

if __name__ == "__main__":
    main()
