import 'chessboard.dart';
import 'chesspiece.dart';
import 'chesspiece_types/king.dart';
import 'lights_result.dart';
import 'move.dart';

/// chessboard specifically designed to integrate with hardware portion of the Capstone Project
class IntegratedChessboard extends Chessboard
{

  List<List<ChessPieceTeam>> hardware_state = List<List<ChessPieceTeam>>.generate(8, (_) => new List<ChessPieceTeam>.generate(8,(_) => ChessPieceTeam.none));

  List<List<int>> changes = [];

  LightsResult leds = LightsResult();

  bool determiningResult = false;
  bool playingWithAI = false;

  bool validMoveState = false;
  Move? currentMove = null;

  bool errorState = false;




  void update_hardware_state(List<List<ChessPieceTeam>> postArray)
  {
    determiningResult = true;
    hardware_state = postArray;
    determine_spaces_changed();
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
    if(changes.length == 0)
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
          //get pieces that changed
        ChessPiece chessPiece1 = board[changes[0][0]][changes[0][1]];
        ChessPiece chessPiece2 = board[changes[1][0]][changes[0][1]];
          //find (first) one that is on our team
        ChessPiece? ourPiece = null;
        ChessPiece otherPiece = chessPiece1;
        if(chessPiece1.team == turn) {
          ourPiece = chessPiece1;
          otherPiece = chessPiece2;
        } else if(chessPiece2.team == turn) {
          ourPiece = chessPiece2;
          otherPiece = chessPiece1;
        }

        //if neither piece is ours -> error state
        if(ourPiece == null)
          {
            leds.errorBoard(changes);
            errorState = true;
          }
        else
          {
            //check for castling
              //check for king and rook picked up
              //check for king picked up and placed in castle spot
              //check for rook picked up and placed in castle spot
            // if(chessPiece1 is )


            //check for en passant
              //check for pawn picked up and placed in en passant spot
              //check for pawn picked up and en passant capture picked up

            //COMPLETE MOVE? -> tentative move set and valid game state!
            Move m = buildGuaranteeMove(ourPiece.row, ourPiece.col, otherPiece.row, otherPiece.col);
            if((currentMove = ourPiece.validMove(m, this)) != null)
              {
                validMoveState = true;
                leds.tentativeBoard(changes);
                print("valid move: now confirm");
              }
          }


      }
    //CASE 3 -> SPECIAL CASE ** castling -> more than 2 pieces have been moved
    // (check for castling and show user spaces that still need to change)
    else if(changes.length > 2)
      {
        //check for castling

        //check for en passant

      }

    if(!playingWithAI)
      {
        determiningResult = false;
      }

  }


  // Move? checkForCastlingTwoChanges(ChessPiece a, ChessPiece b)
  // {
  //   //check for king and rook picked up
  //   if(a.team == b.team && ((a.type == ChessPieceType.king && b.type == ChessPieceType.rook) || (a.type == ChessPieceType.rook && b.type == ChessPieceType.king)))
  //     {
  //       if(a.type == ChessPieceType.king)
  //         {
  //           if((a as King).canQueensideCastle(this) && b.col == 0)
  //             {
  //
  //             }
  //         }
  //       else
  //         {
  //
  //         }
  //     }
  //   else if(a.team == )
  //   //check for king picked up and placed in castle spot
  //   //check for rook picked up and placed in castle spot
  // }


  Move buildGuaranteeMove(int r1, int c1, int r2, int c2)
  {
    return board[r1][c1].buildMove(r2, c2, this);
  }

  bool confirmMove()
  {
    if(!validMoveState) {
      return false;
    }

    move(currentMove!);
    currentMove = null;
    validMoveState = false;
    return true;

  }

}