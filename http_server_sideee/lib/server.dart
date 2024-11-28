import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'request_2d_array_interpreter.dart';
import 'example_ai_move_maker.dart';
import 'flag_checker.dart';

class Server {
  /// Starts the server
  static Future<void> start() async {
    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler((Request request) async {
      // Handle GET requests
      if (request.method == 'GET' && request.url.path == 'config') {
        // Execute flag checker before responding
        FlagChecker.checkFlags();

        // Provide updated array after any required changes
        final response = provideUpdated2DArray();
        print('GET request returning the following 2D array:');
        _printPrettyJson(response);
        return Response.ok(response, headers: {'Content-Type': 'application/json'});
      }

      // Handle POST requests
      if (request.method == 'POST' && request.url.path == 'data') {
        final payload = await request.readAsString();
        print('Received POST data:');
        _prettyPrintArrayFromPayload(payload);
        print('Attempting to update the 2D array...');
        final result = Request2DArrayInterpreter.save2DArray(payload);
        print(result);

        if (result == '2D array successfully updated.') {
          ExampleAIMoveMaker.makeMove();
          print('AI Move Maker successfully updated the manipulated array.');
          return Response.ok(result);
        } else {
          return Response.badRequest(body: result);
        }
      }

      // Default response for unsupported routes
      return Response.notFound('Page not found');
    });

    final server = await io.serve(handler, '172.20.10.6', 8080);
    print('Server started successfully. Listening on http://${server.address.host}:${server.port}');
  }

  /// Provides the updated 2D array for GET requests.
  static String provideUpdated2DArray() {
    final currentArray = Request2DArrayInterpreter.currentArray;
    return jsonEncode({'chess_moves': currentArray});
  }

  /// Prints JSON in a pretty format.
  static void _printPrettyJson(String jsonData) {
    try {
      if (jsonData.trim().startsWith('{') || jsonData.trim().startsWith('[')) {
        final decodedJson = jsonDecode(jsonData);

        if (decodedJson is Map && decodedJson.containsKey('chess_moves')) {
          print('Chess Moves 2D Array:');
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
