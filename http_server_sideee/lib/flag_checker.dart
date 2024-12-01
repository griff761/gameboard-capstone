import 'dart:convert';
import 'array_for_nicole.dart';

class FlagChecker {
  static List<List<int>> _currentArray =
  List.generate(8, (_) => List.generate(10, (_) => 0));

  /// Retrieves the current 2D array.
  static List<List<int>> get currentArray => _currentArray;

  /// Updates the current 2D array with new values.
  static void updateArray(List<List<int>> newArray) {
    _currentArray = List<List<int>>.from(
        newArray.map((row) => List<int>.from(row)));
    print('FlagChecker: Updated current array:');
  }

  /// Checks flags and applies actions based on the 2D array's state.
  static void checkFlags() {
    print('FlagChecker: Checking flags in the 2D array...');

    // Check Row 1, Column 9 (Reset Flag)
    if (_currentArray[0][8] == 1) {
      print('FlagChecker: Reset flag detected. Resetting the 2D array...');
      _resetArray();
    }

    // Check Row 1, Column 10 (Enter Flag)
    if (_currentArray[0][9] == 1) {
      print('FlagChecker: Enter flag detected. Triggering enter action...');
      _enterAction();
    }

    // Check Row 1, Column 9 (Game Mode 1 Flag)
    if (_currentArray[1][8] == 0) {
      print('FlagChecker: Game Mode 1 detected. Triggering Game Mode 1 action...');
      _gamemode1Action();
    }

    // Check Row 3, Column 9 (End Turn Flag)
    if (_currentArray[2][8] == 1) {
      print('FlagChecker: End turn flag detected. Triggering end turn action...');
      _endTurnAction();
    }
  }

  /// Saves a 2D array from a POST request payload.
  static String save2DArray(String payload) {
    try {
      final parsedData = jsonDecode(payload);
      final chessMoves = parsedData['chess_moves'];

      if (chessMoves is List) {
        final validatedArray = chessMoves.map<List<int>>((row) {
          if (row is List) {
            return row.map<int>((element) => element as int).toList();
          } else {
            throw FormatException('Row is not a valid List<int>.');
          }
        }).toList();

        if (validatedArray.length != 8 ||
            validatedArray.any((row) => row.length != 10)) {
          return 'Invalid array size. Expected 8x10.';
        }

        updateArray(validatedArray);
        return '2D array successfully updated.';
      } else {
        return 'Invalid data format. Expected a 2D array.';
      }
    } catch (e) {
      print('Error parsing JSON: $e');
      return 'Error parsing JSON.';
    }
  }

  static void _resetArray() {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        _currentArray[row][col] = 0;
      }
    }
    _currentArray[0][8] = 0; // Reset the flag
    print('FlagChecker: Array reset complete.');
  }

  static void _enterAction() {
    _currentArray[0][9] = 0; // Reset the flag
    print('FlagChecker: Enter action executed.');
  }

  static void _gamemode1Action() {
    final updatedArray = ArrayForNicole.handleArray(_currentArray);
    updateArray(updatedArray); // Save changes back
    print('FlagChecker: Game Mode 1 action executed.');
  }

  static void _endTurnAction() {
    _currentArray[2][8] = 0; // Reset the flag
    print('FlagChecker: End turn action executed.');
  }
}
