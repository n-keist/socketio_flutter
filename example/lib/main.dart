import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:socketio_flutter/socketio_flutter.dart';
import 'package:socketio_flutter/socket_client.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  String _connectionStatus = "undefined.";
  Color _currentColor = Colors.deepOrange;
  SocketClient _socketClient;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await SocketIOFlutter.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FSIO+$_platformVersion'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: _connectPressed,
                child: Text("Connect FSIO"),
              ),
              Text(
                _connectionStatus,
                style: TextStyle(
                  color: _currentColor,
                  fontSize: 16.0
                ),
              ),
              RaisedButton(
                onPressed: _statusPressed,
                child: Text("Get Status"),
              )
            ],
          ),
        ),
      ),
    );
  }

  _connectPressed() {
    print("connect pressed");
    _socketClient = SocketIOFlutter().createClient("http://n-keist.de:3333", "/");
    _socketClient.connect(_socketConnected);

  }

  _socketConnected(param) {
    print("Socket connected!");
    setState(() {
      _currentColor = param ? Colors.green : Colors.red;
      _connectionStatus = param ? "Connected" : "Connection failed.";
    });
  }

  _statusPressed() async {
    bool status = await _socketClient.status();
    setState(() {
      _currentColor = status ? Colors.green : Colors.red;
      _connectionStatus = status ? "Connected" : "Connection failed.";
    });
  }
}
