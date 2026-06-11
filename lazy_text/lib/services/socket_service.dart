import 'package:socket_io_client/socket_io_client.dart'
    as IO;

class SocketService {
  static late IO.Socket socket;

  static void connect(
    String userId,
  ) {
    socket = IO.io(
      "http://10.0.2.2:5001",
      IO.OptionBuilder()
          .setTransports(
            ['websocket'],
          )
          .setQuery(
            {'userId': userId},
          )
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print(
        "SOCKET CONNECTED",
      );
    });

    socket.onDisconnect((_) {
      print(
        "SOCKET DISCONNECTED",
      );
    });
  }
}