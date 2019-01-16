import 'dart:async';

import 'package:flutter/services.dart';

class SocketClient {

  String _url;
  String _namespace;
  String _query;

  SocketClient(String url, String namespace, {String query}) {
    _url = url;
    _namespace = namespace;
    _query = query;
  }

  String getUrl() { return _url; }

  String getNamespace() { return _namespace; }

  String getQuery() { return _query; }

  Future<void> connect() async {

  }

  Future<void> destroy() async {

  }

}