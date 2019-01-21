import 'dart:async';

import 'package:flutter/services.dart';

class SocketClient {

  String _url;
  String _namespace;
  String _query;
  MethodChannel _channel;

  Map<String, Function> _functions;

  SocketClient(MethodChannel channel, String url, String namespace, {String query}) {
    _channel = channel;
    _url = url;
    _namespace = namespace;
    if(namespace.isEmpty) {
      _namespace = "/";
    }
    _query = query;
    _functions = Map();

  }

  void handle(String function, dynamic arguments) {
    if(_functions.containsKey(function)) {
      _functions[function](arguments);
    }
  }

  MethodChannel getMethodChannel() { return _channel; }

  String getUrl() { return _url; }

  String getNamespace() { return _namespace; }

  String getQuery() { return _query; }

  Future<void> connect(Function callback) async {
    bool response = await _channel.invokeMethod("socketConnect", {'url': _url, 'namespace': _namespace, 'query': _query});
    _functions.putIfAbsent("callbackSocketConnected", () => callback);
    print("Executing 'socketConnect' successful? $response");
  }

  Future<void> destroy() async {
    bool response = await _channel.invokeMethod("socketDisconnect");
    print("Executing 'socketDisconnect' successful? $response");
  }

  Future<bool> status() async {
    bool response = await _channel.invokeMethod("socketStatus");
    return response;
  }

  Future<void> send(String event, {dynamic data}) async {
    bool response = await _channel.invokeMethod("socketSend-$event", data);
    print("Executing 'socketSend' successful? $response");
  }

  Future<void> listen(String event, Function callback) async {
    _functions.putIfAbsent("listen.$event", () => callback);
  }



}