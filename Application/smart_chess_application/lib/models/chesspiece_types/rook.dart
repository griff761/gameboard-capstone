import '../chessboard.dart';
import '../chesspiece.dart';
import '../move.dart';
import 'empty.dart';
import 'king.dart';

class Rook extends ChessPiece
{
  bool firstMove = true;
  Rook({required super.row, required super.col, required super.team, super.type = ChessPieceType.rook, this.firstMove = true});

  @override
  List<Move> getValidMoves(Chessboard currentBoard) {
    List<Move> moves = [];
    for(int i = row + 1; i <= 7 && !sameTeamInSpace(i, col, currentBoard); i++)
    {
      moves.add(Move(row: i, col: col, piece: this));
      if(otherTeamInSpace(i, col, currentBoard))
        {
          break;
        }
    }
    for(int i = row - 1; i >= 0 && !sameTeamInSpace(i, col, currentBoard); i--)
    {
      moves.add(Move(row: i, col: col, piece: this));
      if(otherTeamInSpace(i, col, currentBoard))
      {
        break;
      }
    }

    for(int i = col + 1; i <= 7 && !sameTeamInSpace(row, i, currentBoard); i++)
    {
      moves.add(Move(row: row, col: i, piece: this));
      if(otherTeamInSpace(row, i, currentBoard))
      {
        break;
      }
    }
    for(int i = col - 1; i >= 0 && !sameTeamInSpace(row, i, currentBoard); i--)
    {
      moves.add(Move(row: row, col: i, piece: this));
      if(otherTeamInSpace(row, i, currentBoard))
      {
        break;
      }
    }

    if(firstMove)
      {
        King k = team == ChessPieceTeam.white ? currentBoard.wKing : currentBoard.bKing;
        if(col == 7 && k.canKingsideCastle(currentBoard))
        {
          moves.add(CastleKingside(row: row, col: col-2, piece:this));
        }
        if(col == 0 && k.canQueensideCastle(currentBoard))
        {
          moves.add(CastleQueenside(row: row, col: col+3, piece: this));
        }
      }

    return moves;
  }

  List<Move> getMovesforCheck(Chessboard currentBoard) {
    List<Move> moves = [];
    for(int i = row + 1; i <= 7 && !sameTeamInSpace(i, col, currentBoard); i++)
    {
      moves.add(Move(row: i, col: col, piece: this));
      if(otherTeamInSpace(i, col, currentBoard))
      {
        break;
      }
    }
    for(int i = row - 1; i >= 0 && !sameTeamInSpace(i, col, currentBoard); i--)
    {
      moves.add(Move(row: i, col: col, piece: this));
      if(otherTeamInSpace(i, col, currentBoard))
      {
        break;
      }
    }

    for(int i = col + 1; i <= 7 && !sameTeamInSpace(row, i, currentBoard); i++)
    {
      moves.add(Move(row: row, col: i, piece: this));
      if(otherTeamInSpace(row, i, currentBoard))
      {
        break;
      }
    }
    for(int i = col - 1; i >= 0 && !sameTeamInSpace(row, i, currentBoard); i--)
    {
      moves.add(Move(row: row, col: i, piece: this));
      if(otherTeamInSpace(row, i, currentBoard))
      {
        break;
      }
    }

    return moves;
  }

  @override
  String getSymbol() {
    if(super.team == ChessPieceTeam.white) {
      return "R";
    } else {
      return "r";
    }
  }

  @override
  void move(Move move, Chessboard currentBoard) {
    firstMove = false;
    super.move(move, currentBoard);
  }

  @override
  ChessPiece copy() {
    Rook r =  Rook(row: row, col: col, team: team, type: type);
    r.firstMove = firstMove;
    return r;
  }

}