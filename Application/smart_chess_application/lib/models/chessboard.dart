import 'package:smart_chess_application/models/chesspiece.dart';
import 'package:smart_chess_application/models/chesspiece_types/bishop.dart';
import 'package:smart_chess_application/models/chesspiece_types/king.dart';
import 'package:smart_chess_application/models/chesspiece_types/knight.dart';
import 'package:smart_chess_application/models/chesspiece_types/pawn.dart';
import 'package:smart_chess_application/models/chesspiece_types/queen.dart';
import 'package:smart_chess_application/models/chesspiece_types/rook.dart';

import 'chesspiece_types/empty.dart';

class Chessboard
{



 /*
 



  */
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

 ChessPiece wKing = Empty(xPos: -1,yPos: -1);
 ChessPiece bKing = Empty(xPos: -1,yPos: -1);



 /*
 Sets up chessboard in standard format
  */
 Chessboard()
 {
  //empty spaces
  for(int i = 2; i <= 5; i++)
   {
    for(int j = 0; j < 8; j++)
     {
      board[i].add(Empty(xPos:i, yPos:j));
     }
   }
  //setup pawns
  for(int i = 0; i < 8; i++)
   {
    board[1].add(Pawn(xPos: 1, yPos: i, team: team));
   }
 }

 void empty()
 {
board =
  [[],
   [],
   [],
   [],
   [],
   [],
   [],
   []];

  for(int i = 0; i < 8; i++)
   {
    for(int j = 0; j < 8; j++)
     {
      board[i].add(Empty(xPos: i, yPos: j));
     }
   }

  List<ChessPiece> whitePieces = [];
  List<ChessPiece> blackPieces = [];
 }


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