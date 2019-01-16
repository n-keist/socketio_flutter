import 'dart:async';

import 'package:flutter/services.dart';
import 'package:socketio_flutter/socket_client.dart';

class SocketIOFlutter {
  static const MethodChannel _channel =
      const MethodChannel('socketio_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Map<String, SocketClient> _clients;

  SocketIOFlutter() {
    _channel.setMethodCallHandler(_handler);
    _clients = new Map();
  }

  Future<void> _handler(MethodCall call) async {
    if(call.method != null && call.method.isNotEmpty) {
      if(call.method == "callbackSocketConnected") {
        
      }
    }
  }

  String makeId(String url, String namespace) {
    return "$url-$namespace";
  }


  SocketClient createClient(String url, String namespace, {String query}) {
    String id = makeId(url, namespace);
    if(!_clients.containsKey(id)) {
      SocketClient socketClient = new SocketClient(url, namespace, query: query);
      _clients.putIfAbsent(id, () => socketClient);
    }
    return null;
  }

  void destroyClient(String url, String namespace) {
    String id = makeId(url, namespace);
    if(_clients.containsKey(id)) {
      _clients[id].destroy();
      _clients.remove(id);
    }
  }

}
