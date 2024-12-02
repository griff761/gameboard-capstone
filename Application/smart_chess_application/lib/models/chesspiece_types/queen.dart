import '../chessboard.dart';
import '../chesspiece.dart';
import '../move.dart';
import 'empty.dart';

class Queen extends ChessPiece
{
  bool firstMove = true;
  Queen({required super.row, required super.col, required super.team, super.type = ChessPieceType.queen});

  @override
  List<Move> getValidMoves(Chessboard currentBoard) {
    List<Move> moves = [];
    //queen movement allows for rook or bishop type moves:

    //rook movement
    for(int i = row + 1; i <= 7 && !sameTeamInSpace(i, col, currentBoard); i++)
    {
      moves.add(Move(row: i, col: col, piece: this));
      if(otherTeamInSpace(i, col, currentBoard))
      {
        break;
      }
    }
    for(int i = row - 1; i >= 0 && !sameTeamInSpace(i, col, currentBoard); i--)
    {
      moves.add(Move(row: i, col: col, piece: this));
      if(otherTeamInSpace(i, col, currentBoard))
      {
        break;
      }
    }

    for(int i = col + 1; i <= 7 && !sameTeamInSpace(row, i, currentBoard); i++)
    {
      moves.add(Move(row: row, col: i, piece: this));
      if(otherTeamInSpace(row, i, currentBoard))
      {
        break;
      }
    }
    for(int i = col - 1; i >= 0 && !sameTeamInSpace(row, i, currentBoard); i--)
    {
      moves.add(Move(row: row, col: i, piece: this));
      if(otherTeamInSpace(row, i, currentBoard))
      {
        break;
      }
    }
    //bishop movement
    // add row add col
    for(int i = 1; (inBounds(row+i) && inBounds(col+i)) && !sameTeamInSpace(row+i, col+i, currentBoard); i++)
    {
      moves.add(Move(row: row+i, col: col+i, piece: this));
      if(otherTeamInSpace(row+i, col+i, currentBoard))
      {
        break;
      }
    }
    //add row sub col
    for(int i = 1; (inBounds(row+i) && inBounds(col-i)) && !sameTeamInSpace(row+i, col-i, currentBoard); i++)
    {
      moves.add(Move(row: row+i, col: col-i, piece: this));
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
      return "Q";
    } else {
      return "q";
    }
  }

}