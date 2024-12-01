import 'server.dart';

// Message for Nicole: look into AI_placeholder.dart
// --> This is where you get the 2d-array you feed into and out to.
// So feed into your software, store it and use for whatever you want, giving to AI
// Then this is the spot you have a method return a 2-d array with the next move given.


/// Entry point of the application.
void main() async {
  print('Starting server...');
  await Server.start();
}
