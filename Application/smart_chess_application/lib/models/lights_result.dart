

import 'move.dart';

class LightsResult
{
  // let 0 be lights OFF (neurtal state)
  // let 1 be for possible moves
  // let 2 be for continued move requirements
  // let -1 be for error state
  // let -2 be exempt error state (tells user which pieces to swap again)

  // let 3 be tentative move (before move confirmation)


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


}