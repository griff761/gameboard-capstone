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
import 'package:smart_chess_application/models/chesspiece_types/rook.dart';
import 'package:stockfish/stockfish.dart';

void main() {


  test('stockfish move test', () async {
    final Stockfish stockfish = Stockfish();
    Chessboard c = Chessboard();
    //wait for ready

    final stockfishSubscription = stockfish.stdout.listen((message) {
      print(message);
    });

    stockfish.stdin = "isready";

    print(stockfish.stdout);

    await Future.delayed(const Duration(seconds: 1));

    while(stockfish.state.value != StockfishState.ready)
    {
      // const Duration(seconds: 1)
      print(stockfish.state.value);
      await Future.delayed(const Duration(seconds: 1));

    }

    //start board
    stockfish.stdin = "startpos";
    print(stockfish.stdout);
    // c.empty();
    // // print(c.board);
    // Rook r = Rook(row: 3, col: 3, team: ChessPieceTeam.white);
    // c.board[3][3] = r;
    //
    // print(c.toString());

  });

  test('stockfish test', () async {
    final stockfish = new Stockfish();

// Create a subscribtion on stdout : subscription that you'll have to cancel before disposing Stockfish.
    final stockfishSubscription = stockfish.stdout.listen((message) {
      print(message);
    });

    await Future.delayed(const Duration(seconds: 15));

// Get Stockfish ready
    stockfish.stdin = 'isready';

// Send you commands to Stockfish stdin
    stockfish.stdin = 'position startpos'; // set up start position
    stockfish.stdin = 'position fen rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2'; // set up custom position
    stockfish.stdin = 'go movetime 1500'; // search move for at most 1500ms

// Don't remember to dispose Stockfish when you're done.
    stockfishSubscription.cancel();
    stockfish.dispose();
  });


  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
