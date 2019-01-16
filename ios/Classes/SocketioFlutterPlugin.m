#import "SocketioFlutterPlugin.h"
#import <socketio_flutter/socketio_flutter-Swift.h>

@implementation SocketioFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSocketioFlutterPlugin registerWithRegistrar:registrar];
}
@end
