import '../chessboard.dart';
import '../chesspiece.dart';
import '../move.dart';
import 'empty.dart';

class Bishop extends ChessPiece
{
  Bishop({required super.row, required super.col, required super.team, super.type = ChessPieceType.bishop});

  @override
  List<Move> getValidMoves(Chessboard currentBoard) {
    List<Move> moves = [];

    // add row add col
    for(int i = 1; (inBounds(row+i) && inBounds(col+i)) && !sameTeamInSpace(row+i, col+i, currentBoard); i++)
    {
      moves.add(Move(row: row+i, col:col+i, piece: this));
      if(otherTeamInSpace(row+i, col+i, currentBoard))
      {
        break;
      }
    }
    //add row sub col
    for(int i = 1; (inBounds(row+i) && inBounds(col-i)) && !sameTeamInSpace(row+i, col-i, currentBoard); i++)
    {
      moves.add(Move(row: row+i, col:col-i, piece: this));
      if(otherTeamInSpace(row+i, col-i, currentBoard))
      {
        break;
      }
    }

    // sub row add col
    for(int i = 1; (inBounds(row-i) && inBounds(col+i)) && !sameTeamInSpace(row-i, col+i, currentBoard); i++)
    {
      moves.add(Move(row: row-i, col: col+i, piece: this));
      if(otherTeamInSpace(row-i, col+i, currentBoard))
      {
        break;
      }
    }
    //sub row sub col
    for(int i = 1; (inBounds(row-i) && inBounds(col-i)) && !sameTeamInSpace(row-i, col-i, currentBoard); i++)
    {
      moves.add(Move(row: row-i, col: col-i, piece: this));
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

  @override
  ChessPiece copy() {
    return Bishop(row: row, col: col, team: team, type: type);
  }

}