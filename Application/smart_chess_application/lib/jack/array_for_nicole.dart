import 'package:smart_chess_application/jack/server.dart';
import 'package:smart_chess_application/models/chesspiece.dart';

class ArrayForNicole {
  static late List<List<int>> _storedArray;

  static bool isReady = false;

  /// Handles the 2D array for Game Mode 1.
  static List<List<int>> handleArray(List<List<int>> array) {
    isReady = false;


    print('AIPlaceholder: Handling the 2D array...');

    List<List<ChessPieceTeam>> chessboard= [[],[],[],[],[],[],[],[]];

    // Explicitly define each index of the chessboard, keeping the last two columns unchanged
    // List<List<int>> chessboard = [
    //   [0, 0, 0, 0, 0, 0, 0, 0, array[0][8], array[0][9]], // Row 0
    //   [0, 7, 0, 0, 0, 0, 0, 0, array[1][8], array[1][9]], // Row 1
    //   [0, 7, 0, 0, 0, 0, 0, 0, array[2][8], array[2][9]], // Row 2
    //   [0, 0, 0, 0, 0, 0, 0, 0, array[3][8], array[3][9]], // Row 3
    //   [0, 0, 0, 0, 0, 0, 0, 0, array[4][8], array[4][9]], // Row 4
    //   [0, 0, 0, 0, 0, 0, 0, 0, array[5][8], array[5][9]], // Row 5
    //   [0, 0, 0, 0, 0, 0, 0, 0, array[6][8], array[6][9]], // Row 6
    //   [0, 0, 0, 0, 0, 0, 0, 0, array[7][8], array[7][9]], // Row 7
    // ];

    // Placeholder AI/Friend move logic (commented out the loop)
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        chessboard[i].add(intToChessTeam(array[i][j]));
      }
    }

    // Store the updated array
    // _storedArray = chessboard.map((row) => List<int>.from(row)).toList();

    print('AIPlaceholder: Array received and updated.');

    // Call printArray to display the array
    // printArray(_storedArray);
    printArray(chessboard);

    Server.chessKey.currentState?.recieveDataFromPico(chessboard); // Update chessboard view here

    List<List<int>> ledArray =  Server.chessKey.currentState?.getLEDDataForPico() ?? List<List<int>>.generate(8, (_) =>List<int>.generate(10,(_) => 0)); // Return updated array

    List<List<int>> returnArray = [[],[],[],[],[],[],[],[]];
    for(int i = 0; i <  8; i++)
    {
      for(int j = 0; j < 8; j++)
      {
        returnArray[i].add(ledArray[7-i][j]);
      }
      for(int j = 0; j < 2; j++)
      {
        returnArray[i].add(array[i][7+j]);
      }
    }
    print('RETURN ARRAY: ');
    printArray(returnArray);

    isReady = true;

    _storedArray = returnArray;

    return returnArray;


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
  static void printArray(List<List<Object>> array) {
    print('Current Chessboard State:');
    for (var row in array) {
      print(row.map((e) => e.toString().padLeft(2)).join(' '));
    }
  }
}
