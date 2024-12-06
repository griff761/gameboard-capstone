

import 'move.dart';

class LightsResult
{
  // let 0 be lights OFF (neurtal state)
  // let 1 be for possible moves
  // let 2 be for continued move requirements
  // let -1 be for error state
  // let -2 be exempt error state (tells user which pieces to swap again)

  // let 3 be tentative move (before move confirmation)

  // let 4 be AI MOVE FROM
  // let 5 be AI MOVE TO


  List<List<int>> ledArray = List<List<int>>.generate(8, (_) => new List<int>.generate(8,(_) => 0)); //fill array with 0s


  //start with all lights off
  LightsResult()
  {
    ledArray = List<List<int>>.generate(8, (_) => new List<int>.generate(8,(_) => 0));
  }

  void reset()
  {
    ledArray = List<List<int>>.generate(8, (_) => new List<int>.generate(8,(_) => 0));
  }

  void possibleMoves(List<Move> moves)
  {
    reset();
    for(Move move in moves)
      {
        ledArray[move.row][move.col] = 1;
      }
  }

  void continuedMoveReq(List<List<int>> movesTODO, List<List<int>> movesDone)
  {
    reset();
    for(List<int> move in movesTODO)
    {
      ledArray[move[0]][move[1]] = 2;
    }
    for(List<int> move in movesDone)
    {
      ledArray[move[0]][move[1]] = 3;
    }
  }

  //doesnt need to use move objects bc errors
  void errorBoard(List<List<int>> exempt)
  {
    // reset();
    for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
          {
            ledArray[i][j] = -1;
          }
      }

    for(List<int> move in exempt)
      {
        ledArray[move[0]][move[1]] = -2;
      }
  }


  void tentativeBoard(List<List<int>> tentativeMoves)
  {
    reset();

    for(List<int> move in tentativeMoves)
    {
      ledArray[move[0]][move[1]] = 3;
    }

  }



  int getColor(int row, int col)
  {
    return ledArray[row][col];
  }

  //List<List<int>> -> [0] row [1] col [2] hardware team
  void AIMove(Move move, List<List<int>> changes, bool taking)
  {
    reset();
    //TODO: error tracking (red squares for invalid move portions)
    ledArray[move.piece.row][move.piece.col] = 4;
    ledArray[move.row][move.col] = 5;

    //special move cases:
      //en passant
    if(move.enPassant)
      {
        ledArray[move.piece.row][move.col] = 4;
      }
    else if(move.castle == -1) //queenside castle
      {
        ledArray[move.row][0] = 4;
        ledArray[move.row][2] = 5;
      }
    else if(move.castle == 1) //kingside castle
      {
        ledArray[move.row][7] = 4;
        ledArray[move.row][5] = 5;
      }

    for(List<int> change in changes)
      {
        //reset if moved
        if(change[0] == move.piece.row && change[1] == move.piece.col)
          {
            ledArray[move.piece.row][move.piece.col] = 0;
          }
        else if(change[0] == move.row && change[1] == move.col &&
            (!taking || (taking && change[2] != 0))) // only remove light if it's
        {
          ledArray[move.row][move.col] = 0;
        }
        else
          {
            ledArray[change[0]][change[1]] = -1;
          }
      }

    print(ledArray);

    // ledArray[]
  }

  void checkmate()
  {
    for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
          {
            ledArray[i][j] = 6; // GREEEEEEEEEN
          }
      }
  }


}