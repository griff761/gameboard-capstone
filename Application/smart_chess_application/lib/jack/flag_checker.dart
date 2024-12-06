import 'dart:convert';
import 'package:smart_chess_application/jack/server.dart';

import '../models/chesspiece.dart';
import 'array_for_nicole.dart';

/// NOTES FOR NICOLE:
///
///
/// Gamemode 1: Play AI
/// Gamemmode 2: Play Friend
/// Look at methods _reset_gamemode2_Array(), _gamemode1_Array(), _gamemode1_Array(),
/// and _gamemode2_Array().
/// Methods above is where you'll be taking the array to interpret board, and the array you're sending back
/// is the LEDS you want to turn on (in same 2-d array form).
/// Do NOT NOT NOT NOT NOT send the updated chessboard instead haha.
///
/// When manipulating array:
/// only manipulate first 8 columns, last 2 columns are flags we need to keep.
/// make sure to clear array, then put LEDs in so no other data gets carried over.
///
/// For the returned LED chessboard into this array, this is how we want it for now:
/// send back 2-d array where LEDs used to indicate light color for piece we want to move.
///
/// Example (Friend mode, game mode 2): (only manipulate first 8 rows, and first 8 columns of array)
/// 1. player 1: white pawn currently at b2. Player picks up piece, this is sent,
///     LEDs sent back to light previous spot with blue LED, then blue LED where it can be placed.
/// 2. player 1: pawn placed down at b4. this is sent, now friend's (black) turn.
///
/// 3. responds to GET request with LED array being set to 0 (indicating LEDs off)
///
/// 4. player 2: black pawn currently at b7. Player picks up piece, this is sent,
///    LEDs sent back to light previous spot with green LED, then green LED where it can be placed.
/// 5. player 2: pawn placed down at b8. this is sent, now friend's (black) turn.
/// 6. responds to GET request with LED array (first 8 rows/columns) being set to 0 (indicating LEDs off)
///
/// 7. This behavior continues on and on.
///8. If capture about to happen:
///    Player 1 (white) picks up pawn at b4 to move to c5, where Player 2's pawn is at. b4 is blue, c5 is red
///    Red in this case means (going to be captured), Blue is player 1's color. green is player 2's color.
///    Player 2 (black) picks up pawn at c5 to b4, where Player 1's pawn is at. c5 is green, b4 is red.
///    Red in this case means (going to be captured), Blue is player 1's color. green is player 2's color.
///
/// 8. When player is checked:
///    Player 1 (white) places down knight on b4, checking player 2 (black) king on d5.
///    Return yellow LED under king, yellow LED under piece checking king.
///
/// 8. On checkmate:
///    Player 1 (white) places down knight on b4, checkmating player 2 (black) king on d5
///    Return Purple LED under king, purple LED under piece checkmating king.
///    LCD screen will display game over.
///    Player needs to hit reset button to start a new game.
///
/// 9. On incorrect move:
///   Player 1 (white) already picked up knight on a2, and then tried to place on b4, but thats illegal move.
///   Return red LED under knight on b4, and red LED under previous position a2.
///   Once pieces back to where they originally belonged, the ADC will send this array over to you.
///   Once this array matches the previous baord state (other player just went), return previous LED state
///         (this LED state will be no LEDs on since other player put their piece down)
///   Logic continues as usual, player 1 picking up their piece, blue LED under it and where it could go.
///
///
///
/// Example (AI mode, game mode 1):
///   Similar LED behavior to "Play Friend", but slightly different.
///   Main difference: using LEDs on opponents turn to move it for them.
/// 1. player 1: white pawn currently at b2. Player picks up piece, this is sent,
///     LEDs sent back to light previous spot with blue LED, then blue LED where it can be placed.
/// 2. player 1: pawn placed down at b4. this is sent, now AI (black) turn.
///
/// 3. (no need to turn of LEDs here, as it's the AI's turn and will respond quick)
/// 4. AI player: decides it wants to move pawn from b9 to b8.
///    LEDs sent back to light red on b9 (pawns current position) and red on b8 (pawns new position)
///    --Player 1 then moves pawn from b9 to b8 for the AI.
///
/// 5. Player 1: white pawn currently at b4. Player picks up piece, this is sent,
///     LEDs sent back to light previous spot with blue LED, then blue LED where it can be placed.
/// 6. This behavior continues on and on...
///
/// 7. This behavior continues on and on
///
/// 8. If capture about to happen:
///    Player 1 (white) picks up pawn at b4 to move to c5, where Player 2's pawn is at. b4 is blue, c5 is red
///    Red in this case means (going to be captured), Blue is player 1's color. green is player 2's color.
///    AI (black) moves c5 to b4, where PLayer 1's pawn is at. c5 is green, b4 is red.
///    Red in this case means (going to be captured), Blue is player 1's color. green is player 2's color.
///
/// 9. If AI in check.
///    Player 1 (white) places down knight on b4, checking AI (black) king on d5.
///           no need to return yellow LED under king, yellow LED under piece checking king.
///           instead, just give green LED under AI's tile and next tile to move piece. Then player can
///           move the AI pieces for them.
/// 10. If player in check.
///     AI (black) places down knight on b4, checking player 1 (white) king on d5.
///           return yellow LED under king, yellow LED under piece checking king.
///
/// 11. On checkmate:
///    Player 1 (white) places down knight on b4, checkmating AI (black) king on d5
///    Return Purple LED under king, purple LED under piece checkmating king.
///    LCD screen will display game over.
///    Player needs to hit reset button to start a new game.
///
///    Same logic above for if the AI checks player 1.
///
/// 12. On incorrect move:
///   Player 1 (white) already picked up knight on a2, and then tried to place on b4, but thats illegal move.
///   Return red LED under knight on b4, and red LED under previous position a2.
///   Once pieces back to where they originally belonged, the ADC will send this array over to you.
///   Once this array matches the previous baord state (other player just went), return previous LED state
///         (this LED state will be no LEDs on since other player put their piece down)
///   Logic continues as usual, player 1 picking up their piece, blue LED under it and where it could go.
///
/// AI shouldn't be able to make an illegal move.
///
///
/// For castling: LED color 1 under where piece 1 was and can go.
///               LED color 2 where piece 2 was and can go.
///
/// For promotion: player's LED color on previous position, purple LED on promotion tile.
///   Example: Player 1 (white) pawn from b7 to b8. b7 blue, b8 purple.
///
/// For en passant: player's LED color on previous position, same LED color on en passant tile.
///                 red tile on piece being captured.
///
/// These are for your four possible game states. For intially handling starting, ongoing, and different games possibilities
/// 1. reset/new game just started, gamemode 1 indicated, white hasn't made their first move yet.
/// 2. reset/new game just started, gamemode 2 indicated, white hasn't made their first move yet.
/// 3. On-going game, gamemode 1 indicated, white made their move, waiting on black (AI) to respond
/// 4. On-going game, gamemode 2 indicated, white made their move, waiting on black (Friend) to respond


