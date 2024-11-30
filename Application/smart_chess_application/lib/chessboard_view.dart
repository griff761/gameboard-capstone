import 'package:flutter/material.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:smart_chess_application/models/move.dart';
import 'package:stockfish/stockfish.dart';

import 'models/chessboard.dart';
import 'models/chesspiece.dart';

// import 'assets/chesspiece_blackBishop.png';

class ChessboardView extends StatefulWidget {
  const ChessboardView({super.key});
  @override
  State<StatefulWidget> createState() => ChessboardViewState();

}


class ChessboardViewState extends State<ChessboardView> {

  bool needDialogue = false;

  Chessboard c = Chessboard();
  List<List<GlobalKey<ChessSquareState>>> keys = [[],[],[],[],[],[],[],[]];
  List<Widget> squares = [];

  List<Move> possibleMoves = [];

  Color color1 = Colors.black12;
  Color color2 = Colors.white;
  Color possibleMove = Colors.lightBlueAccent;
  Color possibleMove2 = Colors.lightBlue;

  late Stockfish stockfish;

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


  void handleBoardInput(List<int> pos) {
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
        // ChessPiece cp = c.board[x1][y1];
        // promotionDialogue(cp.team);
      }
    else
      {
        x2 = pos[0];
        y2 = pos[1];
        text = text + "to " + x2.toString() + "," + y2.toString();
        print(text);

        Move? tempMove = c.buildMove(x1, y1, x2, y2);

        if(tempMove?.promotion == true)
          {
            ChessPiece cp = c.board[x1][y1];
            promotionDialogue(cp.team, tempMove!);
          }
        else if(tempMove != null)
          {
            movePiece(tempMove!);
          }
      }
  }

  void movePiece(Move inputMove)
  {
    Move? move = c.move(inputMove);
    setState(() {
      clearMoveColors();
      //handle special move logic here
      // TODO: OTHER SPECIAL MOVES HERE
      if(move?.enPassant == true)
        {
          keys[(move as PassantMove).getPassantRow()][move.col]?.currentState?.updateIcon( Text(""));
        }
      else if(move?.castle == 1)
        {
          keys[x1][5].currentState?.updateIcon(icons[c.board[x1][5].getSymbol()] ?? Text(""));
          keys[x1][7].currentState?.updateIcon(icons[c.board[x1][7].getSymbol()] ?? Text(""));
        }
      else if(move?.castle == -1)
        {
          keys[x1][3].currentState?.updateIcon(icons[c.board[x1][3].getSymbol()] ?? Text(""));
          keys[x1][0].currentState?.updateIcon(icons[c.board[x1][0].getSymbol()] ?? Text(""));
          // keys[x1][y1].currentState?.updateIcon(icons[c.board[x1][y1].getSymbol()] ?? Text(""));
        }
      keys[x1][y1].currentState?.updateIcon(icons[c.board[x1][y1].getSymbol()] ?? Text(""));
      keys[x2][y2].currentState?.updateIcon(icons[c.board[x2][y2].getSymbol()] ?? Text(""));
    });
    possibleMoves = [];
    if(move != null)
      print(move.lAN);
  }

  void promotionDialogue(ChessPieceTeam team, Move move)
  {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("PAWN PROMOTION"),
        content: const Text("What would you like to promote this pawn to?"),
        actions: <Widget>[
          Wrap(
            children:
              (team == ChessPieceTeam.white ? [
                [WhiteBishop(), 'B'],
                [WhiteKnight(), 'N'],
                [WhiteQueen(), 'Q'],
                [WhiteRook(), 'R'],
              ] : [
                [BlackBishop(), 'b'],
                [BlackKnight(), 'n'],
                [BlackQueen(), 'q'],
                [BlackRook(), 'r'],
              ])

                .map(
                  (command) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    print(command);
                    setState(() {
                      needDialogue = false;
                    });
                    move.promotionType = command[1] as String;
                    Navigator.of(ctx).pop();
                    movePiece(move);
                  },
                  child: command[0] as Widget,//Text(command),
                ),
              ),
            )
                .toList(growable: false),
          ),
        ],
      ),
    );
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
                boardUpdate: handleBoardInput,
                icon:  icons[c.board[i][j].getSymbol()] ?? Text("")
              ));
        }
    }
  }
  @override
  Widget build(BuildContext context) {

    if(needDialogue){
      Navigator.of(context).pop();
    }

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