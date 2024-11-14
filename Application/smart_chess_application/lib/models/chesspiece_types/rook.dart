import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Rook extends ChessPiece
{
  bool firstMove = true;
  Rook({required super.xPos, required super.yPos, required super.team, super.type = ChessPieceType.rook});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    List<List<int>> moves = [];
    List<int> xPositions = [];
    List<int> yPositions = [];
    bool flag = true;
    for(int i = xPos + 1; i <= 7 && !sameTeamInSpace(i, yPos, currentBoard); i++)
    {
      xPositions.add(i);
      if(otherTeamInSpace(i, yPos, currentBoard))
        {
          break;
        }
    }
    for(int i = xPos - 1; i >= 0 && !sameTeamInSpace(i, yPos, currentBoard); i--)
    {
      xPositions.add(i);
      if(otherTeamInSpace(i, yPos, currentBoard))
      {
        break;
      }
    }

    for(int i = yPos + 1; i <= 7 && !sameTeamInSpace(xPos, i, currentBoard); i++)
    {
      yPositions.add(i);
      if(otherTeamInSpace(xPos, i, currentBoard))
      {
        break;
      }
    }
    for(int i = yPos - 1; i >= 0 && !sameTeamInSpace(xPos, i, currentBoard); i--)
    {
      yPositions.add(i);
      if(otherTeamInSpace(xPos, i, currentBoard))
      {
        break;
      }
    }

    for(int x in xPositions)
    {
      moves.add([x, yPos]);
    }
    for(int y in yPositions)
    {
      moves.add([xPos, y]);
    }

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
    currentBoard.board[xPos][yPos] = Empty(xPos: xPos, yPos: yPos);
    currentBoard.board[xPos][yPos] = this;
  }

}