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
    
    static func sendLog(text: String) -> Void {
        getMethodChannel().invokeMethod("sendLog", arguments: text)
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
                SwiftSocketioFlutterPlugin.sendLog(text: "SOCKET CONNECTED")
                SwiftSocketioFlutterPlugin
                    .getMethodChannel()
                    .invokeMethod(
                        "\(url)-\(namespace)-callbackSocketConnected",
                        arguments: true
                )
            })
            
            socket?.onAny({ (event) in
                SwiftSocketioFlutterPlugin.sendLog(text: "SOCKET ON " + event.event + " WITH DESC " + event.description)
                SwiftSocketioFlutterPlugin
                    .getMethodChannel()
                    .invokeMethod(
                        "\(url)-\(namespace)-listen.\(event.event)",
                        arguments: event.items
                )
            })
            
            socket?.connect()
            result(true)
        }
        
        if call.method == "socketDisconnect" {
            socket?.disconnect()
            result(true)
        }
        
        if call.method == "socketStatus" {
            result(socket?.status.active)
        }
        
        if call.method.starts(with: "socketSend") {
            let argumentsDictionary = call.arguments as! NSDictionary
            let data = try? JSONSerialization.data(withJSONObject: argumentsDictionary, options: .prettyPrinted)
            let json = String(data: data!, encoding: String.Encoding.ascii)
            socket?.emit(call.method.components(separatedBy: "socketSend-")[1], with: [json as Any])
            result(true)
        }

        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        }
  }
}
