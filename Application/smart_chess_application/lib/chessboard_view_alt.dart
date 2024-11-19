import 'package:flutter/material.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

import 'models/chessboard.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChessboardView extends StatefulWidget {
  const ChessboardView({super.key});
  @override
  State<StatefulWidget> createState() => ChessboardViewState();

}


class ChessboardViewState extends State<ChessboardView> {

  Chessboard c = Chessboard();
  // List<List<GlobalKey<ChessSquareState>>> keys = [[],[],[],[],[],[],[],[]];
  List<Widget> squares = [];

  Color color1 = Colors.black12;
  Color color2 = Colors.white;

  String text = "STARTING";
  bool pieceToMoveClick = false;
  int x1 = -1;
  int y1 = -1;
  int x2 = -2;
  int y2 = -2;


  void boardUpdate(List<int> pos) {
    pieceToMoveClick = !pieceToMoveClick; //toggle
    if(pieceToMoveClick)
      {
        x1 = pos[0];
        y1 = pos[1];
        text = "move " + x1.toString() + "," + y1.toString() + " ";
        print(text);
      }
    else
      {
        x2 = pos[0];
        y2 = pos[1];
        text = text + "to " + x2.toString() + "," + y2.toString();
        print(text);
        print(c.move(x1, y1, x2, y2));
        setState(() {
          // getSquare(x1, y1).setWidget(w);
          // keys[x1][y1].currentState?.updateIcon(index[c.board[x1][y1].getSymbol()] ?? 0);
          // keys[x2][y2].currentState?.updateIcon(index[c.board[x2][y2].getSymbol()] ?? 0);
        });
      }

  }

  // List<Widget> iconList = [];
  Map<String, Widget> icons = {
    'p': BlackPawn(),
    'P': WhitePawn(),
    'k': BlackKing(),
    'K': WhiteKing()
  };

  @override
  void initState() {

    for(int i = 7; i >= 0; i--)
    {
      for(int j = 0; j < 8; j++)
        {
          print(((i*8 + j)%2 == 0) ? color1 : color2);
          // symbols[i].add(c.board[i][j].getSymbol());
          print(c.board[i][j].getSymbol());
          // keys[i].add(GlobalKey());

          ChessSquare cs = ChessSquare(
            // key: keys[i][j],
              x: i,
              y: j,
              boardUpdate: boardUpdate);
          cs.setWidget(icons[c.board[i][j].getSymbol()] ?? Text(""));
          cs.setColor(((i + j)%2 == 0) ? color1 : color2);

          squares.add(
              ChessSquare(
                // key: keys[i][j],
                x: i,
                y: j,
                boardUpdate: boardUpdate));

        }
    }

  }
  int cryIndex = 0;
  String testString = "assets/chesspiece_blackBishop.png";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
              crossAxisCount: 8,
              children: squares)
        ),
        Text(text),
        IconButton(icon: Image.asset(testString),
          onPressed: () {
            // c.move(1, 2, 3, 2);
            // for(int i = 0; i < 64; i++)
            //   {
            //     // squares[i].update();
            //   }
            setState(() {
              cryIndex++;
            });
          },),
        // IconButton(icon: iconList[cryIndex],
        // onPressed: () {
        //
        // })
      ]
    );
  }

  Map<String, int> index = {};

  ChessSquare getSquare(int x, int y) {
    int index = 63 - x*8 + y;
    return squares[index] as ChessSquare;
  }

}

class ChessSquare extends HookWidget {

  ChessSquare({super.key, required this.x, required this.y, required this.boardUpdate});

  final color = useState(Colors.white);
  final widget = useState(const Icon(Icons.add) as Widget);

  final int x;
  final int y;

  final ValueChanged<List<int>> boardUpdate;


  setColor(Color c)
  {
    color.value = c;
  }

  setWidget(Widget w)
  {
    widget.value = w;
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {

    }, []);

    return Container(
          color: color.value,
          child: IconButton(
            icon: widget.value,
            onPressed: () {
              print("on pressed: " + x.toString() + ", " + y.toString());
              boardUpdate([x, y]);
          },)
    );
  }

}
