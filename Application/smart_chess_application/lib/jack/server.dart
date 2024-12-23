import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:smart_chess_application/models/chesspiece.dart';
import '../chessboard_view_live.dart';
import 'flag_checker.dart';

class Server {

  static GlobalKey<ChessboardViewLiveState> chessKey = GlobalKey();
  static bool readyToSend = true;


  // static void startListening()
  // {
  //   chessKey.currentState!.c.readyToSend.listen( (flag) {
  //     readyToSend = flag;
  //   });
  // }

  /// Starts the server
  static Future<void> start() async {



    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler((Request request) async {
      // Handle GET requests
      if (request.method == 'GET' && request.url.path == 'config') {

        print('Received GET request:');

        // await chessKey.currentState!.c.stateUpdateCompleter.future;
        // final updatedState = chessKey.currentState!.c.getUpdatedState();

        // Execute flag checker before responding
        FlagChecker.checkFlags();
        // await chessKey.currentState!.c.stateUpdateCompleter.future;

        print("Playing with AI: ${chessKey.currentState!.c.playingWithAI}");
        print("turn: ${chessKey.currentState!.c.turn}");

        if(chessKey.currentState!.c.playingWithAI && chessKey.currentState!.c.turn == ChessPieceTeam.black)
          {
            print("WAITING");
            await chessKey.currentState!.c.stateUpdateCompleter.future;
          }
        // TODO: new logic for returning LEDS
        // if(chessKey.currentState!.c.playingWithAI && chessKey.currentState!.c.turn == ChessPieceTeam.black)
        // if()
        //   sleep(const Duration(milliseconds: 20));
        // if(!readyToSend)
        if(chessKey.currentState!.c.determiningResult)
          {
            // return Response.notFound("RESULT TBD");
            // sleep(const Duration(seconds:1));

            return Response.notFound("RESULT TBD");

            print(chessKey.currentState!.c.determiningResult);
          }


            List<List<int>> fullArray = FlagChecker.updateLEDs(chessKey.currentState!.c.leds.ledArray);
            final response = provideUpdated2DArrayFromParam(fullArray);
            print('sending GET response: ');
            _printPrettyJson(response);
            return Response.ok(response, headers: {'Content-Type': 'application/json'});


        //
        // // Provide updated array after any required changes
        // final response = provideUpdated2DArray();
        // print('GET request returning the following 2D array:');
        // _printPrettyJson(response);
        // return Response.ok(response, headers: {'Content-Type': 'application/json'});
      }

      // Handle POST requests
      if (request.method == 'POST' && request.url.path == 'data') {
        final payload = await request.readAsString();
        print('Received POST data:');
        // _prettyPrintArrayFromPayload(payload);
        print('Attempting to update the 2D array...');
        final result = FlagChecker.save2DArray(payload);

        if (result == '2D array successfully updated.') {

          for(List<int> a in FlagChecker.currentArray)
            {
              print(a);
            }

          // print("WHYYYYYYYY");

          return Response.ok(result);
        } else {
          return Response.badRequest(body: result);
        }
      }

      // Default response for unsupported routes
      return Response.notFound('Page not found');
    });

    final server = await io.serve(handler, '172.20.10.13', 8080);
    print('Server started successfully. Listening on http://${server.address.host}:${server.port}');
  }

  /// Provides the updated 2D array for GET requests.
  static String provideUpdated2DArray() {
    final currentArray = FlagChecker.currentArray;
    return jsonEncode({'chess_moves': currentArray});
  }

  /// Provides the updated 2D array for GET requests.
  static String provideUpdated2DArrayFromParam(List<List<int>> array) {
    return jsonEncode({'chess_moves': array});
  }

  /// Prints JSON in a pretty format.
  static void _printPrettyJson(String jsonData) {
    try {
      if (jsonData.trim().startsWith('{') || jsonData.trim().startsWith('[')) {
        final decodedJson = jsonDecode(jsonData);

        if (decodedJson is Map && decodedJson.containsKey('chess_moves')) {
          for (var i = 0; i < decodedJson['chess_moves'].length; i++) {
            print('Row $i: ${decodedJson['chess_moves'][i]} // PrettyPrint');
          }
        } else {
          final prettyJson = const JsonEncoder.withIndent('  ').convert(decodedJson);
          print(prettyJson);
        }
      } else {
        print(jsonData);
      }
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }

  /// Prints a payload array in a readable format.
  static void _prettyPrintArrayFromPayload(String payload) {
    try {
      final decodedPayload = jsonDecode(payload);
      final chessMoves = decodedPayload['chess_moves'];

      if (chessMoves is List) {
        for (var i = 0; i < chessMoves.length; i++) {
          print('Row $i: ${chessMoves[i]} // PayloadPrint');
        }
      } else {
        print('Invalid 2D array format in payload.');
      }
    } catch (e) {
      print('Error decoding payload: $e');
    }
  }
}
