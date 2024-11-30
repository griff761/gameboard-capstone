import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
// import 'package';

import 'package:logging/logging.dart';
import 'package:stockfish/stockfish.dart';

import 'src/output_widget.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  late Stockfish stockfish;

  @override
  void initState() {
    super.initState();
    stockfish = Stockfish();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stockfish example app'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                animation: stockfish.state,
                builder: (_, __) => Text(
                  'stockfish.state=${stockfish.state.value}',
                  key: const ValueKey('stockfish.state'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                animation: stockfish.state,
                builder: (_, __) => ElevatedButton(
                  onPressed: stockfish.state.value == StockfishState.disposed
                      ? () {
                    final newInstance = Stockfish();
                    setState(() => stockfish = newInstance);
                  }
                      : null,
                  child: const Text('Reset Stockfish instance'),
                ),
              ),
            ),
            Padding(
          padding: const EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Custom UCI command',
                  hintText: 'go infinite',
                ),
                onSubmitted: (value) => stockfish.stdin = value,
                textInputAction: TextInputAction.send,
              ),
            ),
            Wrap(
              children: [
                'd',
                'isready',
                'go infinite',
                'go movetime 3000',
                'stop',
                'quit',
              ]
                  .map(
                    (command) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => stockfish.stdin = command,
                    child: Text(command),
                  ),
                ),
              )
                  .toList(growable: false),
            ),
            Expanded(
              child: OutputWidget(stockfish.stdout),
            ),
          ],
        ),
      ),
    );
  }
}

// void main() => runApp(new MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     const commonSize = 50.0;
//     return new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Chess vectors experiment'),
//           backgroundColor: Colors.blue,
//         ),
//         body: Container(
//             decoration: BoxDecoration(
//               color: Colors.green,
//             ),
//             child: Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     WhitePawn(
//                       size: commonSize,
//                       // You can also change fill color .
//                       fillColor: Colors.blue,
//
//                       // You can also change stroke color .
//                       strokeColor: Colors.red,
//                     ),
//                     WhiteKnight(size: commonSize),
//                     WhiteBishop(size: commonSize),
//                     WhiteRook(size: commonSize),
//                     WhiteQueen(size: commonSize),
//                     WhiteKing(size: commonSize),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     BlackPawn(size: commonSize),
//                     BlackKnight(size: commonSize),
//                     BlackBishop(size: commonSize),
//                     BlackRook(size: commonSize),
//                     BlackQueen(size: commonSize),
//                     BlackKing(size: commonSize),
//                   ],
//                 ),
//               ],
//             )));
//   }
// }










// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Chessboard App',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Smart Chessboard App'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
