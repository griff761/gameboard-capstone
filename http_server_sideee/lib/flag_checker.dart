/// Flag Checker
/// Processes flags in the last two columns of the 2D array and triggers specific actions.

import 'request_2d_array_interpreter.dart';

class FlagChecker {
  /// Checks flags and applies actions based on the 2D array's state.
  static void checkFlags() {
    final currentArray = Request2DArrayInterpreter.currentArray;

    print('Flag Checker: Checking flags in the 2D array...');

    // Check Row 1, Column 9 (Reset/beginning of game Flag)
    if (currentArray[0][8] == 1) {
      print('Flag Checker: Reset flag detected. Resetting the 2D array...');
      _resetArray(currentArray);
    }

    // Check Row 1, Column 10 (Enter Flag)
    if (currentArray[0][9] == 1) {
      print('Flag Checker: Enter flag detected. Triggering enter action...');
      _enterAction(currentArray);
    }

    // Check Row 1, Column 9 (Gamemode 1 Flag)
    if (currentArray[1][8] == 1) {
      print('Flag Checker: Enter Gamemode 1 detected. Triggering gamemode 1 action...');
      _gamemode1Action(currentArray);
    }

    // Check Row 3, Column 9 (End Turn Flag)
    if (currentArray[2][8] == 1) {
      print('Flag Checker: End turn flag detected. Triggering end turn action...');
      _endTurnAction(currentArray);
    }

    // Add additional flag checks as needed
    Request2DArrayInterpreter.updateArray(currentArray); // Update array with changes
  }

  /// Resets the 2D array (Row 1-8, Columns 1-8 set to 0).
  static void _resetArray(List<List<int>> array) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        array[row][col] = 0;
      }
    }
    array[0][8] = 0; // Reset the flag itself
    print('Flag Checker: Array reset complete.');
  }

  /// Triggers the "Enter" action.
  static void _enterAction(List<List<int>> array) {
    // Example logic for "Enter" action
    array[0][9] = 0; // Reset the flag itself
    print('Flag Checker: Enter action executed.');
  }

  /// Triggers the "Enter" action.
  static void _gamemode1Action(List<List<int>> array) {
    // Example logic for "Enter" action

    //Not resetting this flag, gamemode aready indicated
    //array[1][8] = 0; // Reset the flag itself
    print('Flag Checker: Enter action executed.');
  }

  /// Triggers the "End Turn" action.
  static void _endTurnAction(List<List<int>> array) {
    // Example logic for "End Turn" action
    array[2][8] = 0; // Reset the flag itself
    print('Flag Checker: End turn action executed.');
  }
}
