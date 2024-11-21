import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Knight extends ChessPiece
{
  bool firstMove = true;
  Knight({required super.row, required super.col, required super.team, super.type = ChessPieceType.knight});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    List<List<int>> moves = [];

    //up right (row + 1, col + 2) and (row + 2, col + 1)
    if (inBounds(row+1) && inBounds(col+2) && !sameTeamInSpace(row+1, col+2, currentBoard))
    {
      moves.add([row+1,col+2]);
    }
    if (inBounds(row+2) && inBounds(col+1) && !sameTeamInSpace(row+2, col+1, currentBoard))
    {
      moves.add([row+2,col+1]);
    }

    //up left (row + 1, col - 2) and (row + 2, col - 1)
    if (inBounds(row+1) && inBounds(col-2) && !sameTeamInSpace(row+1, col-2, currentBoard))
    {
      moves.add([row+1,col-2]);
    }
    if (inBounds(row+2) && inBounds(col-1) && !sameTeamInSpace(row+2, col-1, currentBoard))
    {
      moves.add([row+2,col-1]);
    }


    //down right (row - 1, col + 2) and (row - 2, col + 1)
    if (inBounds(row-1) && inBounds(col+2) && !sameTeamInSpace(row-1, col+2, currentBoard))
    {
      moves.add([row-1,col+2]);
    }
    if (inBounds(row-2) && inBounds(col+1) && !sameTeamInSpace(row-2, col+1, currentBoard))
    {
      moves.add([row-2,col+1]);
    }

    //down left (row - 1, col - 2) and (row - 2, col - 1)
    if (inBounds(row-1) && inBounds(col-2) && !sameTeamInSpace(row-1, col-2, currentBoard))
    {
      moves.add([row-1,col-2]);
    }
    if (inBounds(row-2) && inBounds(col-1) && !sameTeamInSpace(row-2, col-1, currentBoard))
    {
      moves.add([row-2,col-1]);
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

}