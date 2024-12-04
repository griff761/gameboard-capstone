import 'package:flutter/material.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:smart_chess_application/models/move.dart';
import 'package:smart_chess_application/src/output_widget.dart';
import 'package:stockfish/stockfish.dart';

import 'models/IntegratedChessboard.dart';
import 'models/chessboard.dart';
import 'models/chesspiece.dart';

// import 'assets/chesspiece_blackBishop.png';

class ChessboardViewLive extends StatefulWidget {
  const ChessboardViewLive({super.key});
  @override
  State<StatefulWidget> createState() => ChessboardViewLiveState();

}

//START BY IMITATING DATA SENT WITH CLICKS
class ChessboardViewLiveState extends State<ChessboardViewLive> {

//TODO: RE-ADD PROMOTION DIALOGUE


  void recieveDataFromPico(List<List<ChessPieceTeam>> hardwareState)
  {
    c.update_hardware_state(hardwareState);
    updateLEDs();

  }


  // List<List<int>> simulatedPhysicalBoard = List<List<int>>.filled(8, List<int>.filled(8,0));
  List<List<ChessPieceTeam>> simulatedPhysicalBoard = List<List<ChessPieceTeam>>.generate(8, (_) => new List<ChessPieceTeam>.generate(8,(_) => ChessPieceTeam.none));
  // List<List<ChessPieceTeam>>.

  Map<int, ChessPieceTeam> team = {0: ChessPieceTeam.none, 1: ChessPieceTeam.white, -1: ChessPieceTeam.black};


  int piecePickedUp = 0;
  String currentTouch = "";


  void initSimulatedBoard()
  {
    simulatedPhysicalBoard = List<List<ChessPieceTeam>>.generate(8, (_) => new List<ChessPieceTeam>.generate(8,(_) => ChessPieceTeam.none));
    for(int i = 0; i < 8; i++)
      {
        simulatedPhysicalBoard[0][i] = team[1] ?? ChessPieceTeam.none;
        simulatedPhysicalBoard[1][i] = team[1] ?? ChessPieceTeam.none;
        simulatedPhysicalBoard[6][i] = team[-1] ?? ChessPieceTeam.none;
        simulatedPhysicalBoard[7][i] = team[-1] ?? ChessPieceTeam.none;

      }
    print(simulatedPhysicalBoard);
  }


  void touch(int row, int col)
  {
    simulatedPhysicalBoard[row][col] = team[piecePickedUp] ?? ChessPieceTeam.none;
    keys[row][col].currentState?.tempIcon(piecePickedUp);


    //board change -> check with integrated chessboard
    c.update_hardware_state(simulatedPhysicalBoard);

    //change board with LEDs
    updateLEDs();

    //moved piece back to original spot? show piece again
    if(c.changes.isEmpty || c.errorState)
      {
        updateAllSpaces();
      }
  }

  void changeTouch(int i)
  {
    piecePickedUp = i;

    setState(() {
      currentTouch = "currentTouch: " + piecePickedUp.toString();
    });
  }

