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

 ChessPiece wKing = Empty(row: -1,col: -1);
 ChessPiece bKing = Empty(row: -1,col: -1);



 /*
 Sets up chessboard in standard format
  */
 Chessboard()
 {
  setup();
 }

 void setup()
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
  //empty spaces
  for(int i = 2; i <= 5; i++)
  {
   for(int j = 0; j < 8; j++)
   {
    board[i].add(Empty(row:i, col:j));
   }
  }
  //setup pawns
  for(int i = 0; i < 8; i++)
  {
   board[1].add(Pawn(row: 1, col: i, team: ChessPieceTeam.white));
   board[6].add(Pawn(row: 6, col: i, team: ChessPieceTeam.black));
  }
  //setup other pieces

  //rook 1
  board[0].add(Rook(row: 0, col: 0, team: ChessPieceTeam.white));
  board[7].add(Rook(row: 0, col: 7, team: ChessPieceTeam.black));
  //knight 1
  board[0].add(Knight(row: 1, col: 0, team: ChessPieceTeam.white));
  board[7].add(Knight(row: 1, col: 7, team: ChessPieceTeam.black));
  //bishop 1
  board[0].add(Bishop(row: 2, col: 0, team: ChessPieceTeam.white));
  board[7].add(Bishop(row: 2, col: 7, team: ChessPieceTeam.black));
  //queen
  board[0].add(Queen(row: 3, col: 0, team: ChessPieceTeam.white));
  board[7].add(Queen(row: 3, col: 7, team: ChessPieceTeam.black));
  //king
  board[0].add(King(row: 4, col: 0, team: ChessPieceTeam.white));
  board[7].add(King(row: 4, col: 7, team: ChessPieceTeam.black));
  //bishop 2
  board[0].add(Bishop(row: 5, col: 0, team: ChessPieceTeam.white));
  board[7].add(Bishop(row: 5, col: 7, team: ChessPieceTeam.black));
  //knight 2
  board[0].add(Knight(row: 6, col: 0, team: ChessPieceTeam.white));
  board[7].add(Knight(row: 6, col: 7, team: ChessPieceTeam.black));
  //rook 1
  board[0].add(Rook(row: 7, col: 0, team: ChessPieceTeam.white));
  board[7].add(Rook(row: 7, col: 7, team: ChessPieceTeam.black));

  //setup extra trackers (for us)

  whitePieces = [];
  blackPieces = [];
  for(int i = 0; i < 8; i++)
   {
    whitePieces.add(board[0][i]);
    whitePieces.add(board[1][i]);

    blackPieces.add(board[6][i]);
    blackPieces.add(board[7][i]);
   }

  wKing = board[4][0];
  bKing = board[4][7];
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
      board[i].add(Empty(row: i, col: j));
     }
   }

  whitePieces = [];
  blackPieces = [];
  wKing = Empty(row: -1,col: -1);
  bKing = Empty(row: -1,col: -1);
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


 bool move(int x1, int y1, int x2, int y2)
 {
  //get chesspiece
  ChessPiece piece = board[x1][y1];
  if(piece.validMove(x2, y2, this))
   {
    removePiece(x2, y2);
    //make move
    piece.move(x2, y2, this);
    return true;
   }
  else
   {
    return false;
   }
 }

 @override
  String toString()
 {
  String boardRepresentation = "";
  int emptyCount = 0;
  for(int i = 7; i>=0; i--)
  {
   for(int j = 0; j < 8; j++)
   {
    String piece = board[i][j].getSymbol();
    if(piece == "")
    {
     emptyCount++;
    }
    else
    {
     if(emptyCount != 0)
     {
      boardRepresentation += emptyCount.toString();
     }
     boardRepresentation += piece;
     emptyCount = 0;
    }
   }
   if(emptyCount != 0)
   {
    boardRepresentation += emptyCount.toString();
   }
   emptyCount = 0;
   if(i >0)
   {
     boardRepresentation += "/";
   }
  }
  return boardRepresentation;
 }

}