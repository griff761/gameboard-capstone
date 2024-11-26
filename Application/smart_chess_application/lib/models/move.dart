

import 'chesspiece.dart';

class Move
{
  int row = -1;
  int col = -1;

  int castle = 0; // 0 if no castle, 1 if kingside, -1 if queenside
  bool promotion = false;
  bool enPassant = false;

  Move({required this.row, required this.col, this.castle = 0, this.promotion = false, this.enPassant = false});
}