import 'package:smart_chess_application/models/chesspiece.dart';
import 'package:smart_chess_application/models/chesspiece_types/bishop.dart';
import 'package:smart_chess_application/models/chesspiece_types/king.dart';
import 'package:smart_chess_application/models/chesspiece_types/knight.dart';
import 'package:smart_chess_application/models/chesspiece_types/pawn.dart';
import 'package:smart_chess_application/models/chesspiece_types/queen.dart';
import 'package:smart_chess_application/models/chesspiece_types/rook.dart';
import 'package:smart_chess_application/models/move.dart';

import 'chesspiece_types/empty.dart';

class Chessboard
{

 bool requireTurns = true;

 //list of all moves in long algebraic notation
 List<String> allMoves = [];

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

 King wKing = King(row: -1,col: -1, team: ChessPieceTeam.none);
 King bKing = King(row: -1,col: -1, team: ChessPieceTeam.none);

 ChessPieceTeam turn = ChessPieceTeam.white;


 /*
 Sets up chessboard in standard format
  */
 Chessboard()
 {
  setup();
 }

 void setup()
 {

  turn = ChessPieceTeam.white;

  allMoves = [];
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
  board[7].add(Rook(row: 7, col: 0, team: ChessPieceTeam.black));
  //knight 1
  board[0].add(Knight(row: 0, col: 1, team: ChessPieceTeam.white));
  board[7].add(Knight(row: 7, col: 1, team: ChessPieceTeam.black));
  //bishop 1
  board[0].add(Bishop(row: 0, col: 2, team: ChessPieceTeam.white));
  board[7].add(Bishop(row: 7, col: 2, team: ChessPieceTeam.black));
  //queen
  board[0].add(Queen(row: 0, col: 3, team: ChessPieceTeam.white));
  board[7].add(Queen(row: 7, col: 3, team: ChessPieceTeam.black));
  //king
  board[0].add(King(row: 0, col: 4, team: ChessPieceTeam.white));
  board[7].add(King(row: 7, col: 4, team: ChessPieceTeam.black));
  //bishop 2
  board[0].add(Bishop(row: 0, col: 5, team: ChessPieceTeam.white));
  board[7].add(Bishop(row: 7, col: 5, team: ChessPieceTeam.black));
  //knight 2
  board[0].add(Knight(row: 0, col: 6, team: ChessPieceTeam.white));
  board[7].add(Knight(row: 7, col: 6, team: ChessPieceTeam.black));
  //rook 1
  board[0].add(Rook(row: 0, col: 7, team: ChessPieceTeam.white));
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

  wKing = board[0][4] as King;
  bKing = board[7][4] as King;
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
  wKing = King(row: -1,col: -1, team: ChessPieceTeam.none);
  bKing = King(row: -1,col: -1, team: ChessPieceTeam.none);
 }

 bool kingInCheck()
 {
  King k = turn == ChessPieceTeam.white ? wKing : bKing;
  return inCheck(k.row, k.col, k.team);
 }

 List<Move> getValidPieceMoves(int row, int col)
 {
  King k = turn == ChessPieceTeam.white ? wKing : bKing;
  if(inCheck(k.row, k.col, k.team))
   {
    print("${turn} in check *** (getValidPieceMoves)");
    List<Move> moves = board[row][col].getValidMoves(this);
    List<Move> validMoves = [];
    for(Move m in moves)
    {
      Chessboard temp = clone();
      Move cloneM = m.clone();
      cloneM.piece = temp.board[cloneM.piece.row][cloneM.piece.col];
      temp.forceMove(cloneM);

      print("*****************");
      print("PIECE NEW COORDS: row: ${cloneM.piece.row}  col: ${cloneM.piece.col}");
      print("*****************");

      print("board state: ${temp.toString()}");

      if(!temp.kingInCheck())
       {
        validMoves.add(m);
        print("FOUND AVAIL MOVE: Move ${cloneM.piece} to ${cloneM.row}, ${cloneM.col}");
       }
      else
       {
        print("Move ${cloneM.piece} to ${cloneM.row}, ${cloneM.col} not valid");
       }
    }
    return validMoves;
   }

  return board[row][col].getValidMoves(this);
 }





 bool isOccupiedByOwnPieces(int row, int col, ChessPieceTeam team)
 {
  return (board[row][col].team == team);
 }