class FlagChecker {
  static List<List<int>> _currentArray =
  List.generate(8, (_) => List.generate(10, (_) => 0));

  // static bool arrayReady = false;

  /// Retrieves the current 2D array.
  static List<List<int>> get currentArray => _currentArray;


  // When a reset occurred, and gamemode 1 entered
  //          Check Row 1, Column 9 (Reset Flag)
  //          Check Row 2, Column 9 (Gamemode 1)
  static void _reset_gamemode1_Array() {
    // UPDATE LOGIC HERE FOR HOW'D YOU LIKE TO HANDLE THIS

    final updatedArray = ArrayForNicole.handleArray(_currentArray);
    updateArray(updatedArray); // Save changes back
    print('FlagChecker: Reset detected, Gamemode 1 selected.');
  }

  // When a reset occurred, and gamemode 2 entered
  //          Check Row 1, Column 9 (Reset Flag)
  //          Check Row 2, Column 10 (Gamemode 2)
  static void _reset_gamemode2_Array() {
    // UPDATE LOGIC HERE FOR HOW'D YOU LIKE TO HANDLE THIS

    final updatedArray = ArrayForNicole.handleArray(_currentArray);
    updateArray(updatedArray); // Save changes back
    print('FlagChecker: Reset detected, Gamemode 2 selected.');
  }

  // When NO reset occurred, and gamemode 1 entered
  //       ---gamemode 1, but board pieces no longer in starting position
  //                Check Row 1, Column 9 (Reset Flag)
  //                 Check Row 2, Column 9 (Gamemode 1)
  static void _gamemode1_Array() {
    // UPDATE LOGIC HERE FOR HOW'D YOU LIKE TO HANDLE THIS
    final updatedArray = ArrayForNicole.handleArray(_currentArray);
    updateArray(updatedArray); // Save changes back
    print('FlagChecker: Reset detected, Gamemode 2 selected.');
  }

  // When NO reset occurred, and gamemode 2 entered
  //       ---gamemode 2, but board pieces no longer in starting position
  //                Check Row 1, Column 9 (Reset Flag)
  //                 Check Row 2, Column 10 (Gamemode 2)
  static void _gamemode2_Array() {
    // UPDATE LOGIC HERE FOR HOW'D YOU LIKE TO HANDLE THIS

    final updatedArray = ArrayForNicole.handleArray(_currentArray);
    updateArray(updatedArray); // Save changes back
    print('FlagChecker: Reset detected, Gamemode 2 selected.');
  }

