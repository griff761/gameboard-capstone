import 'package:flutter/material.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:smart_chess_application/models/move.dart';

import 'models/chessboard.dart';
import 'models/chesspiece.dart';

// import 'assets/chesspiece_blackBishop.png';

class ChessboardView extends StatefulWidget {
  const ChessboardView({super.key});
  @override
  State<StatefulWidget> createState() => ChessboardViewState();

}


class ChessboardViewState extends State<ChessboardView> {

  Chessboard c = Chessboard();
  List<List<GlobalKey<ChessSquareState>>> keys = [[],[],[],[],[],[],[],[]];
  List<Widget> squares = [];

  List<Move> possibleMoves = [];

  Color color1 = Colors.black12;
  Color color2 = Colors.white;
  Color possibleMove = Colors.lightBlueAccent;
  Color possibleMove2 = Colors.lightBlue;

  Map<String, Widget> icons = {
    "b": BlackBishop(),
    "B": WhiteBishop(),
    "k": BlackKing(),
    "K": WhiteKing(),
    "n": BlackKnight(),
    "N": WhiteKnight(),
    "p": BlackPawn(),
    "P": WhitePawn(),
    "q": BlackQueen(),
    "Q": WhiteQueen(),
    "r": BlackRook(),
    "R": WhiteRook()
  };

  String text = "STARTING";
  bool pieceToMoveClick = false;
  int x1 = -1;
  int y1 = -1;
  int x2 = -2;
  int y2 = -2;

  void setMoveColors()
  {
    for(int i = 0; i < possibleMoves.length; i++)
    {
      int x = possibleMoves[i].row;
      int y = possibleMoves[i].col;
      keys[x][y].currentState?.updateColor(((x + y)%2 == 0) ? possibleMove : possibleMove2);
    }
  }
  void clearMoveColors()
  {
    for(int i = 0; i < possibleMoves.length; i++)
    {
      int x = possibleMoves[i].row;
      int y = possibleMoves[i].col;
      keys[x][y].currentState?.resetColor();
    }
  }


  void boardUpdate(List<int> pos) {
    pieceToMoveClick = !pieceToMoveClick; //toggle
    if(pieceToMoveClick)
      {
        x1 = pos[0];
        y1 = pos[1];
        possibleMoves = c.board[x1][y1].getValidMoves(c);
        setState(() {
          text = "move " + x1.toString() + "," + y1.toString() + " ";
          setMoveColors();
        });
        print(text);
      }
    else if(x1 == pos[0] && y1 == pos[1])
      {
        setState(() {
          clearMoveColors();
          text = "";
        });
        possibleMoves = [];
      }
    else
      {
        x2 = pos[0];
        y2 = pos[1];
        text = text + "to " + x2.toString() + "," + y2.toString();
        print(text);
        print(c.move(x1, y1, x2, y2));
        setState(() {
          clearMoveColors();
          keys[x1][y1].currentState?.updateIcon(icons[c.board[x1][y1].getSymbol()] ?? Text(""));
          keys[x2][y2].currentState?.updateIcon(icons[c.board[x2][y2].getSymbol()] ?? Text(""));
        });
        possibleMoves = [];
      }
    print(c.toString());
  }

  List<Widget> iconList = [];

  @override
  void initState() {
    //setup chess squares for use in grid
    for(int i = 7; i >= 0; i--)
    {
      for(int j = 0; j < 8; j++)
        {
          keys[i].add(GlobalKey());
          squares.add(
              ChessSquare(
                key: keys[i][j],
                c: c,
                x: i,
                y: j,
                color: ((i + j)%2 == 0) ? color1 : color2,
                boardUpdate: boardUpdate,
                icon:  icons[c.board[i][j].getSymbol()] ?? Text("")
              ));
        }
    }
  }
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
        Text("") //temporary -- use for spacer
      ]
    );
  }

}

class ChessSquare extends StatefulWidget {
  final Chessboard c;
  final Color color;
  final int x;
  final int y;
  final ValueChanged<List<int>> boardUpdate;

  final Widget icon;

  const ChessSquare({
    super.key,
    required this.x,
    required this.y,
    required this.color,
    required this.c,
    required this.boardUpdate,
    required this.icon});
  @override
  State<StatefulWidget> createState() => ChessSquareState();
}

class ChessSquareState extends State<ChessSquare> {
  bool toggle = false;
  Widget icon = Text("");

  List<Widget> iconList = [];

  Color color = Colors.white;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    icon = widget.icon;
    color = widget.color;
  }


  int help = 0;
  bool firstLoad = true;
  @override
  Widget build(BuildContext context) {

      return Container(
          color: color,
          child: IconButton(
        color: color,
        icon: icon,
        onPressed: () {
          print(widget.x.toString() + ", " + widget.y.toString());
          print(widget.icon);
          widget.boardUpdate([widget.x, widget.y]);
          print(widget.icon);
        },));
  }


  void updateIcon(Widget i)
  {
    setState(() {
      icon = i;
    });
    print(icon);
  }

  void updateColor(Color c)
  {
    setState(() {
      color = c;
    });
  }
  void resetColor()
  {
    setState(() {
      color = widget.color;
    });
  }
}