import 'server.dart';

/// Entry point of the application.
void main() async {
  print('Starting server...');
  await Server.start();
}
