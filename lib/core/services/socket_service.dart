import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'dart:developer' as developer;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;
  final SharedPrefService _prefs = SharedPrefService();
  
  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> init() async {
    if (_socket != null) return;

    final token = await _prefs.getToken();

    if (token == null) {
      developer.log("⚠️ No token found for Socket connection", name: "SOCKET");
      return;
    }

    _socket = io.io('http://52.35.230.229:3006', 
      io.OptionBuilder()
        .setTransports(['websocket'])
        .setPath('/api/socket')
        .setAuth({'token': token})
        .enableAutoConnect()
        .enableReconnection()
        .build()
    );

    _socket!.onConnect((_) {
      developer.log("✅ Socket Connected", name: "SOCKET");
      _connectionController.add(true);
    });

    _socket!.onDisconnect((_) {
      developer.log("❌ Socket Disconnected", name: "SOCKET");
      _connectionController.add(false);
    });

    _socket!.onConnectError((data) {
      developer.log("⚠️ Socket Connection Error: $data", name: "SOCKET");
      _connectionController.add(false);
    });
  }

  void emit(String event, dynamic data, [Function? ack]) {
    if (_socket == null || !_socket!.connected) {
      developer.log("⚠️ Cannot emit $event: Socket not connected", name: "SOCKET");
      return;
    }
    
    if (ack != null) {
      _socket!.emitWithAck(event, data, ack: ack);
    } else {
      _socket!.emit(event, data);
    }
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
