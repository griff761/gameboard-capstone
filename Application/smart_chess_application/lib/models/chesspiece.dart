import 'chessboard.dart';
import 'chesspiece_types/empty.dart';

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

  List<List<int>> getValidMoves(Chessboard currentBoard); //returns all valid moves for this piece

  bool validMove(int newX, int newY, Chessboard currentBoard)
  {
    for(List<int> move in getValidMoves(currentBoard))
    {
      if(move[0] == newX && move[1] == newY)
      {
        return true;
      }
    }
    return false;
  }
  void move(int newX, int newY, Chessboard currentBoard) {
    // firstMove = false;
    currentBoard.removePiece(newX, newY);
    currentBoard.board[row][col] = Empty(row: row, col: col);
    currentBoard.board[newX][newY] = this;
    row = newX;
    col = newY;
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

