import 'chessboard.dart';
import 'chesspiece_types/empty.dart';
import 'move.dart';

enum ChessPieceType {pawn, rook, knight, bishop, queen, king, empty}
enum ChessPieceTeam {black, white, none}

abstract class ChessPiece
{

  ChessPiece({required this.type, required this.row, required this.col, required this.team});

  ChessPieceType type = ChessPieceType.empty;

  //location data
  int row = -1; //assume can be 1-8
  int col = -1; //assume can be 1-8

  //piece type
  ChessPieceTeam team = ChessPieceTeam.none;

  List<Move> getValidMoves(Chessboard currentBoard); //returns all valid moves for this piece

  Move? validMove(Move inputMove, Chessboard currentBoard)
  {
    for(Move move in getValidMoves(currentBoard))
    {
      if(move.row == inputMove.row && move.col == inputMove.col)
      {
        if(inputMove.promotion)
          {
            return inputMove;
          }
        return move;
      }
    }
    return null;
  }

  Move buildMove(int row, int col, Chessboard currentBoard)
  {
    return Move(row: row, col: col, piece: this);
  }

  void move(Move move, Chessboard currentBoard) {
    // if(otherTeamInSpace(move.row, move.col, currentBoard))
    //   {
    //     move.capture = true;
    //   }
    currentBoard.removePiece(move.row, move.col);
    currentBoard.board[row][col] = Empty(row: row, col: col);
    currentBoard.board[move.row][move.col] = this;
    row = move.row;
    col = move.col;
  }

  String getSymbol();

  bool inBounds(int a)
  {
    return 0 <= a && a <= 7;
  }

  bool sameTeamInSpace(int row, int col, Chessboard currentBoard)
  {
    ChessPieceTeam myTeam = team;
    ChessPieceTeam otherTeam = currentBoard.board[row][col].team;
    return currentBoard.board[row][col].team == team;
  }

  bool otherTeamInSpace(int row, int col, Chessboard currentBoard)
  {
    ChessPieceTeam pieceTeam = currentBoard.board[row][col].team;
    return pieceTeam != team && pieceTeam != ChessPieceTeam.none;
  }

  bool spaceEmpty(int row, int col, Chessboard currentBoard)
  {
    return currentBoard.board[row][col].team == ChessPieceTeam.none;
  }

}

