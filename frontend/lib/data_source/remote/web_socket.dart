import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketDataSource {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _incomingController =
      StreamController.broadcast();

  String? _url;
  String? _token;
  bool _isManualClose = false;
  int _retryDelay = 1;

  Stream<Map<String, dynamic>> get stream => _incomingController.stream;

  void connect(String url, String token) {
    _url = url;
    _token = token;
    _isManualClose = false;
    _establishConnection();
  }

  void _establishConnection() {
    if (_isManualClose) return;

    final wsUrl = Uri.parse('$_url?token=$_token');
    _channel = WebSocketChannel.connect(wsUrl);

    _channel!.stream.listen(
      (data) {
        _retryDelay = 1;
        final Map<String, dynamic> decoded = jsonDecode(data);
        _incomingController.add(decoded);
      },
      onDone: () => _handleReconnect(),
      onError: (e) => _handleReconnect(),
    );
  }

  void _handleReconnect() {
    if (_isManualClose) return;

    print("WS connection lost. Reconnecting in $_retryDelay seconds...");

    Timer(Duration(seconds: _retryDelay), () {
      if (_retryDelay < 30) _retryDelay *= 2;
      _establishConnection();
    });
  }

  void sendAction(String action, dynamic requestModel) {
    if (_channel == null || _channel?.closeCode != null) {
      print("Cannot send: WS is disconnected");
      return;
    }

    final packet = {"action": action, "data": requestModel.toProto3Json()};

    _channel!.sink.add(jsonEncode(packet));
  }

  void dispose() {
    _isManualClose = true;
    _channel?.sink.close(status.goingAway);
    _incomingController.close();
  }
}
