import '../chessboard.dart';
import '../chesspiece.dart';
import 'empty.dart';

class Pawn extends ChessPiece
{
  bool firstMove = true;
  Pawn({required super.row, required super.col, required super.team, super.type = ChessPieceType.pawn});

  @override
  List<List<int>> getValidMoves(Chessboard currentBoard) {
    int direction = team == ChessPieceTeam.white ? 1 : -1;
    List<List<int>> moves = [];
    if(firstMove)
      {
        if (inBounds(row + 2*direction) && spaceEmpty(row + 2*direction, col, currentBoard)) {
          moves.add([row + 2*direction, col]);
        }
      }
    if (inBounds(row + direction) && spaceEmpty(row + direction, col, currentBoard)) {
      moves.add([row + direction, col]);
    }

    //taking another piece
    if(inBounds(row + direction) && inBounds(col+1) && otherTeamInSpace(row+direction, col + 1, currentBoard))
      {
        moves.add([row+direction, col+1]);
      }

    if(inBounds(row + direction) && inBounds(col-1) && otherTeamInSpace(row+direction, col - 1, currentBoard))
    {
      moves.add([row+direction, col-1]);
    }

    //TODO -- implement en passant move
    return moves;
  }

  // need r and c for checking possible king location
  List<List<int>> getValidTakingMoves(Chessboard currentBoard, int r, int c) {
    int direction = team == ChessPieceTeam.white ? 1 : -1;
    List<List<int>> moves = [];

    //taking another piece
    if(inBounds(row + direction) && inBounds(col+1) && (otherTeamInSpace(row+direction, col + 1, currentBoard) || (row+direction == r && col+1 == c)))
    {
      moves.add([row+direction, col+1]);
    }

    if(inBounds(row + direction) && inBounds(col-1) && (otherTeamInSpace(row+direction, col - 1, currentBoard) || (row+direction == r && col-1 == c)))
    {
      moves.add([row+direction, col-1]);
    }

    //TODO -- implement en passant move
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
    super.move(newX, newY, currentBoard);
  }

}