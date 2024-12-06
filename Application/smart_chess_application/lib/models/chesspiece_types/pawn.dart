import 'package:smart_chess_application/models/chesspiece_types/queen.dart';
import 'package:smart_chess_application/models/chesspiece_types/rook.dart';

import '../chessboard.dart';
import '../chesspiece.dart';
import '../move.dart';
import 'bishop.dart';
import 'empty.dart';
import 'knight.dart';

class Pawn extends ChessPiece
{
  bool firstMove = true;
  bool canBeEnPassanted = false;
  int direction = 0;
  int promotionRow = 0;
  Pawn({required super.row, required super.col, required super.team, super.type = ChessPieceType.pawn})
  {
    direction = team == ChessPieceTeam.white ? 1 : -1;
    promotionRow = team == ChessPieceTeam.white ? 7 : 0;
  }

  @override
  List<Move> getValidMoves(Chessboard currentBoard) {
    List<Move> moves = [];
    if(firstMove)
      {
        if (inBounds(row + 2*direction) && spaceEmpty(row + 2*direction, col, currentBoard)) {
          moves.add(Move(row: row + 2*direction, col: col, piece: this));
        }
      }
    // TODO: PROMOTION

    if (inBounds(row + direction) && spaceEmpty(row + direction, col, currentBoard)) {
      moves.add(Move(row: row + direction, col: col, piece: this, promotion: (row+direction == 0 || row+direction == 7)));
    }

    //taking another piece
    if(inBounds(row + direction) && inBounds(col+1) && otherTeamInSpace(row+direction, col + 1, currentBoard))
      {
        moves.add(Move(row: row+direction, col: col+1, piece: this, promotion: (row+direction == 0 || row+direction == 7)));
      }

    if(inBounds(row + direction) && inBounds(col-1) && otherTeamInSpace(row+direction, col - 1, currentBoard))
    {
      moves.add(Move(row: row+direction, col: col-1, piece: this, promotion: (row+direction == 0 || row+direction == 7)));
    }

    //TODO -- implement en passant move
    // en passant moves allow for moving diagonally and eating another pawn NEXT TO YOU if
    // a) you have accelerated three spaces
    // b) the other pawn is directly next to you and accelerated two spaces in its first move

    ChessPiece otherPiece;

    //check if space is open
    if(inBounds(col-1) && inBounds(row + direction) && spaceEmpty(row+direction, col-1, currentBoard))
    {
      //check if EnPassant is Available
      int neededRow = (team == ChessPieceTeam.white) ? 4 : 3; //white needs to be on 4, black on 5 for enpassant
      otherPiece = currentBoard.board[row][col - 1];
      if(row == neededRow && otherPiece is Pawn)
      {
        Pawn otherPawn = currentBoard.board[row][col-1] as Pawn;
        if(otherPawn.canBeEnPassanted)
        {
          print("EN PASSANT AVAILABLE");
          moves.add(PassantMove(row: row + direction, col: col - 1, piece: this));
        }
      }
    }

    //check if space is open
    if(inBounds(col+1) && inBounds(row + direction) && spaceEmpty(row+direction, col+1, currentBoard))
    {
      //check if EnPassant is Available
      int neededRow = (team == ChessPieceTeam.white) ? 4 : 3; //white needs to be on 4, black on 5 for enpassant
      otherPiece = currentBoard.board[row][col + 1];
      if(row == neededRow && otherPiece is Pawn)
      {
        Pawn otherPawn = currentBoard.board[row][col+1] as Pawn;
        if(otherPawn.canBeEnPassanted)
        {
          print("EN PASSANT AVAILABLE");
          moves.add(PassantMove(row: row + direction, col: col + 1, piece: this));
        }
      }
    }


    // if(inBounds(col - 1) && otherTeamInSpace(row, col - 1, currentBoard) && currentBoard.board[row][col-1] is Pawn)
    // {
    //   Pawn otherPawn = currentBoard.board[row][col-1] as Pawn;
    //   if(otherPawn.canBeEnPassanted)
    //   {
    //     moves.add(PassantMove(row: row, col: col-1));
    //   }
    // }


    return moves;
  }

  // need r and c for checking possible king location
  // USED SPECIFICALLY TO SEE IF MOVES ARE AVAILABLE FOR TAKING KING
  List<Move> getValidTakingMoves(Chessboard currentBoard, int r, int c) {
    List<Move> moves = [];

    //taking another piece
    if(inBounds(row + direction) && inBounds(col+1) && (otherTeamInSpace(row+direction, col + 1, currentBoard) || (row+direction == r && col+1 == c)))
    {
      moves.add(Move(row: row+direction, col: col+1, piece: this));
    }

    if(inBounds(row + direction) && inBounds(col-1) && (otherTeamInSpace(row+direction, col - 1, currentBoard) || (row+direction == r && col-1 == c)))
    {
      moves.add(Move(row: row+direction, col: col-1, piece: this));
    }

    //NO EN PASSANT FOR NON PAWN MOVES
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
  void move(Move move, Chessboard currentBoard) {
    if(firstMove && move.row == row+ 2*direction)
      {
        canBeEnPassanted = true;
      }
    else
      {
        canBeEnPassanted = false;
      }
    firstMove = false;

    if(move.enPassant)
      {
        currentBoard.removePiece(row, move.col);
        currentBoard.board[row][move.col] = Empty(row: row, col: move.col);
      }
    else if(move.promotion)
      {
        currentBoard.removePiece(move.row, move.col);
        currentBoard.removePiece(row, col);
        currentBoard.board[row][col] = Empty(row:row, col:col);
        ChessPiece promotionPiece;
        if(move.promotionType == 'b' || move.promotionType == 'B')
          {
            promotionPiece = Bishop(row: move.row, col: move.col, team: team);
          }
        else if(move.promotionType == 'n' || move.promotionType == 'N')
          {
            promotionPiece = Knight(row: move.row, col: move.col, team: team);
          }
        else if(move.promotionType == 'q' || move.promotionType == 'Q')
          {
            promotionPiece = Queen(row: move.row, col: move.col, team: team);
          }
        else
          {
            promotionPiece = Rook(row: move.row, col: move.col, team: team, firstMove: false);
          }
        currentBoard.addPiece(promotionPiece);
        print(promotionPiece);
        //don't do standard move stuff here if promotion applies
        return;
      }

    super.move(move, currentBoard);
  }

  @override
  Move buildMove(int r, int c, Chessboard currentBoard)
  {
    bool promotion = (row+direction) == promotionRow;
    return Move(row: r, col: c, piece: this, promotion: promotion);
  }

  @override
  ChessPiece copy() {
    Pawn p = Pawn(row: row, col: col, team: team, type: type);
    p.firstMove = firstMove;
    return p;
  }

}