 /// Checks if a square is in check by the opposing team given a square's x and y coordinates
 bool inCheck(int row, int col, ChessPieceTeam team)
 {
  print("row: $row, col: $col, team: $team");
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
     List<Move> moves = [];
     if(p is Pawn)
      {
       moves = (p as Pawn).getValidTakingMoves(this, row, col);
      }
     else if(p is King)
      {
       moves = (p as King).getMovesForCheck(this);
      }
     else if(p is Rook)
      {
       moves = (p as Rook).getMovesforCheck(this);
      }
     else
      {
       moves = p.getValidMoves(this);
      }

     for(Move move in moves)
      {
       if(move.row == row && move.col == col)
        {
         print("IN CHECK: piece: ${move.piece}\trow:$row\tcol:$col");
         return true;
        }
      }
    }
   return false;
 }

 void removePiece(int row, int col)
 {
  ChessPiece p = board[row][col];
  if(p.team == ChessPieceTeam.none)
   {
    return;
   }
  else if(p.team == ChessPieceTeam.black)
   {
    blackPieces.remove(p);
   }
  else
   {
    whitePieces.remove(p);
   }
 }

 void addPiece(ChessPiece p)
 {
  if(p.team == ChessPieceTeam.none)
  {
   return;
  }
  else if(p.team == ChessPieceTeam.black)
  {
   blackPieces.remove(p);
  }
  else
  {
   whitePieces.remove(p);
  }
  board[p.row][p.col] = p;
 }


 Move? move(Move inputMove)
 {

  if(requireTurns && turn != inputMove.piece.team)
  {
   return null;
  }

  //get chesspiece
  ChessPiece piece =inputMove.piece;
  Move? move;
  if((move = piece.validMove(inputMove, this)) != null)
   {
    //if king is in check , we need to do extra checking
////////////////////////////////////////////////////////////////////////////////
   King k = turn == ChessPieceTeam.white ? wKing : bKing;
   if(inCheck(k.row, k.col, k.team))
   {
    print("${turn} in check ***");

     Chessboard temp = clone();
     Move cloneM = move!.clone();
     cloneM.piece = temp.board[cloneM.piece.row][cloneM.piece.col];
     temp.forceMove(cloneM);

     if(temp.kingInCheck())
     {
      return null;
     }
    }


    // removePiece(r2, c2);
    //evaluate
    move?.evaluate(this);
    allMoves.add(move?.lAN ?? "");
    //make move
    piece.move(move!, this);
    changeTurn();
    return move;
   }
  else
   {
    return null;
   }
 }

 Move? buildMove(int r1, int c1, int r2, int c2)
 {
  if(r1 == r2 && c1 == c2)
  {
    return null;
  }
  return board[r1][c1].buildMove(r2, c2, this);
 }


 void changeTurn()
 {
  // print("START CHANGE TURN: " + turn.toString());

  if (turn == ChessPieceTeam.white)
   {
    turn = ChessPieceTeam.black;
   }
  else
   {
    turn = ChessPieceTeam.white;
   }
  // print("CHANGE TURN: " + turn.toString());
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


 String getBoardStateForAI()
 {
  String boardState = "position startpos moves";
  for(String move in allMoves)
   {
    boardState += " " + move;
   }
  return boardState;
 }

 Move? decipherAIMove(String aiMove)
 {
  List<String> chars = aiMove.split('');
  int r1 = int.parse(chars[1])-1;
  int c1 = _getColFromLetter(chars[0]);
  int r2 = int.parse(chars[3])-1;
  int c2 = _getColFromLetter(chars[2]);

  Move? m1 = buildMove(r1, c1, r2, c2); //get initial move
  return board[r1][c1].validMove(m1!, this);
 }

 int _getColFromLetter(String letter)
 {
  switch(letter)
  {
   case('a'):
    return 0;
   case('b'):
    return 1;
   case('c'):
    return 2;
   case('d'):
    return 3;
   case('e'):
    return 4;
   case('f'):
    return 5;
   case('g'):
    return 6;
   case('h'):
    return 7;
  }
  return -1;
 }


 /// FOR DETERMINING CHECK MOVES
 Chessboard clone()
 {
  Chessboard clone = Chessboard();

  clone.empty();

  for(int i = 0; i < 8; i++)
   {
    for(int j = 0; j < 8; j++)
     {
      clone.board[i][j] = board[i][j].copy();

      if (board[i][j].team == ChessPieceTeam.white) {
          clone.whitePieces.add(clone.board[i][j]);
          if (board[i][j].type == ChessPieceType.king) {
           clone.wKing = clone.board[i][j] as King;
          }
       }
        else if (board[i][j].team == ChessPieceTeam.black) {
        clone.blackPieces.add(clone.board[i][j]);
          if (board[i][j].type == ChessPieceType.king) {
           clone.bKing =clone. board[i][j] as King;
          }
        }
     }
   }
 clone.turn = turn;
  // board + white / black + kings

  return clone;
 }


 /// FOR DETERMINING CHECK MOVES
 Move forceMove(Move inputMove)
  {
   //get chesspiece
   ChessPiece piece =inputMove.piece;
   // Move? move;

    // removePiece(r2, c2);
    //evaluate
   inputMove.evaluate(this);
   print("FORCEMOVE: ${inputMove.lAN}");
    // allMoves.add(inputMove?.lAN ?? "");
    //make move
    piece.move(inputMove, this);
    print("newPos: ${inputMove.piece.row}\t${inputMove.piece.col}");
    // changeTurn();
    return inputMove;
  }

}