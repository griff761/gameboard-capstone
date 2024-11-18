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
    currentBoard.board[row][col] = Empty(row: row, col: col);
    currentBoard.board[row][col] = this;
  }

  String getSymbol();

  bool inBounds(int a)
  {
    return 0 <= a && a <= 7;
  }

  bool sameTeamInSpace(int x, int y, Chessboard currentBoard)
  {
    ChessPieceTeam myTeam = team;
    ChessPieceTeam otherTeam = currentBoard.board[x][y].team;
    return currentBoard.board[x][y].team == team;
  }

  bool otherTeamInSpace(int x, int y, Chessboard currentBoard)
  {
    ChessPieceTeam pieceTeam = currentBoard.board[x][y].team;
    return pieceTeam != team && pieceTeam != ChessPieceTeam.none;
  }

  bool spaceEmpty(int x, int y, Chessboard currentBoard)
  {
    return currentBoard.board[x][y].team == ChessPieceTeam.none;
  }

}

