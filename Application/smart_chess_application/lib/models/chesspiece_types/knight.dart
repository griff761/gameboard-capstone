import '../chessboard.dart';
import '../chesspiece.dart';
import '../move.dart';
import 'empty.dart';

class Knight extends ChessPiece
{
  bool firstMove = true;
  Knight({required super.row, required super.col, required super.team, super.type = ChessPieceType.knight});

  @override
  List<Move> getValidMoves(Chessboard currentBoard) {
    List<Move> moves = [];

    //up right (row + 1, col + 2) and (row + 2, col + 1)
    if (inBounds(row+1) && inBounds(col+2) && !sameTeamInSpace(row+1, col+2, currentBoard))
    {
      moves.add(Move(row: row+1,col: col+2, piece: this));
    }
    if (inBounds(row+2) && inBounds(col+1) && !sameTeamInSpace(row+2, col+1, currentBoard))
    {
      moves.add(Move(row: row+2,col: col+1, piece: this));
    }

    //up left (row + 1, col - 2) and (row + 2, col - 1)
    if (inBounds(row+1) && inBounds(col-2) && !sameTeamInSpace(row+1, col-2, currentBoard))
    {
      moves.add(Move(row: row+1,col: col-2, piece: this));
    }
    if (inBounds(row+2) && inBounds(col-1) && !sameTeamInSpace(row+2, col-1, currentBoard))
    {
      moves.add(Move(row: row+2,col: col-1, piece: this));
    }


    //down right (row - 1, col + 2) and (row - 2, col + 1)
    if (inBounds(row-1) && inBounds(col+2) && !sameTeamInSpace(row-1, col+2, currentBoard))
    {
      moves.add(Move(row: row-1,col: col+2, piece: this));
    }
    if (inBounds(row-2) && inBounds(col+1) && !sameTeamInSpace(row-2, col+1, currentBoard))
    {
      moves.add(Move(row: row-2,col: col+1, piece: this));
    }

    //down left (row - 1, col - 2) and (row - 2, col - 1)
    if (inBounds(row-1) && inBounds(col-2) && !sameTeamInSpace(row-1, col-2, currentBoard))
    {
      moves.add(Move(row: row-1,col: col-2, piece: this));
    }
    if (inBounds(row-2) && inBounds(col-1) && !sameTeamInSpace(row-2, col-1, currentBoard))
    {
      moves.add(Move(row: row-2,col: col-1, piece: this));
    }


    return moves;
  }

  @override
  String getSymbol() {
    if(super.team == ChessPieceTeam.white) {
      return "N";
    } else {
      return "n";
    }
  }

  @override
  ChessPiece copy() {
    return Knight(row: row, col: col, team: team, type: type);
  }

}