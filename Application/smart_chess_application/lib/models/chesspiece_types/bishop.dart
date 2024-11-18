import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Bishop extends ChessPiece
{
  Bishop({required super.row, required super.col, required super.team, super.type = ChessPieceType.bishop});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    List<List<int>> moves = [];
    List<int> xPositions = [];
    List<int> yPositions = [];

    for(int i = 1; i <= 7 && !sameTeamInSpace(i, col, currentBoard); i++)
    {
      xPositions.add(i);
    }
    for(int i = row - 1; i >= 0 && !sameTeamInSpace(i, col, currentBoard); i--)
    {
      xPositions.add(i);
    }

    for(int i = col + 1; i <= 7 && !sameTeamInSpace(row, i, currentBoard); i++)
    {
      yPositions.add(i);
    }
    for(int i = col - 1; i <= 7 && !sameTeamInSpace(row, i, currentBoard); i--)
    {
      yPositions.add(i);
    }

    for(int x in xPositions)
    {
      moves.add([x, col]);
    }
    for(int y in yPositions)
    {
      moves.add([row, y]);
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
  void move(int newX, int newY, Chessboard currentBoard) {
    currentBoard.board[row][col] = Empty(row: row, col: col);
    currentBoard.board[row][col] = this;
  }

}