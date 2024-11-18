import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Knight extends ChessPiece
{
  bool firstMove = true;
  Knight({required super.row, required super.col, required super.team, super.type = ChessPieceType.knight});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    int direction = team == ChessPieceTeam.black ? 1 : -1;
    List<List<int>> moves = [];
    if(firstMove)
      {
        if (inBounds(col + 2*direction) && !sameTeamInSpace(row, col + 2*direction, currentBoard)) {
          moves.add([row, col + 2*direction]);
        }
      }
    if (inBounds(col + direction) && !sameTeamInSpace(row, col + 2*direction, currentBoard)) {
      moves.add([row, col + direction]);
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
  void move(int newX, int newY, Chessboard currentBoard) {
    firstMove = false;
    currentBoard.board[row][col] = Empty(row: row, col: col);
    currentBoard.board[row][col] = this;
  }

}