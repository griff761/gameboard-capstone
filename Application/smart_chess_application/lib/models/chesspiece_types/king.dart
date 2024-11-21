import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class King extends ChessPiece
{
  bool firstMove = true;
  King({required super.row, required super.col, required super.team, super.type = ChessPieceType.king});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {

    List<List<int>> moves = [];

    //move up, down, left, right if those spaces are not in check
    if (inBounds(col + 1) && !sameTeamInSpace(row, col + 1, currentBoard) && !currentBoard.inCheck(row, col + 1, team)) {
      moves.add([row, col + 1]);
    }
    if (inBounds(col - 1) && !sameTeamInSpace(row, col - 1, currentBoard) && !currentBoard.inCheck(row, col - 1, team)) {
      moves.add([row, col - 1]);
    }
    if (inBounds(row + 1) && !sameTeamInSpace(row + 1, col, currentBoard) && !currentBoard.inCheck(row + 1, col, team)) {
      moves.add([row + 1, col]);
    }
    if (inBounds(row - 1) && !sameTeamInSpace(row - 1, col, currentBoard) && !currentBoard.inCheck(row - 1, col, team)) {
      moves.add([row - 1, col]);
    }
    //diagonals
    if (inBounds(row + 1) && inBounds(col + 1) && !sameTeamInSpace(row + 1, col + 1, currentBoard) && !currentBoard.inCheck(row + 1, col + 1, team)) {
      moves.add([row + 1, col + 1]);
    }
    if (inBounds(row + 1) && inBounds(col - 1) && !sameTeamInSpace(row + 1, col - 1, currentBoard) && !currentBoard.inCheck(row + 1, col - 1, team)) {
      moves.add([row + 1, col - 1]);
    }
    if (inBounds(row - 1) && inBounds(col + 1) && !sameTeamInSpace(row - 1, col + 1, currentBoard) && !currentBoard.inCheck(row - 1, col + 1, team)) {
      moves.add([row - 1, col + 1]);
    }
    if (inBounds(row - 1) && inBounds(col - 1) && !sameTeamInSpace(row - 1, col - 1, currentBoard) && !currentBoard.inCheck(row - 1, col - 1, team)) {
      moves.add([row - 1, col - 1]);
    }



    if(firstMove)
      {
        //castling
        //TODO: ADD CASTLING LOGIC
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
    super.move(newX, newY, currentBoard);
  }

}