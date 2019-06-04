part of flutter_plugin_bloc;

class Tools {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_bloc');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
