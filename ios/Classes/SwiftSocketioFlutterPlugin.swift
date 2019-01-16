import Flutter
import UIKit
import SocketIO

public class SwiftSocketioFlutterPlugin: NSObject, FlutterPlugin {
    
    static var methodChannel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "socketio_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftSocketioFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        setMethodChannel(methodChannel: channel)
    }
    
    static func setMethodChannel(methodChannel: FlutterMethodChannel) {
        SwiftSocketioFlutterPlugin.methodChannel = methodChannel
    }
    
    static func getMethodChannel() -> FlutterMethodChannel {
        return (methodChannel)!
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        var socketManager: SocketManager
        var socket: SocketIOClient?
        
        if call.method == "socketConnect" {
            let arguments = call.arguments as! NSDictionary
            
            let url = arguments["url"] as! String
            let namespace = arguments["namespace"] as! String
            let queryString = arguments["query"] as! String
            var queryDictionary: [String: String] = [:]
            
            let queryComponents: [String] = queryString.components(separatedBy: "&")
            
            for component in queryComponents {
                let pair = component.components(separatedBy: "=")
                queryDictionary[pair.first!] = queryDictionary[pair.last!]
            }
            
            socketManager = SocketManager(
                socketURL: URL(string: url)!,
                config: [
                    .log(true),
                    .compress,
                    .connectParams(queryDictionary)
                    ]
            )
            
            socket = socketManager.socket(forNamespace: namespace)
            
            socket?.on(clientEvent: .connect, callback: { (data, ack) in
                SwiftSocketioFlutterPlugin
                    .getMethodChannel()
                    .invokeMethod("callbackSocketConnected", arguments: true)
            })
            
            socket?.connect()
        }
        
        if call.method == "socketDisconnect" {
            socket?.disconnect()
            result("disconnected")
        }
        
        if call.method == "socketStatus" {
            result(socket?.status.active)
        }

        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        }
  }
}
