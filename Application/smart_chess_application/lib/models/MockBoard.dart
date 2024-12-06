// import 'package:smart_chess_application/models/chesspiece.dart';
// import 'package:smart_chess_application/models/chesspiece_types/bishop.dart';
// import 'package:smart_chess_application/models/chesspiece_types/king.dart';
// import 'package:smart_chess_application/models/chesspiece_types/knight.dart';
// import 'package:smart_chess_application/models/chesspiece_types/pawn.dart';
// import 'package:smart_chess_application/models/chesspiece_types/queen.dart';
// import 'package:smart_chess_application/models/chesspiece_types/rook.dart';
// import 'package:smart_chess_application/models/move.dart';
//
// import 'chessboard.dart';
// import 'chesspiece_types/empty.dart';
//
// class MockChessboard
// {
//
//
//   List<List<ChessPiece>> board =
//   [[],
//     [],
//     [],
//     [],
//     [],
//     [],
//     [],
//     []];
//
//   List<ChessPiece> whitePieces = [];
//   List<ChessPiece> blackPieces = [];
//
//   King wKing = King(row: -1,col: -1, team: ChessPieceTeam.none);
//   King bKing = King(row: -1,col: -1, team: ChessPieceTeam.none);
//
//
//
//   /*
//  Sets up chessboard in standard format
//   */
//   MockChessboard(Chessboard c) {
//     whitePieces = [];
//     blackPieces = [];
//
//     for (int i = 0; i < 8; i++) {
//       for (int j = 0; j < 8; j++) {
//         board[i][j] = c.board[i][j].copy();
//         if (board[i][j].team == ChessPieceTeam.white) {
//           whitePieces.add(board[i][j]);
//           if (board[i][j].type == ChessPieceType.king) {
//             wKing = board[i][j] as King;
//           }
//         }
//         else if (board[i][j].team == ChessPieceTeam.black) {
//           blackPieces.add(board[i][j]);
//           if (board[i][j].type == ChessPieceType.king) {
//             bKing = board[i][j] as King;
//           }
//         }
//       }
//     }
//   }
//
//   void mockMove(Move move)
//   {
//     // m.piece.move(m, this);
//
//     if(move.piece is Pawn)
//       {
//         if((move.piece as Pawn).firstMove && move.row == (move.piece as Pawn).row+ 2*(move.piece as Pawn).direction)
//         {
//           (move.piece as Pawn).canBeEnPassanted = true;
//         }
//         else
//         {
//           (move.piece as Pawn).canBeEnPassanted = false;
//         }
//         (move.piece as Pawn).firstMove = false;
//
//         if(move.enPassant)
//         {
//           removePiece(move.piece.row, move.col);
//           board[move.piece.row][move.col] = Empty(row: move.piece.row, col: move.col);
//         }
//         else if(move.promotion)
//         {
//           removePiece(move.row, move.col);
//           removePiece(move.piece.row, move.piece.col);
//           board[move.piece.row][move.piece.col] = Empty(row:move.piece.row, col:move.piece.col);
//           ChessPiece promotionPiece;
//           if(move.promotionType == 'b' || move.promotionType == 'B')
//           {
//             promotionPiece = Bishop(row: move.row, col: move.col, team: move.piece.team);
//           }
//           else if(move.promotionType == 'n' || move.promotionType == 'N')
//           {
//             promotionPiece = Knight(row: move.row, col: move.col, team: move.piece.team);
//           }
//           else if(move.promotionType == 'q' || move.promotionType == 'Q')
//           {
//             promotionPiece = Queen(row: move.row, col: move.col, team: move.piece.team);
//           }
//           else
//           {
//             promotionPiece = Rook(row: move.row, col: move.col, team: move.piece.team, firstMove: false);
//           }
//           addPiece(promotionPiece);
//           print(promotionPiece);
//           //don't do standard move stuff here if promotion applies
//           return;
//         }
//       }
//
//     removePiece(move.row, move.col);
//     board[move.piece.row][move.piece.col] = Empty(row: move.piece.row, col: move.piece.col);
//     board[move.row][move.col] = move.piece;
//     move.piece.row = move.row;
//     move.piece.col = move.col;
//
//     if(move.piece is King)
//       {
//         (move.piece as King).firstMove = false;
//
//         if(move.castle == 1) //kingside castle
//             {
//           Rook r = board[move.piece.row][7] as Rook;
//           board[move.piece.row][5] = r;
//           r.col = 5;
//           board[move.piece.row][7] = Empty(row:move.piece.row, col:7);
//         }
//         else if(move.castle == -1) //queenside castle
//             {
//           Rook r = board[move.piece.row][0] as Rook;
//           board[move.piece.row][3] = r;
//           r.col = 3;
//           board[move.piece.row][0] = Empty(row:move.piece.row, col:0);
//         }
//       }
//     else if(move.piece is Rook)
//       {
//         (move.piece as Rook).firstMove = false;
//       }
//
//
//
//   }
//
//
//
//   bool isOccupiedByOwnPieces(int row, int col, ChessPieceTeam team)
//   {
//     return (board[row][col].team == team);
//   }
//
//   /// Checks if a square is in check by the opposing team given a square's x and y coordinates
//   bool inCheck(int row, int col, ChessPieceTeam team)
//   {
//     late List<ChessPiece> pieces;
//     if(team == ChessPieceTeam.white)
//     {
//       pieces = blackPieces;
//     }
//     else
//     {
//       pieces = whitePieces;
//     }
//
//     for(ChessPiece p in pieces)
//     {
//       List<Move> moves = [];
//       if(p is Pawn)
//       {
//         moves = (p as Pawn).getValidTakingMoves(this, row, col);
//       }
//       else if(p is King)
//       {
//         moves = (p as King).getMovesForCheck(this);
//       }
//       else if(p is Rook)
//       {
//         moves = (p as Rook).getMovesforCheck(this);
//       }
//       else
//       {
//         moves = p.getValidMoves(this);
//       }
//
//       for(Move move in moves)
//       {
//         if(move.row == row && move.col == col)
//         {
//           return true;
//         }
//       }
//     }
//     return false;
//   }
//
//   void removePiece(int row, int col)
//   {
//     ChessPiece p = board[row][col];
//     if(p.team == ChessPieceTeam.none)
//     {
//       return;
//     }
//     else if(p.team == ChessPieceTeam.black)
//     {
//       blackPieces.remove(p);
//     }
//     else
//     {
//       whitePieces.remove(p);
//     }
//   }
//
//   void addPiece(ChessPiece p)
//   {
//     if(p.team == ChessPieceTeam.none)
//     {
//       return;
//     }
//     else if(p.team == ChessPieceTeam.black)
//     {
//       blackPieces.remove(p);
//     }
//     else
//     {
//       whitePieces.remove(p);
//     }
//     board[p.row][p.col] = p;
//   }
//
//
//   Move? move(Move inputMove)
//   {
//
//     if(requireTurns && turn != inputMove.piece.team)
//     {
//       return null;
//     }
//
//     //get chesspiece
//     ChessPiece piece =inputMove.piece;
//     Move? move;
//     if((move = piece.validMove(inputMove, this)) != null)
//     {
//       // removePiece(r2, c2);
//       //evaluate
//       move?.evaluate(this);
//       allMoves.add(move?.lAN ?? "");
//       //make move
//       piece.move(move!, this);
//       changeTurn();
//       return move;
//     }
//     else
//     {
//       return null;
//     }
//   }
//
//   Move? buildMove(int r1, int c1, int r2, int c2)
//   {
//     if(r1 == r2 && c1 == c2)
//     {
//       return null;
//     }
//     return board[r1][c1].buildMove(r2, c2, this);
//   }
//
//
//   void changeTurn()
//   {
//     // print("START CHANGE TURN: " + turn.toString());
//
//     if (turn == ChessPieceTeam.white)
//     {
//       turn = ChessPieceTeam.black;
//     }
//     else
//     {
//       turn = ChessPieceTeam.white;
//     }
//     // print("CHANGE TURN: " + turn.toString());
//   }
//
//   @override
//   String toString()
//   {
//     String boardRepresentation = "";
//     int emptyCount = 0;
//     for(int i = 7; i>=0; i--)
//     {
//       for(int j = 0; j < 8; j++)
//       {
//         String piece = board[i][j].getSymbol();
//         if(piece == "")
//         {
//           emptyCount++;
//         }
//         else
//         {
//           if(emptyCount != 0)
//           {
//             boardRepresentation += emptyCount.toString();
//           }
//           boardRepresentation += piece;
//           emptyCount = 0;
//         }
//       }
//       if(emptyCount != 0)
//       {
//         boardRepresentation += emptyCount.toString();
//       }
//       emptyCount = 0;
//       if(i >0)
//       {
//         boardRepresentation += "/";
//       }
//     }
//     return boardRepresentation;
//   }
//
//
//   String getBoardStateForAI()
//   {
//     String boardState = "position startpos moves";
//     for(String move in allMoves)
//     {
//       boardState += " " + move;
//     }
//     return boardState;
//   }
//
//   Move? decipherAIMove(String aiMove)
//   {
//     List<String> chars = aiMove.split('');
//     int r1 = int.parse(chars[1])-1;
//     int c1 = _getColFromLetter(chars[0]);
//     int r2 = int.parse(chars[3])-1;
//     int c2 = _getColFromLetter(chars[2]);
//
//     Move? m1 = buildMove(r1, c1, r2, c2); //get initial move
//     return board[r1][c1].validMove(m1!, this);
//   }
//
//   int _getColFromLetter(String letter)
//   {
//     switch(letter)
//     {
//       case('a'):
//         return 0;
//       case('b'):
//         return 1;
//       case('c'):
//         return 2;
//       case('d'):
//         return 3;
//       case('e'):
//         return 4;
//       case('f'):
//         return 5;
//       case('g'):
//         return 6;
//       case('h'):
//         return 7;
//     }
//     return -1;
//   }
//
//
// }