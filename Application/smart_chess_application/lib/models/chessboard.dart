import 'package:smart_chess_application/models/chesspiece.dart';

class Chessboard
{


 List<List<ChessPiece>> board =
 [[],
 [],
 [],
 [],
 [],
 [],
 [],
 []];

 List<ChessPiece> whitePieces = [];
 List<ChessPiece> blackPieces = [];


 bool isOccupiedByOwnPieces(int x, int y, ChessPieceTeam team)
 {
  return (board[x][y].team == team);
 }

 /// Checks if a square is in check by the opposing team given a square's x and y coordinates
 bool inCheck(int x, int y, ChessPieceTeam team)
 {
   late List<ChessPiece> pieces;
   if(team == ChessPieceTeam.white)
    {
      pieces = blackPieces;
    }
   else
    {
     pieces = whitePieces;
    }

   for(ChessPiece p in pieces)
    {
     List<List<int>> moves = p.getValidMoves(this);
     for(List<int> move in moves)
      {
       if(move[0] == x && move[1] == y)
        {
         return true;
        }
      }
    }
   return false;
 }

 void removePiece(int x, int y)
 {
  ChessPiece p = board[x][y];
  if(p.team == ChessPieceTeam.black)
   {
    blackPieces.remove(p);
   }
  else
   {
    whitePieces.remove(p);
   }
 }

}