  void updateLEDs()
  {
    setState(() {
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          keys[i][j].currentState?.updateColor(c.leds.getColor(i, j));
        }
      }
    });
  }


  void confirmMove()
  {
    if(c.confirmMove())
      {
        // c.update_hardware_state(simulatedPhysicalBoard);
        updateLEDs();
        updateAllSpaces();
      }
  }



  bool needDialogue = false;

  late IntegratedChessboard c;

  List<List<GlobalKey<ChessSquareState>>> keys = [[],[],[],[],[],[],[],[]];
  List<Widget> squares = [];

  List<Move> possibleMoves = [];

  Color color1 = Colors.black12;
  Color color2 = Colors.white;

  // late Stockfish stockfish;



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
      keys[x][y].currentState?.updateColor(1);
    }
  }
  void clearMoveColors()
  {
    for(int i = 0; i < possibleMoves.length; i++)
    {
      int x = possibleMoves[i].row;
      int y = possibleMoves[i].col;
      keys[x][y].currentState?.updateColor(0);
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

      updateAllSpaces();
    });
    possibleMoves = [];
    if(move != null)
      print(move.lAN);
  }

  void updateInt()
  {
    setState(() {
      updatingInt++;
      updatingText = updatingInt.toString();
    });
  }


  void updateAllSpaces()
  {
    //lets see how slow this is :/
    setState(() {
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          keys[i][j].currentState?.updateIcon();
        }
      }
    });

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

  String updatingText = "1";
  int updatingInt = 0;

  @override
  void initState() {
    super.initState();
    c = IntegratedChessboard(() {
      updateLEDs();
    });

    GlobalKey<ChessboardViewLiveState> k = widget.key as GlobalKey<ChessboardViewLiveState> ?? GlobalKey();
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
                row: i,
                col: j,
                color: ((i + j)%2 == 0) ? color1 : color2,
                boardUpdate: handleBoardInput,
                icon: Text(""),
                chessboardKey: k,
              ));
        }
    }
    updateAllSpaces();

    updatingText = updatingInt.toString();

    currentTouch = "currentTouch: " + piecePickedUp.toString();

    initSimulatedBoard();
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
        TextButton(onPressed: () async {
          c.playingWithAI = !c.playingWithAI;
          print("PLAYING WITH AI: ${c.playingWithAI}");
        },
            child: Text("Toggle AI")),

        TextButton(onPressed: () async {
          confirmMove();
          updateAllSpaces();
        },
            child: Text("CONFIRM MOVE")),

        Text(currentTouch, style: TextStyle(fontSize: 15)),

        TextButton(onPressed: () async {
          changeTouch(1);
        },
            child: Text("White")),

        TextButton(onPressed: () async {
          changeTouch(-1);
        },
            child: Text("Black")),

        TextButton(onPressed: () async {
          changeTouch(0);
        },
            child: Text("None")),


        Text(updatingText, style: TextStyle(fontSize: 15))
      ]
    );
  }

}

class ChessSquare extends StatefulWidget {
  final Chessboard c;
  final Color color;
  final int row;
  final int col;
  final ValueChanged<List<int>> boardUpdate;

  final GlobalKey<ChessboardViewLiveState> chessboardKey;

  final Widget icon;

  const ChessSquare({
    super.key,
    required this.row,
    required this.col,
    required this.color,
    required this.c,
    required this.boardUpdate,
    required this.icon,
    required this.chessboardKey});
  @override
  State<StatefulWidget> createState() => ChessSquareState();
}

class ChessSquareState extends State<ChessSquare> {
  bool toggle = false;
  Widget icon = Text("");

  List<Widget> iconList = [];

  Color color = Colors.white;

  Color color1 = Colors.black12;
  Color color2 = Colors.white;

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

  Color uhoh = Colors.deepPurple;

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

  Map<int, Color> colors = {
  };


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    icon = icons[widget.c.board[widget.row][widget.col].getSymbol()] ?? Text("");
    color = ((widget.row + widget.col)%2 == 0) ? color1 : color2;

    colors = {
      -2: ((widget.row + widget.col)%2 == 0) ? exempt1 : exempt2,
      -1: ((widget.row + widget.col)%2 == 0) ? error1 : error2,
      0:  ((widget.row + widget.col)%2 == 0) ? color1 : color2,
      1:  ((widget.row + widget.col)%2 == 0) ? possible1 : possible2,
      2:  ((widget.row + widget.col)%2 == 0) ? continue1 : continue2,
      3:  ((widget.row + widget.col)%2 == 0) ? tentative1 : tentative2,
      4:  ((widget.row + widget.col)%2 == 0) ? aIMoveFrom1 : aIMoveFrom2,
      5:  ((widget.row + widget.col)%2 == 0) ? aIMoveTo1 : aIMoveTo2,
    };
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
          // print(widget.row.toString() + ", " + widget.col.toString());
          // print(widget.icon);
          // widget.boardUpdate([widget.row, widget.col]);
          // print(widget.icon);

          // TOUCH
          widget.chessboardKey.currentState?.touch(widget.row, widget.col);

        },));
  }


  void updateIcon()
  {
    setState(() {
      icon = icons[widget.c.board[widget.row][widget.col].getSymbol()] ?? Text("");
    });
  }

  void tempIcon(int i)
  {
    setState(() {
      icon = Text(i.toString());
    });
  }

  void updateColor(int i)
  {
    setState(() {
      color = colors[i] ?? uhoh;
    });
  }
  void resetColor()
  {
    setState(() {
      color = widget.color;
    });
  }
}