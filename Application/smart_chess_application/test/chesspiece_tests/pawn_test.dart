// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_chess_application/main.dart';
import 'package:smart_chess_application/models/chessboard.dart';
import 'package:smart_chess_application/models/chesspiece.dart';
import 'package:smart_chess_application/models/chesspiece_types/pawn.dart';

void main() {


  // test('pawn basic movement', () {
  //   Chessboard c = Chessboard();
  //   c.empty();
  //   print(c.board);
  //   Pawn r = Pawn(row: 3, col: 4, team: ChessPieceTeam.white);
  //   c.board[3][4] = r;
  //
  //   print(r.getValidMoves(c));
  //   print(c.toString());
  // });

  test('pawn basic movement', () {
    Chessboard c = Chessboard();
    print(c.board);

    print(c.board[1][3].getValidMoves(c));
    print(c.toString());
  });


}
