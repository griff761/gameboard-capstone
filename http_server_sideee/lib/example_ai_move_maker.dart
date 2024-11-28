import 'request_2d_array_interpreter.dart';
import 'ai_logic_handler.dart';
import 'flag_checker.dart';

/// Example AI Move Maker
/// This file uses the AI logic handler to process the 2D array.

class ExampleAIMoveMaker {
  /// Executes the AI logic to update the 2D array.
  static void makeMove() {
    print('AI Move Maker: Fetching the current 2D array...');
    final currentArray = Request2DArrayInterpreter.currentArray;

    print('AI Move Maker: Current 2D array before AI move:');
    for (var i = 0; i < currentArray.length; i++) {
      print('Row $i: ${currentArray[i]} // BeforeMove');
    }

    // Update the array using the AI logic handler
    final updatedArray = AILogicHandler.processArray(currentArray);

    // Save the updated array back
    Request2DArrayInterpreter.updateArray(updatedArray);

    print('AI Move Maker: Updated 2D array after AI move:');
    for (var i = 0; i < updatedArray.length; i++) {
      print('Row $i: ${updatedArray[i]} // AfterMove');
    }

    // Check for flags after updating the array
    FlagChecker.checkFlags();
  }
}
