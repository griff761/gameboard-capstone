// import 'dart:html';

import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'chessboard.dart';
import 'chesspiece.dart';
import 'chesspiece_types/king.dart';
import 'chesspiece_types/pawn.dart';
import 'lights_result.dart';
import 'move.dart';

import 'package:stockfish/stockfish.dart';



/// chessboard specifically designed to integrate with hardware portion of the Capstone Project
class IntegratedChessboard extends Chessboard
{

  List<List<ChessPieceTeam>> hardware_state = List<List<ChessPieceTeam>>.generate(8, (_) => new List<ChessPieceTeam>.generate(8,(_) => ChessPieceTeam.none));

  List<List<int>> changes = [];

  LightsResult leds = LightsResult();

  bool determiningResult = false;
  bool playingWithAI = false;

  bool validMoveState = false; // if the current hardware state represents a valid move
  Move? currentMove; // valid move represented by the hardware state (if applicable)

  bool errorState = false;

  late Stockfish stockfish;
  Move? aIMove;

  bool gettingAI = false;


  final VoidCallback callback;


  Completer<void> stateUpdateCompleter = Completer<void>();

  IntegratedChessboard(this.callback)
  {
    stockfish = Stockfish();
    final stockfishSubscription = stockfish.stdout.listen((message) {
      print(message);
      if(message.startsWith('bestmove'))
        {
          List<String> outputParts = message.split(" ");
          String aIMoveString = outputParts[1];

          aIMove = decipherAIMove(aIMoveString);
          print(aIMove);

          AIChecking();

          // Complete the completer to signal that state update is done
          if (!stateUpdateCompleter.isCompleted) {
            stateUpdateCompleter.complete();
          }

          determiningResult = false;
          callback();
          determiningResult = false;
          gettingAI = false;
          print("Stockfish callback: ${determiningResult}");
        }
    });
  }



  void reset()
  {

  }

  void update_hardware_state(List<List<ChessPieceTeam>> postArray)
  {
    determiningResult = true;
    // hardware_state = postArray;
    hardware_state = List<List<ChessPieceTeam>>.generate(8, (_)=>List<ChessPieceTeam>.generate(8, (_)=>ChessPieceTeam.none));

    for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
          {
            hardware_state[i][j] = postArray[7-i][j];
          }
      }


