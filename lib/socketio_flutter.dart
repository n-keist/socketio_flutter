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
      if(call.method == "sendLog") {
        print("IOS >> ${call.arguments}");
      } else {
        var method = call.method.split("-");
        var url = method[0];
        var namespace = method[1];
        var function = method[2];

        String id = makeId(url, namespace);
        if(exists(id)) {
          SocketClient socketClient = getById(id);
          print("#$id handling $function");
          socketClient.handle(function, call.arguments);
        } else {
          print("Socket $id does not exist");
        }
      }
    }
  }

  String makeId(String url, String namespace) {
    return "$url-$namespace";
  }

  SocketClient getById(String id) {
    return _clients[id];
  }

  bool exists(String id) {
    return _clients.containsKey(id);
  }

  SocketClient createClient(String url, String namespace, {String query}) {
    String id = makeId(url, namespace);
    if(!_clients.containsKey(id)) {
      SocketClient socketClient = new SocketClient(_channel, url, namespace, query: query);
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
