import 'package:flutter/material.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

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
  // List<List<String>> symbols = [[],[],[],[],[],[],[],[]];
  List<List<GlobalKey<ChessSquareState>>> keys = [[],[],[],[],[],[],[],[]];
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
        setState(() {
          text = "move " + x1.toString() + "," + y1.toString() + " ";
        });
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
          keys[x1][y1].currentState?.updateIcon(index[c.board[x1][y1].getSymbol()] ?? 0);
          keys[x2][y2].currentState?.updateIcon(index[c.board[x2][y2].getSymbol()] ?? 0);
          // symbols[x1][y1] = c.board[x1][y1].getSymbol();
          // symbols[x2][y2] = c.board[x2][y2].getSymbol();
        });
      }

  }

  List<Widget> iconList = [];

  @override
  void initState() {
    index["R"] = 0;
    index["r"] = 1;
    index["N"] = 2;
    index["n"] = 3;
    index["B"] = 4;
    index["b"] = 5;
    index["Q"] = 6;
    index["q"] = 7;
    index["K"] = 8;
    index["k"] = 9;
    index["P"] = 10;
    index["p"] = 11;
    index[""] = 12;

    for(int i = 7; i >= 0; i--)
    {
      for(int j = 0; j < 8; j++)
        {
          print(((i*8 + j)%2 == 0) ? color1 : color2);
          // symbols[i].add(c.board[i][j].getSymbol());
          print(c.board[i][j].getSymbol());
          keys[i].add(GlobalKey());
          squares.add(
              ChessSquare(
                key: keys[i][j],
                c: c,
                x: i,
                y: j,
                color: ((i + j)%2 == 0) ? color1 : color2,
                boardUpdate: boardUpdate,
                icon: index[c.board[i][j].getSymbol()] ?? 0,));
        }
    }
    iconList.add(WhiteRook());
    iconList.add(BlackRook());
    iconList.add(WhiteKnight());
    iconList.add(BlackKnight());
    iconList.add(WhiteBishop());
    iconList.add(BlackBishop());
    iconList.add(WhiteQueen());
    iconList.add(BlackQueen());
    iconList.add(WhiteKing());
    iconList.add(BlackKing());
    iconList.add(WhitePawn());
    iconList.add(BlackPawn());
    iconList.add(const Icon(Icons.add, size: 0));

    // for(int i = 0; i < 8; i++)
    //   {
    //     for(int j = 0; j < 8; j++)
    //       {
    //         keys[i][j].currentState?.updateIcon(index[c.board[i][j].getSymbol()] ?? 0);
    //       }
    //   }
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
        IconButton(icon: iconList[cryIndex],
        onPressed: () {

        })
      ]
    );
  }

  Map<String, int> index = {};


}

// class ChessSquare extends StatelessWidget {
//
// }

class ChessSquare extends StatefulWidget {
  final Chessboard c;
  final Color color;
  final int x;
  final int y;
  final ValueChanged<List<int>> boardUpdate;

  final int icon;

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
  int icon = 12;

  List<Widget> iconList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    icon = widget.icon;
  }


  int help = 0;
  bool firstLoad = true;
  @override
  Widget build(BuildContext context) {
    iconList.add(WhiteRook());
    iconList.add(BlackRook());
    iconList.add(WhiteKnight());
    iconList.add(BlackKnight());
    iconList.add(WhiteBishop());
    iconList.add(BlackBishop());
    iconList.add(WhiteQueen());
    iconList.add(BlackQueen());
    iconList.add(WhiteKing());
    iconList.add(BlackKing());
    iconList.add(WhitePawn());
    iconList.add(BlackPawn());
    iconList.add(const Icon(Icons.add, size: 0));

    // print(icons[widget.icon]);
    // icon = widget.icon;
    // iconIndex = index[widget.icon]!;
      return Container(
          color: widget.color,
          child: IconButton(
        color: widget.color,
        icon: iconList[icon] ?? const Icon(Icons.add, size: 0),
        onPressed: () {
          print(widget.x.toString() + ", " + widget.y.toString());
          print(widget.icon);
          widget.boardUpdate([widget.x, widget.y]);
          setState(() {
            // icon = "";
            // icon = 0;
            // help++;
            // icon++;

          });
          print(widget.icon);
        },));
  }

  void symbolToNumber()
  {

  }

  void updateIcon(int i)
  {
    setState(() {
      icon = i;
      help = i;
    });
    print(icon);
  }

  // void update()
  // {
  //   setState(() {
  //     icon = getIcon(widget.c.board[widget.x][widget.y]) ?? Icon(Icons.add, size: 0);
  //   });
  // }
  //
  //
  // Widget getIcon(ChessPiece chesspiece)
  // {
  //   switch (chesspiece.type) {
  //     case ChessPieceType.pawn:
  //       if(chesspiece.team == ChessPieceTeam.white)
  //         return WhitePawn();
  //       else
  //         return BlackPawn();
  //     case ChessPieceType.bishop:
  //       if(chesspiece.team == ChessPieceTeam.white)
  //         return WhiteBishop();
  //       else
  //         return BlackBishop();
  //     case ChessPieceType.king:
  //       if(chesspiece.team == ChessPieceTeam.white)
  //         return WhiteKing();
  //       else
  //         return BlackKing();
  //     case ChessPieceType.knight:
  //       if(chesspiece.team == ChessPieceTeam.white)
  //         return WhiteKnight();
  //       else
  //         return BlackKnight();
  //     case ChessPieceType.queen:
  //       if(chesspiece.team == ChessPieceTeam.white)
  //         return WhiteQueen();
  //       else
  //         return BlackQueen();
  //     case ChessPieceType.rook:
  //       if(chesspiece.team == ChessPieceTeam.white)
  //         return WhiteRook();
  //       else
  //         return BlackRook();
  //     default:
  //         return Icon(Icons.add, size: 0);
  //   }
  // }

}