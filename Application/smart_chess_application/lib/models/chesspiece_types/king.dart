import 'package:smart_chess_application/models/chesspiece_types/rook.dart';

import '../chessboard.dart';
import '../chesspiece.dart';
import '../move.dart';
import 'empty.dart';

class King extends ChessPiece
{
  bool firstMove = true;
  King({required super.row, required super.col, required super.team, super.type = ChessPieceType.king});


  /**
   * standard moves will return in a list like [row, col] of space you can move to ->
   * special moves
   */
  @override
  List<Move> getValidMoves(Chessboard currentBoard) {

    List<Move> moves = [];

    //move up, down, left, right if those spaces are not in check
    if (inBounds(col + 1) && !sameTeamInSpace(row, col + 1, currentBoard) && !currentBoard.inCheck(row, col + 1, team)) {
      moves.add(Move(row: row, col: col + 1));
    }
    if (inBounds(col - 1) && !sameTeamInSpace(row, col - 1, currentBoard) && !currentBoard.inCheck(row, col - 1, team)) {
      moves.add(Move(row: row, col: col - 1));
    }
    if (inBounds(row + 1) && !sameTeamInSpace(row + 1, col, currentBoard) && !currentBoard.inCheck(row + 1, col, team)) {
      moves.add(Move(row: row + 1, col: col));
    }
    if (inBounds(row - 1) && !sameTeamInSpace(row - 1, col, currentBoard) && !currentBoard.inCheck(row - 1, col, team)) {
      moves.add(Move(row: row - 1, col: col));
    }
    //diagonals
    if (inBounds(row + 1) && inBounds(col + 1) && !sameTeamInSpace(row + 1, col + 1, currentBoard) && !currentBoard.inCheck(row + 1, col + 1, team)) {
      moves.add(Move(row: row + 1, col: col + 1));
    }
    if (inBounds(row + 1) && inBounds(col - 1) && !sameTeamInSpace(row + 1, col - 1, currentBoard) && !currentBoard.inCheck(row + 1, col - 1, team)) {
      moves.add(Move(row: row + 1, col: col - 1));
    }
    if (inBounds(row - 1) && inBounds(col + 1) && !sameTeamInSpace(row - 1, col + 1, currentBoard) && !currentBoard.inCheck(row - 1, col + 1, team)) {
      moves.add(Move(row: row - 1, col: col + 1));
    }
    if (inBounds(row - 1) && inBounds(col - 1) && !sameTeamInSpace(row - 1, col - 1, currentBoard) && !currentBoard.inCheck(row - 1, col - 1, team)) {
      moves.add(Move(row: row - 1, col: col - 1));
    }



    if(firstMove)
      {
        //castling
        //TODO: ADD CASTLING LOGIC
      }
    return moves;
  }

  List<Move> getMovesForCheck(Chessboard currentBoard)
  {
    List<Move> moves = [];

    //move up, down, left, right if those spaces are not in check
    if (inBounds(col + 1) && !sameTeamInSpace(row, col + 1, currentBoard)) {
      moves.add(Move(row: row, col: col + 1));
    }
    if (inBounds(col - 1) && !sameTeamInSpace(row, col - 1, currentBoard)) {
      moves.add(Move(row: row, col: col - 1));
    }
    if (inBounds(row + 1) && !sameTeamInSpace(row + 1, col, currentBoard)) {
      moves.add(Move(row: row + 1, col: col));
    }
    if (inBounds(row - 1) && !sameTeamInSpace(row - 1, col, currentBoard)) {
      moves.add(Move(row: row - 1, col: col));
    }
    //diagonals
    if (inBounds(row + 1) && inBounds(col + 1) && !sameTeamInSpace(row + 1, col + 1, currentBoard)) {
      moves.add(Move(row: row + 1, col: col + 1));
    }
    if (inBounds(row + 1) && inBounds(col - 1) && !sameTeamInSpace(row + 1, col - 1, currentBoard)) {
      moves.add(Move(row: row + 1, col: col - 1));
    }
    if (inBounds(row - 1) && inBounds(col + 1) && !sameTeamInSpace(row - 1, col + 1, currentBoard)) {
      moves.add(Move(row: row - 1, col: col + 1));
    }
    if (inBounds(row - 1) && inBounds(col - 1) && !sameTeamInSpace(row - 1, col - 1, currentBoard)) {
      moves.add(Move(row: row - 1, col: col - 1));
    }

    return moves;
  }

  // bool canKingsideCastle(Chessboard currentBoard)
  // {
  //   //must be first move (and rook's first move)
  //   if(!firstMove)
  //     {
  //       return false;
  //     }
  //   if(currentBoard.board[row][7] is! Rook || (currentBoard.board[row][7] as Rook).firstMove)
  //     {
  //       return false;
  //     }
  //   // if(!firstMove || currentBoard[row][7])
  //   //cannot currently be in check and cannot move through check
  //   if(!currentBoard.inCheck(row, col, team)
  //       && !currentBoard.inCheck(row, col+1, team)
  //       && !currentBoard.inCheck(row, col+2, team))
  //   {
  //
  //   }
  // }


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