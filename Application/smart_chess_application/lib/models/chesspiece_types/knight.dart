import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Knight extends ChessPiece
{
  bool firstMove = true;
  Knight({required super.xPos, required super.yPos, required super.team, super.type = ChessPieceType.knight});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    int direction = team == ChessPieceTeam.black ? 1 : -1;
    List<List<int>> moves = [[]];
    if(firstMove)
      {
        if (inBounds(yPos + 2*direction) && !sameTeamInSpace(xPos, yPos + 2*direction, currentBoard)) {
          moves.add([xPos, yPos + 2*direction]);
        }
      }
    if (inBounds(yPos + direction) && !sameTeamInSpace(xPos, yPos + 2*direction, currentBoard)) {
      moves.add([xPos, yPos + direction]);
    }
    return moves;
  }

  @override
  String getSymbol() {
    if(super.team == ChessPieceTeam.white) {
      return "P";
    } else {
      return "p";
    }
  }

  @override
  void move(int newX, int newY, Chessboard currentBoard) {
    firstMove = false;
    currentBoard.board[super.xPos][super.yPos] = Empty(xPos: super.xPos, yPos: super.yPos);
    currentBoard.board[xPos][yPos] = this;
  }

}