import 'package:smart_chess_application/jack/server.dart';
import 'package:smart_chess_application/models/chesspiece.dart';

class ArrayForNicole {
  static late List<List<int>> _storedArray;
  static int playerTurnIncrementer = 0;

  /// Handles the 2D array for Game Mode 1.
  static List<List<int>> handleArray(List<List<int>> array) {
    print('AIPlaceholder: Handling the 2D array...');

    // Explicitly define each index of the chessboard, keeping the last two columns unchanged
    List<List<int>> chessboard = [
      [0, 0, 0, 0, 0, 0, 0, 0, array[0][8], array[0][9]], // Row 0
      [0, 2, 0, 0, 0, 0, 0, 0, array[1][8], array[1][9]], // Row 1
      [0, 3, 0, 0, 0, 0, 0, 0, array[2][8], array[2][9]], // Row 2
      [0, 0, 0, 0, 0, 0, 0, 0, normalTurnScenario(), array[3][9]], // Row 3
      [0, 0, 0, 0, 0, 0, 0, 0, array[4][8], array[4][9]], // Row 4
      [0, 0, 0, 0, 0, 0, 0, 0, array[5][8], array[5][9]], // Row 5
      [0, 0, 0, 0, 0, 0, 0, 0, array[6][8], array[6][9]], // Row 6
      [0, 0, 0, 0, 0, 0, 0, 0, array[7][8], array[7][9]], // Row 7
    ];

    // Placeholder AI/Friend move logic (commented out the loop)
    // for (int i = 0; i < 8; i++) {
    //   for (int j = 0; j < 8; j++) {
    //     chessboard[i].add(intToChessTeam(array[i][j]));
    //   }
    // }

    // Store the updated array
    _storedArray = chessboard.map((row) => List<int>.from(row)).toList();

    print('AIPlaceholder: Array received and updated.');

    // Call printArray to display the array
    printArray(_storedArray);

    Server.chessKey.currentState?.updateInt(); // Update chessboard view here

    return _storedArray; // Return updated array
  }

  // Every time the 2d array being sent back, change from player 1 to 2 for testing
  // Starts with player 1
  static int normalTurnScenario() {
    playerTurnIncrementer += 1; // Increment the value by 1
    return playerTurnIncrementer % 2 == 0 ? 2 : 1; // Return player 2 is up if even, player 1 if odd

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

  /// Prints the 2D array in a readable format.
  static void printArray(List<List<int>> array) {
    print('Current Chessboard State:');
    for (var row in array) {
      print(row.map((e) => e.toString().padLeft(2)).join(' '));
    }
  }
}
