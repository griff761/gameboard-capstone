import 'dart:convert';

/// Request 2D Array Interpreter
/// Handles saving and retrieving the 2D array.

class Request2DArrayInterpreter {
  static List<List<int>> _currentArray =
  List.generate(8, (_) => List.generate(10, (_) => 0));

  /// Retrieves the current 2D array.
  static List<List<int>> get currentArray => _currentArray;

  /// Updates the current 2D array with new values.
  static void updateArray(List<List<int>> newArray) {
    _currentArray = List<List<int>>.from(newArray.map((row) => List<int>.from(row)));
    print('Request2DArrayInterpreter: Updated current array:');
    for (var i = 0; i < _currentArray.length; i++) {
      print('Row $i: ${_currentArray[i]} // UpdatedArray');
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

        if (validatedArray.length != 8 || validatedArray.any((row) => row.length != 10)) {
          print('Invalid array size. Expected 8x10, but received ${validatedArray.length}x${validatedArray[0].length}.');
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
}
