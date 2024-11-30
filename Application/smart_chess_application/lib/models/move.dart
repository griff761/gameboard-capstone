

import 'chessboard.dart';
import 'chesspiece.dart';
import 'chesspiece_types/pawn.dart';

class Move
{
  ChessPiece piece;

  int row = -1;
  int col = -1;

  int castle = 0; // 0 if no castle, 1 if kingside, -1 if queenside
  bool promotion = false;
  bool enPassant = false;

  // bool capture = false;
  // String algebraicNotation = "";

  String promotionType = "";


  String lAN = "";

  Move({required this.row, required this.col, this.castle = 0, this.promotion = false, this.enPassant = false, this.promotionType = "", required this.piece});

  // // TODO: checkmate?
  // updateNotation(bool check)
  // {
  //   if(check)
  //     algebraicNotation += "+";
  // }

  void evaluate(Chessboard chessboard)
  {
    if(castle == 1)
      {
        lAN = 'e${row+1}g${row+1}';
      }
    else if(castle == -1)
      {
        lAN = 'e${row+1}c${row+1}';
      }
    else
      {
        lAN = getColLetter(piece.col) + (piece.row+1).toString() + getColLetter(col) + (row+1).toString();
        if(promotion)
          lAN += promotionType;
      }


  }


  // void getAlgebraicNotation(Chessboard chessboard)
  // {
  //   if(castle == 1)
  //     {
  //       algebraicNotation = "0-0";
  //       return;
  //     }
  //   if(castle == -1)
  //     {
  //       algebraicNotation = "0-0-0";
  //       return;
  //     }
  //   // STANDARD MOVE CASE:
  //   String pieceName = piece.getSymbol();
  //   //check if other pieces of same type and team can make that move
  //   List<ChessPiece> chesspieces = piece.team == ChessPieceTeam.white ? chessboard.whitePieces : chessboard.blackPieces;
  //   for(ChessPiece p in chesspieces)
  //   {
  //     //check for same type of piece but not SAME PIECE and piece can make same move
  //     if (p.type == piece.type && p != piece && (p.validMove(this, chessboard) != null))
  //     {
  //       if(p.col == piece.col)
  //       {
  //         pieceName += (piece.row+1).toString();
  //       }
  //       else
  //       {
  //         pieceName += getColLetter(piece.col);
  //       }
  //     }
  //   }
  //   String captureString = capture ? "x" : "";
  //   algebraicNotation = pieceName + captureString + getColLetter(col) + (row+1).toString();
  // }


  String getColLetter(int col)
  {
    switch(col)
    {
      case(0):
        return 'a';
      case(1):
        return 'b';
      case(2):
        return 'c';
      case(3):
        return 'd';
      case(4):
        return 'e';
      case(5):
        return 'f';
      case(6):
        return 'g';
      case(7):
        return 'h';
    }
    return '';
  }
}

class PassantMove extends Move
{
  PassantMove({required super.row, required super.col, required super.piece, super.castle = 0, super.promotion = false, super.enPassant = true});
  int getPassantRow()
  {
    return row - (piece as Pawn).direction;
  }
}

class CastleKingside extends Move
{
  CastleKingside({required super.row, required super.col, required super.piece, super.castle = 1, super.promotion = false, super.enPassant = false});
}

class CastleQueenside extends Move
{
  CastleQueenside({required super.row, required super.col, required super.piece, super.castle = -1, super.promotion = false, super.enPassant = false});
}

class PromotionMove extends Move
{
  PromotionMove({required super.row, required super.col, required super.piece, super.castle = 0, super.promotion = true, super.enPassant = false, required super.promotionType});
}