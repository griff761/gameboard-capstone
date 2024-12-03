import 'package:smart_chess_application/models/chesspiece.dart';

class ArrayForNicole {
  static late List<List<int>> _storedArray;

  /// Handles the 2D array for Game Mode 1.
  static List<List<int>> handleArray(List<List<int>> array) {
    print('AIPlaceholder: Handling the 2D array...');

    List<List<ChessPieceTeam>> chessboard = List<List<ChessPieceTeam>>.filled(8, List<ChessPieceTeam>.filled(8, ChessPieceTeam.none));

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        chessboard[i][j] = intToChessTeam(array[i][j]);
      }
    }

    // Store the array
    _storedArray = array.map((row) => List<int>.from(row)).toList(); // Save the array

    print('AIPlaceholder: Array received and stored.');

    // Call printArray to display the array
    printArray(_storedArray);

    return _storedArray; // Return unaltered array
  }

  static ChessPieceTeam intToChessTeam(int i) {
    if (i > 0) {
      return ChessPieceTeam.white;
    } else if (i < 0) {
      return ChessPieceTeam.black;
    } else {
      return ChessPieceTeam.none;
    }
  }


  ///   --------------- DOESNT SEEM TO BE EXECUTING FOR SOME REASON! not sure if storing works yet. could be that array is null
  ///   and thus it isnt overwriting what was passed into array_for_nicole.dart.
  ///   thus could be because for now, the AI handling logic isn't implemented, thus it isn't altering any array its given before
  ///   answering the pico's get request.
  ///   so for now: android code is just giving back exactly what it was given from the pico with no changes....
  /// Prints the 2D array in a readable format.
  static void printArray(List<List<int>> array) {
    print('Current Chessboard State:');
    for (var row in array) {
      print(row.map((e) => e.toString().padLeft(2)).join(' '));
    }
  }
}
