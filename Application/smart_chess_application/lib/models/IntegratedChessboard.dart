import 'chessboard.dart';
import 'chesspiece.dart';

/// chessboard specifically designed to integrate with hardware portion of the Capstone Project
class IntegratedChessboard extends Chessboard
{

  List<List<ChessPieceTeam>> hardware_state = [
    []
  ];

  List<List<int>> changes = [];




  void update_hardware_state(List<List<ChessPieceTeam>> postArray)
  {
    hardware_state = postArray;
  }

  void determine_spaces_changed()
  {
    changes = [];
    for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
          {
            if(board[i][j].team != hardware_state)
              {
                changes.add([i, j]);
              }
          }
      }
    print("CHESSBOARD CHANGES: ");
    print(changes);

    //now determine what has happened

    //CASE 1 -> only one square has changed (a piece was picked up)

    //CASE 2 -> two squares have changed (a piece has been moved)

    //CASE 3 -> SPECIAL CASE ** castling -> more than 2 pieces have been moved
    // (check for castling and show user spaces that still need to change)
  }
}