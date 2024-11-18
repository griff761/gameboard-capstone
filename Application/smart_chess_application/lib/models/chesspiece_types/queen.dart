import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Queen extends ChessPiece
{
  bool firstMove = true;
  Queen({required super.row, required super.col, required super.team, super.type = ChessPieceType.queen});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    List<List<int>> moves = [];
    List<int> xPositions = [];
    List<int> yPositions = [];
    for(int i = row + 1; i <= 7 && !sameTeamInSpace(i, col, currentBoard); i++)
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
      return "Q";
    } else {
      return "q";
    }
  }

  @override
  void move(int newX, int newY, Chessboard currentBoard) {
    firstMove = false;
    currentBoard.board[row][col] = Empty(row: row, col: col);
    currentBoard.board[row][col] = this;
  }

}