

import 'package:smart_chess_application/models/chesspiece.dart';

class ArrayForNicole {
  static late List<List<int>> _storedArray;

  /// Handles the 2D array for Game Mode 1.
  static List<List<int>> handleArray(List<List<int>> array) {
    print('AIPlaceholder: Handling the 2D array...');

    List<List<ChessPieceTeam>> chessboard = List<List<ChessPieceTeam>>.filled(8, List<ChessPieceTeam>.filled(8, ChessPieceTeam.none));

    for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
          {
            chessboard[i][j] = intToChessTeam(array[i][j]);
          }
      }


    // _storedArray is the one you will feed into the AI program. Return it here.
    // something like _storedArray = nicole's_AI_handler(_storedArray);
    _storedArray = array.map((row) => List<int>.from(row)).toList(); // Save the array


    print('AIPlaceholder: Array received and stored.');
    return _storedArray; // Return unaltered array
  }

  static ChessPieceTeam intToChessTeam(int i)
  {
    if(i > 0)
      {
        return ChessPieceTeam.white;
      }
    else if (i < 0)
      {
        return ChessPieceTeam.black;
      }
    else
      {
        return ChessPieceTeam.none;
      }
  }
}

