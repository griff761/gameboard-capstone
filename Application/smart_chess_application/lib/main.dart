import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
// import 'package';

import 'package:logging/logging.dart';
import 'package:stockfish/stockfish.dart';


import 'chessboard_view.dart';
import 'src/output_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
  }

  int i = 0;

  Icon buttonIcon = Icon(Icons.back_hand);

  Icon i1 = Icon(Icons.add);
  Icon i2 = Icon(Icons.abc);
  Icon i3 = Icon(Icons.access_alarm);

  int x1  = 0;
  int x2 = 0;
  int y1 = 0;
  int y2 = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chess Demo'),
        ),
        body: Column(
          children: [

            Expanded(
              child: ChessboardView()
            ),
            // ChessSquare()
          ],
        ),
      ),
    );
  }
}


// class TestButton extends StatelessWidget {
//
//   const TestButton({super.key, required this.onChanged});
//   final ValueChanged<void> onChanged;
//
//   Icon buttonIcon = Icon(Icons.add);
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: buttonIcon,
//       onPressed: () {  },);
//   }

// }
