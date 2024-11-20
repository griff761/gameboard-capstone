import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Rook extends ChessPiece
{
  bool firstMove = true;
  Rook({required super.row, required super.col, required super.team, super.type = ChessPieceType.rook});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    List<List<int>> moves = [];
    List<int> xPositions = [];
    List<int> yPositions = [];
    bool flag = true;
    // for(int i = row + 1; i <= 7 && !sameTeamInSpace(col, i, currentBoard); i++)
    // {
    //   moves.add([col, i]);
    //   // xPositions.add(i);
    //   if(otherTeamInSpace(i, col, currentBoard))
    //     {
    //       break;
    //     }
    // }
    // for(int i = row - 1; i >= 0 && !sameTeamInSpace(col, i, currentBoard); i--)
    // {
    //   moves.add([col, i]);
    //   // xPositions.add(i);
    //   if(otherTeamInSpace(i, col, currentBoard))
    //   {
    //     break;
    //   }
    // }

    for(int i = col + 1; i <= 7 && !sameTeamInSpace(i, row, currentBoard); i++)
    {
      moves.add([i, row]);
      // yPositions.add(i);
      if(otherTeamInSpace(row, i, currentBoard))
      {
        break;
      }
    }
    for(int i = col - 1; i >= 0 && !sameTeamInSpace(i, row, currentBoard); i--)
    {
      moves.add([i, row]);
      // yPositions.add(i);
      if(otherTeamInSpace(row, i, currentBoard))
      {
        break;
      }
    }

    // for(int x in xPositions)
    // {
    //   moves.add([x, col]);
    // }
    // for(int y in yPositions)
    // {
    //   moves.add([row, y]);
    // }

    if(firstMove)
      {
        //TODO: castling logic here
      }

    return moves;
  }

  @override
  String getSymbol() {
    if(super.team == ChessPieceTeam.white) {
      return "R";
    } else {
      return "r";
    }
  }

  @override
  void move(int newX, int newY, Chessboard currentBoard) {
    firstMove = false;
    super.move(newX, newY, currentBoard);
  }

}