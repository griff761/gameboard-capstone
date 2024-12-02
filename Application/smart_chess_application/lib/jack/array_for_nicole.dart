class ArrayForNicole {
  static late List<List<int>> _storedArray;

  /// Handles the 2D array for Game Mode 1.
  static List<List<int>> handleArray(List<List<int>> array) {
    print('AIPlaceholder: Handling the 2D array...');


    // _storedArray is the one you will feed into the AI program. Return it here.
    // something like _storedArray = nicole's_AI_handler(_storedArray);
    _storedArray = array.map((row) => List<int>.from(row)).toList(); // Save the array


    print('AIPlaceholder: Array received and stored.');
    return _storedArray; // Return unaltered array
  }
}
