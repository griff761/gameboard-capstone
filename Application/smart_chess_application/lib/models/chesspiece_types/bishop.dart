import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Bishop extends ChessPiece
{
  Bishop({required super.row, required super.col, required super.team, super.type = ChessPieceType.bishop});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    List<List<int>> moves = [];

    // add row add col
    for(int i = 1; (inBounds(row+i) && inBounds(col+i)) && !sameTeamInSpace(row+i, col+i, currentBoard); i++)
    {
      moves.add([row+i, col+i]);
      if(otherTeamInSpace(row+i, col+i, currentBoard))
      {
        break;
      }
    }
    //add row sub col
    for(int i = 1; (inBounds(row+i) && inBounds(col-i)) && !sameTeamInSpace(row+i, col-i, currentBoard); i++)
    {
      moves.add([row+i, col-i]);
      if(otherTeamInSpace(row+i, col-i, currentBoard))
      {
        break;
      }
    }

    // sub row add col
    for(int i = 1; (inBounds(row-i) && inBounds(col+i)) && !sameTeamInSpace(row-i, col+i, currentBoard); i++)
    {
      moves.add([row-i, col+i]);
      if(otherTeamInSpace(row-i, col+i, currentBoard))
      {
        break;
      }
    }
    //sub row sub col
    for(int i = 1; (inBounds(row-i) && inBounds(col-i)) && !sameTeamInSpace(row-i, col-i, currentBoard); i++)
    {
      moves.add([row-i, col-i]);
      if(otherTeamInSpace(row-i, col-i, currentBoard))
      {
        break;
      }
    }

    return moves;
  }

  @override
  String getSymbol() {
    if(super.team == ChessPieceTeam.white) {
      return "B";
    } else {
      return "b";
    }
  }

}