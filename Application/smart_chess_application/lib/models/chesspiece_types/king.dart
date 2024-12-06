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
      moves.add(Move(row: row, col: col + 1, piece: this));
    }
    if (inBounds(col - 1) && !sameTeamInSpace(row, col - 1, currentBoard) && !currentBoard.inCheck(row, col - 1, team)) {
      moves.add(Move(row: row, col: col - 1, piece: this));
    }
    if (inBounds(row + 1) && !sameTeamInSpace(row + 1, col, currentBoard) && !currentBoard.inCheck(row + 1, col, team)) {
      moves.add(Move(row: row + 1, col: col, piece: this));
    }
    if (inBounds(row - 1) && !sameTeamInSpace(row - 1, col, currentBoard) && !currentBoard.inCheck(row - 1, col, team)) {
      moves.add(Move(row: row - 1, col: col, piece: this));
    }
    //diagonals
    if (inBounds(row + 1) && inBounds(col + 1) && !sameTeamInSpace(row + 1, col + 1, currentBoard) && !currentBoard.inCheck(row + 1, col + 1, team)) {
      moves.add(Move(row: row + 1, col: col + 1, piece: this));
    }
    if (inBounds(row + 1) && inBounds(col - 1) && !sameTeamInSpace(row + 1, col - 1, currentBoard) && !currentBoard.inCheck(row + 1, col - 1, team)) {
      moves.add(Move(row: row + 1, col: col - 1, piece: this));
    }
    if (inBounds(row - 1) && inBounds(col + 1) && !sameTeamInSpace(row - 1, col + 1, currentBoard) && !currentBoard.inCheck(row - 1, col + 1, team)) {
      moves.add(Move(row: row - 1, col: col + 1, piece: this));
    }
    if (inBounds(row - 1) && inBounds(col - 1) && !sameTeamInSpace(row - 1, col - 1, currentBoard) && !currentBoard.inCheck(row - 1, col - 1, team)) {
      moves.add(Move(row: row - 1, col: col - 1, piece: this));
    }



    if(firstMove)
      {
        //castling
        //TODO: ADD CASTLING LOGIC

        if(canKingsideCastle(currentBoard))
          {
            moves.add(CastleKingside(row: row, col: col+2, piece:this));
          }
        if(canQueensideCastle(currentBoard))
          {
            moves.add(CastleQueenside(row: row, col: col-2, piece: this));
          }

      }
    return moves;
  }

  List<Move> getMovesForCheck(Chessboard currentBoard)
  {
    List<Move> moves = [];

    //move up, down, left, right if those spaces are not in check
    if (inBounds(col + 1) && !sameTeamInSpace(row, col + 1, currentBoard)) {
      moves.add(Move(row: row, col: col + 1, piece: this));
    }
    if (inBounds(col - 1) && !sameTeamInSpace(row, col - 1, currentBoard)) {
      moves.add(Move(row: row, col: col - 1, piece: this));
    }
    if (inBounds(row + 1) && !sameTeamInSpace(row + 1, col, currentBoard)) {
      moves.add(Move(row: row + 1, col: col, piece: this));
    }
    if (inBounds(row - 1) && !sameTeamInSpace(row - 1, col, currentBoard)) {
      moves.add(Move(row: row - 1, col: col, piece: this));
    }
    //diagonals
    if (inBounds(row + 1) && inBounds(col + 1) && !sameTeamInSpace(row + 1, col + 1, currentBoard)) {
      moves.add(Move(row: row + 1, col: col + 1, piece: this));
    }
    if (inBounds(row + 1) && inBounds(col - 1) && !sameTeamInSpace(row + 1, col - 1, currentBoard)) {
      moves.add(Move(row: row + 1, col: col - 1, piece: this));
    }
    if (inBounds(row - 1) && inBounds(col + 1) && !sameTeamInSpace(row - 1, col + 1, currentBoard)) {
      moves.add(Move(row: row - 1, col: col + 1, piece: this));
    }
    if (inBounds(row - 1) && inBounds(col - 1) && !sameTeamInSpace(row - 1, col - 1, currentBoard)) {
      moves.add(Move(row: row - 1, col: col - 1, piece: this));
    }

    return moves;
  }

  bool canKingsideCastle(Chessboard currentBoard)
  {
    //must be first move (and rook's first move)
    if(!firstMove)
    {
      return false;
    }
    if(currentBoard.board[row][7] is! Rook || !(currentBoard.board[row][7] as Rook).firstMove)
    {
      return false;
    }
    // if(!firstMove || currentBoard[row][7])
    //cannot currently be in check and cannot move through check
    if(!currentBoard.inCheck(row, col, team)
        && !currentBoard.inCheck(row, col+1, team)
        && !currentBoard.inCheck(row, col+2, team)
        && spaceEmpty(row, col+1, currentBoard) && spaceEmpty(row, col+2, currentBoard))
    {
      return true;
    }
    return false;
  }

  bool canQueensideCastle(Chessboard currentBoard)
  {
    //must be first move (and rook's first move)
    if(!firstMove)
    {
      return false;
    }
    if(currentBoard.board[row][0] is! Rook || !(currentBoard.board[row][0] as Rook).firstMove)
    {
      return false;
    }
    // if(!firstMove || currentBoard[row][7])
    //cannot currently be in check and cannot move through check
    if(!currentBoard.inCheck(row, col, team)
        && !currentBoard.inCheck(row, col-1, team)
        && !currentBoard.inCheck(row, col-2, team)
        && spaceEmpty(row, col-1, currentBoard)
        && spaceEmpty(row, col-2, currentBoard)
        && spaceEmpty(row, col-3, currentBoard))
    {
      return true;
    }
    return false;
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
  void move(Move move, Chessboard currentBoard) {
    firstMove = false;
    super.move(move, currentBoard);
    //for castling logic
    if(move.castle == 1) //kingside castle
      {
        Rook r = currentBoard.board[row][7] as Rook;
        currentBoard.board[row][5] = r;
        r.col = 5;
        currentBoard.board[row][7] = Empty(row:row, col:7);
      }
    else if(move.castle == -1) //queenside castle
      {
        Rook r = currentBoard.board[row][0] as Rook;
        currentBoard.board[row][3] = r;
        r.col = 3;
        currentBoard.board[row][0] = Empty(row:row, col:0);
      }
  }

  @override
  ChessPiece copy() {
    King k =  King(row: row, col: col, team: team, type: type);
    k.firstMove = firstMove;
    return k;
  }

}