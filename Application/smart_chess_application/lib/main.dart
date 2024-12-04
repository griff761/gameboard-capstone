import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
// import 'package';

import 'package:logging/logging.dart';

import 'chessboard_view.dart';
import 'chessboard_view_live.dart';
import 'jack/server.dart';
import 'src/output_widget.dart';

void main() async{
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<MyApp> {


  late ChessboardViewLive chessView;
  late GlobalKey<ChessboardViewLiveState> chessKey;

  @override
  void initState() {
    super.initState();

    chessKey = GlobalKey();

    chessView = ChessboardViewLive(
      key:chessKey
    );
    Server.chessKey = chessKey;
    print('Starting server...');
     Server.start();
  }


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
              child: chessView
              // child: ChessboardView(),
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
