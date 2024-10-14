import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class King extends ChessPiece
{
  bool firstMove = true;
  King({required super.xPos, required super.yPos, required super.team, super.type = ChessPieceType.pawn});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {

    List<List<int>> moves = [];

    //move up, down, left, right if those spaces are not in check
    if (inBounds(yPos + 1) && !sameTeamInSpace(xPos, yPos + 1, currentBoard) && currentBoard.inCheck(xPos, yPos + 1, team)) {
      moves.add([xPos, yPos + 1]);
    }
    if (inBounds(yPos - 1) && !sameTeamInSpace(xPos, yPos - 1, currentBoard) && currentBoard.inCheck(xPos, yPos - 1, team)) {
      moves.add([xPos, yPos - 1]);
    }
    if (inBounds(xPos + 1) && !sameTeamInSpace(xPos + 1, yPos, currentBoard) && currentBoard.inCheck(xPos + 1, yPos, team)) {
      moves.add([xPos + 1, yPos]);
    }
    if (inBounds(xPos - 1) && !sameTeamInSpace(xPos - 1, yPos, currentBoard) && currentBoard.inCheck(xPos - 1, yPos, team)) {
      moves.add([xPos - 1, yPos]);
    }


    //castling
    //TODO: ADD CASTLING LOGIC

    if(firstMove)
      {

      }
    return moves;
  }

  @override
  String getSymbol() {
    if(super.team == ChessPieceTeam.white) {
      return "K";
    } else {
      return "k";
    }
  }

  @override
  void move(int newX, int newY, Chessboard currentBoard) {
    firstMove = false;
    currentBoard.board[super.xPos][super.yPos] = Empty(xPos: super.xPos, yPos: super.yPos);
    currentBoard.board[xPos][yPos] = this;
  }

}