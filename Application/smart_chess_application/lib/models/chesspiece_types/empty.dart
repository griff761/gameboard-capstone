import '../chessboard.dart';
import '../chesspiece.dart';
import '../move.dart';

class Empty extends ChessPiece
{
  bool firstMove = true;
  Empty({required super.row, required super.col, super.team = ChessPieceTeam.none, super.type = ChessPieceType.empty});

  @override
  List<Move> getValidMoves(Chessboard currentBoard) {
    return [];
  }

  @override
  Move? validMove(Move move, Chessboard currentBoard) {
    return null;
  }

  @override
  String getSymbol() {
    return "";
  }

  @override
  void move(Move move, Chessboard currentBoard)
  {
    throw Exception("this should never happen, can't move null piece");
  }

  @override
  ChessPiece copy() {
    return Empty(row: row, col: col, team: team, type: type);
  }

}