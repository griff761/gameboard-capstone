// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_chess_application/main.dart';


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
    List<List<int>> ledArray = List<List<int>>.generate(8, (_) => new List<int>.generate(8,(_) => 0));
    ledArray[5][6] = 27;
    print(ledArray);
  });


  test('color picking', () {
    Color possible1 = Colors.lightBlueAccent;
    Color possible2 = Colors.lightBlue;

    Color continue1 = Colors.lightGreenAccent;
    Color continue2 = Colors.lightGreen;

    Color error1 = Colors.redAccent;
    Color error2 = Colors.red;

    Color exempt1 = Colors.orangeAccent;
    Color exempt2 = Colors.orange;

    Color tentative1 = const Color.fromRGBO(179, 255, 250, 1);
    Color tentative2 = const Color.fromRGBO(134, 191, 187, 1);


    Color aIMoveFrom1 = const Color.fromRGBO(194, 133, 255, 1);
    Color aIMoveFrom2 = const Color.fromRGBO(149, 102, 196, 1);

    Color aIMoveTo1 = const Color.fromRGBO(255, 246, 145, 1);
    Color aIMoveTo2 = const Color.fromRGBO(189, 182, 106, 1);

    print("possible1: ${possible1.red}\t${possible1.blue}\t${possible1.green}\t${possible1.alpha}");
    print("possible2: ${possible2.red}\t${possible2.blue}\t${possible2.green}\t${possible2.alpha}");


    print("continue1: ${continue1.red}\t${continue1.blue}\t${continue1.green}\t${continue1.alpha}");
    print("continue2: ${continue2.red}\t${continue2.blue}\t${continue2.green}\t${continue2.alpha}");


    print("error1: ${error1.red}\t${error1.blue}\t${error1.green}\t${error1.alpha}");
    print("error2: ${error2.red}\t${error2.blue}\t${error2.green}\t${error2.alpha}");


    print("exempt1: ${exempt1.red}\t${exempt1.blue}\t${exempt1.green}\t${exempt1.alpha}");
    print("exempt2: ${exempt2.red}\t${exempt2.blue}\t${exempt2.green}\t${exempt2.alpha}");


    print("tentative1: ${tentative1.red}\t${tentative1.blue}\t${tentative1.green}\t${tentative1.alpha}");
    print("tentative2: ${tentative2.red}\t${tentative2.blue}\t${tentative2.green}\t${tentative2.alpha}");


    print("aIMoveFrom1: ${aIMoveFrom1.red}\t${aIMoveFrom1.blue}\t${aIMoveFrom1.green}\t${aIMoveFrom1.alpha}");
    print("aIMoveFrom2: ${aIMoveFrom2.red}\t${aIMoveFrom2.blue}\t${aIMoveFrom2.green}\t${aIMoveFrom2.alpha}");


    print("aIMoveTo1: ${aIMoveTo1.red}\t${aIMoveTo1.blue}\t${aIMoveTo1.green}\t${aIMoveTo1.alpha}");
    print("aIMoveTo2: ${aIMoveTo2.red}\t${aIMoveTo2.blue}\t${aIMoveTo2.green}\t${aIMoveTo2.alpha}");
  });


}