  /// Updates the current 2D array with new values.
  static void updateArray(List<List<int>> newArray) {
    print("print input");
    for(List<int> row in newArray)
      {
        print(row);
      }
    _currentArray = List<List<int>>.from(
        newArray.map((row) => List<int>.from(row)));
    print('FlagChecker: Updated current array:');

    print("print cur_array");
    for(List<int> row in _currentArray)
    {
      print(row);
    }
  }

  /// Checks flags and applies actions based on the 2D array's state.
  static void checkFlags() {
    print('FlagChecker: Checking flags in the 2D array...');

    bool resetBoard = _currentArray[0][8] == 1;
    bool friendMode = _currentArray[1][9] == 0;
    bool AIMode = _currentArray[1][8] == 1;
    bool confirmMove = _currentArray[0][9] == 1;

    if(resetBoard)
      {
        Server.chessKey.currentState?.resetChessboard();
        print("flag: reset board");
      }

    if(friendMode && !AIMode)
      {
        Server.chessKey.currentState!.c.playingWithAI = false;
        print("flag: playing with friend");
      }
    else
      {
        Server.chessKey.currentState!.c.playingWithAI = true;
        print("flag: playing with AI");
      }
    if(confirmMove)
    {
      Server.chessKey.currentState?.confirmMove();
      print("flag: confirm move");
    }
    else
      {
        final updatedArray = ArrayForNicole.handleArray(_currentArray);
        updateArray(updatedArray);
      }



    // if (_currentArray[0][8] == 1) { // if reset/new game happened, then....
    //   if (_currentArray[1][8] == 1 && _currentArray[1][9] == 0) { // if in gamemode 1 (Play AI)
    //     _reset_gamemode1_Array();
    //   }
    //   else if (_currentArray[1][8] == 0 && _currentArray[1][9] == 1) { // if in game mode 2 (Play Friend)
    //     _reset_gamemode2_Array();
    //   }
    //   else {
    //     print(
    //         'Problem with flags, seems gamemode flag got deleted somewhere along the way. Otherwise, other issue with flags');
    //     final updatedArray = ArrayForNicole.handleArray(_currentArray);
    //   }
    // }
    // else if (_currentArray[0][8] == 0) { // If in on-going game (already sent initial post)
    //   if (_currentArray[1][8] == 1 && _currentArray[1][9] == 0) { // if in gamemode 1 (Play AI)
    //     _gamemode1_Array();
    //   }
    //   else if (_currentArray[1][8] == 0 && _currentArray[1][9] == 1) { // if in game mode 2 (Play Friend)
    //     _gamemode2_Array();
    //   }
    //   else {
    //     print(
    //         'Problem with flags, seems gamemode flag got deleted somewhere along the way. Otherwise, other issue with flags');
    //     final updatedArray = ArrayForNicole.handleArray(_currentArray);
    //   }
    // }
    // else {
    //   print(
    //       'Problem with flags, seems gamemode flag got deleted somewhere along the way. Otherwise, other issue with flags');
    //   final updatedArray = ArrayForNicole.handleArray(_currentArray);
    // }
  }

  /// Saves a 2D array from a POST request payload.
  static String save2DArray(String payload) {
    try {
      final parsedData = jsonDecode(payload);
      final chessMoves = parsedData['chess_moves'];

      print("payload:");
      print(payload);

      if (chessMoves is List) {
        final validatedArray = chessMoves.map<List<int>>((row) {
          if (row is List) {
            return row.map<int>((element) => element as int).toList();
          } else {
            throw FormatException('Row is not a valid List<int>.');
          }
        }).toList();

        print("test1");

        if (validatedArray.length != 8 ||
            validatedArray.any((row) => row.length != 10)) {
          return 'Invalid array size. Expected 8x10.';
        }

        print("test2");;

        updateArray(validatedArray);
        return '2D array successfully updated.';
      } else {
        return 'Invalid data format. Expected a 2D array.';
      }
    } catch (e) {
      print('Error parsing JSON: $e');
      return 'Error parsing JSON.';
    }
  }


  static List<List<int>> updateLEDs(List<List<int>> ledArray)
  {
    //_currentArray

    List<List<int>> finalArray = [[],[],[],[],[],[],[],[]];

    //print _currentArray
    print("PRINT CURRENT ARRAY");
    for(List<int> row in _currentArray)
      {
        print(row);
      }


    for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
          {
            finalArray[i].add(ledArray[7-i][j]);
          }
        for(int j = 0; j < 2; j++)
          {
            print("row:$i\tcol:$j}");

            print(_currentArray[i][j+8]);
            finalArray[i].add(_currentArray[i][j+7]);
          }
      }
     // 3 8 turn

    if(Server.chessKey.currentState!.c.turn == ChessPieceTeam.white)
      {
        finalArray[3][8] = 1;
      }
    else
      {
        finalArray[3][8] = 2;
      }

    return finalArray;
  }
}