    if(playingWithAI && turn == ChessPieceTeam.black)
      {
        AIChecking();
      }
    else
      {
        determine_spaces_changed();
        determiningResult = false;
      }
  }

  void determine_spaces_changed()
  {
    //start off invalid -> determine if valid after all calculations are done
    validMoveState = false;
    errorState = false;

    changes = [];
    for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
          {
            if(board[i][j].team != hardware_state[i][j])
              {
                // print("change: type:${board[i][j].type}, team:${board[i][j].team}\t row:$i col:$j");
                // print("hardware: ${hardware_state[i][j]}");
                changes.add([i, j]);
              }
          }
      }
    // print("CHESSBOARD CHANGES: ");
    // print(changes);

    //now determine what has happened

    print("SQUARES CHANGED: ${changes.length}");

    //CASE 0 -> no changes
    if(changes.isEmpty)
      {
        leds.reset();
      }
    //CASE 1 -> only one square has changed (a piece was picked up)
    else if(changes.length == 1)
      {

        //check if valid turn
        ChessPieceTeam pieceTeam = board[changes[0][0]][changes[0][1]].team;

        if(pieceTeam == turn)
          {
            //valid, leds with possible moves
              //get possible moves
            leds.possibleMoves(getValidPieceMoves(changes[0][0], changes[0][1]));
            // print(leds.ledArray);
          }
        else
          {
            //invalid, errorBoard
            leds.errorBoard(changes);
            errorState = true;
          }


      }
    //CASE 2 -> two squares have changed (a piece has been moved)
    else if(changes.length == 2)
      {

        ChessPiece chessPiece1 = board[changes[0][0]][changes[0][1]];
        ChessPiece chessPiece2 = board[changes[1][0]][changes[1][1]];

        //check for valid move (would consist of 1 piece of turn type, and one not of turn type)
        if(chessPiece1.team != chessPiece2.team && (chessPiece1.team == turn || chessPiece2.team == turn))
          {
            ChessPiece p1 = (chessPiece1.team==turn) ? chessPiece1 : chessPiece2; //piece of type turn
            ChessPiece p2 = (chessPiece1.team!=turn) ? chessPiece1 : chessPiece2;

            // NOTE: in the case of moving a rook to a possible castle position we do not assume

            //IF VALID MOVE => could be passant, castle, or standard (taking or not taking)
            Move m = buildGuaranteeMove(p1.row, p1.col, p2.row, p2.col);
            if((currentMove = p1.validMove(m, this)) != null)
            {

              if(currentMove!.enPassant)
                {
                  //partial enPassant -> need to pick up the other piece
                    //determine piece to be removed
                  int direction = turn == ChessPieceTeam.white ? 1 : -1;
                    //should be in end position col and end position row - direction
                  leds.continuedMoveReq([[p2.row-direction, p2.col]], changes);
                  print([p2.row-direction, p2.col]);
                }
              else if(currentMove!.castle != 0)
                {
                  // queenside
                  if(currentMove!.castle == -1)
                    {
                      List<List<int>> movesTODO = [[p1.row, 0], [p1.row, 3]];
                      leds.continuedMoveReq(movesTODO, changes);
                    }
                  else
                    {
                      List<List<int>> movesTODO = [[p1.row, 7], [p1.row, 5]];
                      leds.continuedMoveReq(movesTODO, changes);
                    }
                }
              //check if piece has been placed down (if chess piece team is none, then we took a piece off but need to replace it with our piece)
              else if(hardware_state[p2.row][p2.col] == ChessPieceTeam.none)
              {
                leds.continuedMoveReq([[p2.row, p2.col]], [[p1.row, p1.col]]);
              }
              else //TODO: do we need a check here to make sure the right team is placed or can we assume good?
              {
                validMoveState = true;
                leds.tentativeBoard(changes);
                print("valid move: now confirm");
              }
            }
            //EN PASSANT ( both pawns lifted )
            else if((p1.type == ChessPieceType.pawn && p2.type == ChessPieceType.pawn) && (p2.col == p1.col+1 || p2.col == p1.col-1))
            {
              int direction = turn == ChessPieceTeam.white ? 1 : -1;
              leds.continuedMoveReq([[p1.row + direction, p2.col]], changes);
              // print("direction: ${direction} \t p1: ${p1.row}, ${p1.col} \t p2: ${p2.row}, ${p2.col}");
              // print([p1.row, p2.col + direction]);
            }
            //OTHERWISE ERROR
            else
            {
              leds.errorBoard(changes);
            }
          }
          //CASTLING
          else if(chessPiece1.team == chessPiece2.team && chessPiece1.team == turn &&
            (chessPiece1.type == ChessPieceType.rook && chessPiece2.type == ChessPieceType.king ||
             chessPiece1.type == ChessPieceType.king && chessPiece2.type == ChessPieceType.rook))
          {
            King k = (chessPiece1.type==ChessPieceType.king) ? chessPiece1 as King: chessPiece2 as King; //piece of type turn
            ChessPiece r = (chessPiece1.type==ChessPieceType.rook) ? chessPiece1: chessPiece2;

            if(r.row == 0 && k.canQueensideCastle(this))
              {
                //valid queenside castling attempt
                List<List<int>> movesTODO = [[k.row, 2], [k.row, 3]];
                leds.continuedMoveReq(movesTODO, changes);
              }
            else if(r.row == 7 && k.canKingsideCastle(this))
              {
                //valid kingside castling attempt
                List<List<int>> movesTODO = [[k.row, 5], [k.row, 6]];
                leds.continuedMoveReq(movesTODO, changes);
              }
            else
              {
                //invalid castle attempt
                leds.errorBoard(changes);
              }
          }
          else
            {
              leds.errorBoard(changes);
            }

      }
    //CASE 3 -> SPECIAL CASE ** castling -> more than 2 pieces have been moved
    // (check for castling and show user spaces that still need to change)
    else if(changes.length == 3)
      {
        ChessPiece p1 = board[changes[0][0]][changes[0][1]];
        ChessPiece p2 = board[changes[1][0]][changes[1][1]];
        ChessPiece p3 = board[changes[2][0]][changes[2][1]];

        //EN PASSANT PRE LOGIC
        ChessPiece? ourPawn;
        ChessPiece? theirPawn;
        ChessPiece? e;
        for(int i = 0; i < 3; i++)
          {
            if(board[changes[i][0]][changes[i][1]].team == turn && board[changes[i][0]][changes[i][1]].type == ChessPieceType.pawn)
              {
                ourPawn = board[changes[i][0]][changes[i][1]];
              }
            else if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.pawn)
              {
                theirPawn = board[changes[i][0]][changes[i][1]];
              }
            else if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.empty)
              {
                e = board[changes[i][0]][changes[i][1]];
              }
          }


        //CASTLING PRE LOGIC
        King? k; //king
        ChessPiece? r; //rook
        // ChessPiece? e; //empty (where king or rook was moved)
        for(int i = 0; i < 3; i++)
          {
            if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.king && board[changes[i][0]][changes[i][1]].team == turn)
              {
                k = board[changes[i][0]][changes[i][1]] as King;
              }
            else if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.rook && board[changes[i][0]][changes[i][1]].team == turn)
              {
                r = board[changes[i][0]][changes[i][1]];
              }
            else if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.empty)
              {
                e = board[changes[i][0]][changes[i][1]];
              }
          }

        //check for en passant
        if(ourPawn != null && theirPawn != null && e != null) // if we are moving one of our pawns => then we can check for valid moves going to p2/p3 if was empty
          {
            // ChessPiece temp = p2.type == ChessPieceType.empty ? p2 : p3;
            // ChessPiece temp2 = p2.type == ChessPieceType.empty ? p3 : p2;

            Move m = buildGuaranteeMove(ourPawn.row, ourPawn.col, e.row, e.col);
            if((currentMove = ourPawn.validMove(m, this)) != null && currentMove!.enPassant) {
              List<int> enPassantSquare = currentMove?.getEnPassant() ?? [];
              if(theirPawn.row == enPassantSquare[0] && theirPawn.col == enPassantSquare[1])
                {
                  //valid completed EN PASSANT
                  validMoveState = true;
                  leds.tentativeBoard(changes);
                }
              else
                {
                  leds.errorBoard(changes);
                }
            }
            else
              {
                leds.errorBoard(changes);
              }


          }
        //check for castling
        else if(k != null && r != null && e != null)
          {
            if(r.col == 0 && k.canQueensideCastle(this) && (e.col == 2 || e.col == 3))
              {
                //valid queenside castling start -> still 1 move left
                int lastCol = e.col == 2 ? 3 : 2;
                leds.continuedMoveReq([[e.row,lastCol]], changes);

              }
            else if(r.col == 7 && k.canKingsideCastle(this) && (e.col == 5 || e.col == 6))
              {
                int lastCol = e.col == 5 ? 6 : 5;
                leds.continuedMoveReq([[e.row,lastCol]], changes);

              }
            else
              {
                //invalid
                leds.errorBoard(changes);
              }
          }
        //else error
        else
          {
            leds.errorBoard(changes);
          }
      }
    else if(changes.length == 4)
      {
        //check for castling
        // ChessPiece p1 = board[changes[0][0]][changes[0][1]];

        King? k;
        ChessPiece? r; //rook
        ChessPiece? e1;
        ChessPiece? e2;

        for(int i = 0; i < 4; i++)
          {
            if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.king && board[changes[i][0]][changes[i][1]].team == turn)
            {
              k = board[changes[i][0]][changes[i][1]] as King;
            }
            else if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.rook && board[changes[i][0]][changes[i][1]].team == turn)
            {
              r = board[changes[i][0]][changes[i][1]];
            }
            else if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.empty && e1 == null)
            {
              e1 = board[changes[i][0]][changes[i][1]];
            }
            else if(board[changes[i][0]][changes[i][1]].type == ChessPieceType.empty && e1 != null)
            {
              e2 = board[changes[i][0]][changes[i][1]];
            }
          }

        if(k != null && r != null && e1 != null && e2 != null) //all necessary pieces for castling are in changes
          {
            if(r.col == 0 && k.canQueensideCastle(this) && (e1.col == 2 || e1.col == 3)  && (e2.col == 2 || e2.col == 3) && e1.col != e2.col)
            {
              currentMove = CastleQueenside(row: k.row, col: k.col-2, piece: k);
              validMoveState = true;
              leds.tentativeBoard(changes);

            }
            else if(r.col == 7 && k.canKingsideCastle(this) && (e1.col == 5 || e1.col == 6)  && (e2.col == 5 || e2.col == 6) && e1.col != e2.col)
            {
              currentMove = CastleKingside(row: k.row, col: k.col+2, piece: k);
              validMoveState = true;
              leds.tentativeBoard(changes);

            }
            else
            {
              //invalid
              leds.errorBoard(changes);
            }
          }
        else
          {
            leds.errorBoard(changes);
          }


      }
    // ERROR STATE => should never have more than 4 pieces changed
    else
      {
        leds.errorBoard(changes);
      }

    if(!playingWithAI)
      {
        determiningResult = false;
      }

    determiningResult = false;
  }


  Move? checkForCastlingTwoChanges(ChessPiece a, ChessPiece b)
  {
    //team playing is turn
    King k = turn == ChessPieceTeam.white ? wKing : bKing;
    bool qCastle = false;
    bool kCastle = true;

    //if castling not available, just return null
    if(!(kCastle = k.canKingsideCastle(this)) && !(qCastle = k.canQueensideCastle(this)))
      {
        return null;
      }

    //check for king and rook picked up
    if(a.team == b.team && ((a.type == ChessPieceType.king && b.type == ChessPieceType.rook) || (a.type == ChessPieceType.rook && b.type == ChessPieceType.king)))
      {
        King king;
        ChessPiece other;

        if(a.type == ChessPieceType.king)
          {
            king = a as King;
            other = b;
          }
        else
          {
            king = b as King;
            other = a;
          }

        if(qCastle && other.col == 0)
        {
          print("queenside castle valid");
        }
        else if(kCastle && other.col == 7)
        {
          print("kingside castle valid");
        }
        else
        {
          print("INVALID CASTLE ATTEMPT");
        }
      }
    else if((a.team == turn  && b.team == ChessPieceTeam.none) || (a.team == ChessPieceTeam.none && b.team == turn))
      {
        if(a.type == ChessPieceType.king || b.type == ChessPieceType.king)
          {
            King king;
            ChessPiece other;
            if(a.type == ChessPieceType.king)
            {
              king = a as King;
              other = b;
            }
            else
            {
              king = b as King;
              other = a;
            }


            if(qCastle && b.row == a.row && b.col == (a.col-2))
              {
                //queenside castle valid
              }
            else if(kCastle && b.row == a.row && b.col == (a.col+2))
              {
                //kingside castle valid
              }
            else
              {
                //INVALID
              }
          }
        else if(a.type == ChessPieceType.rook)
          {

          }
        else if(b.type == ChessPieceType.rook)
          {

          }
        else
          {
            //INVALID
          }
      }
    //check for king picked up and placed in castle spot
    //check for rook picked up and placed in castle spot
  }


  Move buildGuaranteeMove(int r1, int c1, int r2, int c2)
  {
    return board[r1][c1].buildMove(r2, c2, this);
  }


  Move? needPromotionDialogue()
  {
    if(validMoveState && currentMove!.promotion)
      {
        return currentMove;
      }
    else
      {
        return null;
      }
  }


  bool confirmMove()
  {
    print("confirming move");
    determiningResult = true;
    if(!validMoveState) {
      return false;
    }

    print("Promotion: ${currentMove!.promotion}");
    if(playingWithAI && turn == ChessPieceTeam.black)
      {
        stateUpdateCompleter = Completer<void>();
      }
    print(move(currentMove!)?.lAN);
    currentMove = null;
    validMoveState = false;

    //CHECK CHECKMATE
    if(kingInCheck())
      {
        bool checkmate = true;
        List<ChessPiece> pieces = turn == ChessPieceTeam.white ? whitePieces : blackPieces;
        for(ChessPiece p in pieces)
          {
            if(getValidPieceMoves(p.row, p.col).length > 0)
              {
                checkmate = false;
              }
          }
        if(checkmate)
          {
            print("checkmate found");
            leds.checkmate();
            determiningResult = false;
            return true;
          }
        else
          {
            print("check, no checkmate");
          }
      }

    if(playingWithAI && turn == ChessPieceTeam.black)
      {
        getAIMove();
      }

    leds.reset();

    determiningResult = false;
    return true;

  }


  void getAIMove()
  {
    determiningResult = true;
    stockfish.stdin = getBoardStateForAI();
    stockfish.stdin = 'go movetime 500';
  }

  void AIChecking()
  {
    //AI MOVE IS STORED IN aiMove
    validMoveState = false;

    changes = [];
    for(int i = 0; i < 8; i++)
    {
      for(int j = 0; j < 8; j++)
      {
        if(board[i][j].team != hardware_state[i][j])
        {

          // print("change: type:${board[i][j].type}, team:${board[i][j].team}\t row:$i col:$j");
          // print("hardware: ${hardware_state[i][j]}");
          changes.add([i, j]);
        }
      }
    }

    //handle LEDs for AI move
    List<List<int>> changesInfo = [];
    for(int i = 0; i< changes.length; i++)
    {
      int pieceRep = 0;

      if(hardware_state[changes[i][0]][changes[i][1]] == ChessPieceTeam.white)
      {
        pieceRep = 1;
      }
      else if(hardware_state[changes[i][0]][changes[i][1]] == ChessPieceTeam.black)
      {
        pieceRep = -1;
      }
      else if(hardware_state[changes[i][0]][changes[i][1]] == ChessPieceTeam.none)
      {
        pieceRep = 0;
      }

      changesInfo.add([changes[i][0], changes[i][1], pieceRep]);
    }

    bool takingPiece = board[aIMove!.row][aIMove!.col].type != ChessPieceType.empty;
    leds.AIMove(aIMove!, changesInfo, takingPiece);

    //determine if valid state
    // if(changes.length == 2)
    currentMove = aIMove;
    validMoveState = determineAIMoveCompletion();
    determiningResult = false;
  }


  bool determineAIMoveCompletion()
  {
    // List<List<int>> neededChanges = [];
    if(aIMove!.enPassant)
      {
        //check initial piece, ending pawn location, removed enemy pawn
        if(hardware_state[aIMove!.row][aIMove!.col] == turn &&
            hardware_state[aIMove!.piece.row][aIMove!.piece.col] == ChessPieceTeam.none &&
            hardware_state[aIMove!.piece.row][aIMove!.col] == ChessPieceTeam.none
            && changes.length == 3)
          {
            return true;
          }
        else
          {
            return false;
          }

      }
    else if(aIMove!.castle == -1)
      {
        //check new and old rook, new and old king
        if(hardware_state[aIMove!.row][aIMove!.col] == turn && //king
            hardware_state[aIMove!.row][3] == turn && //rook
            hardware_state[aIMove!.piece.row][aIMove!.piece.col] == ChessPieceTeam.none && //old king
            hardware_state[aIMove!.piece.row][0] == ChessPieceTeam.none
            && changes.length == 4) //old rook
        {
          return true;
        }
        else
        {
          return false;
        }
      }
    else if(aIMove!.castle == 1)
      {
        //check new and old rook, new and old king
        if(hardware_state[aIMove!.row][aIMove!.col] == turn && //king
            hardware_state[aIMove!.row][5] == turn && //rook
            hardware_state[aIMove!.piece.row][aIMove!.piece.col] == ChessPieceTeam.none && //old king
            hardware_state[aIMove!.piece.row][7] == ChessPieceTeam.none
            && changes.length == 4) //old rook
            {
          return true;
        }
        else
        {
          return false;
        }
      }
    else //standard move
      {
      //check new and old rook, new and old king
      if(hardware_state[aIMove!.row][aIMove!.col] == turn && //new spot
          hardware_state[aIMove!.piece.row][aIMove!.piece.col] == ChessPieceTeam.none
          && changes.length == 2) //old spot
        {
          return true;
        }
        else
        {
          return false;
        }
      }
  }

}