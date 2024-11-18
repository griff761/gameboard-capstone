import '../chessboard.dart';
import '../chesspiece.dart';

class Empty extends ChessPiece
{
  bool firstMove = true;
  Empty({required super.row, required super.col, super.team = ChessPieceTeam.none, super.type = ChessPieceType.empty});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    return [[]];
  }

  @override
  bool validMove(int newX, int newY, Chessboard currentBoard) {
    return false;
  }

  @override
  String getSymbol() {
    return "";
  }

  @override
  void move(int newX, int newY, Chessboard currentBoard)
  {
    throw Exception("this should never happen, can't move null piece");
  }

}