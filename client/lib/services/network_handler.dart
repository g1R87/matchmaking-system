import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkHandler {
  //todo: add other http requests here later

  //local storage
  static const storage = FlutterSecureStorage();
  //store token
  // static Future<void> storeToken(String token) async {
  //   await storage.write(
  //     key: "token",
  //     value: token,
  //   );
  // }
  static Future<void> storeValue(String key, String value) async {
    await storage.write(
      key: key,
      value: value,
    );
  }

  //read token
  static Future<String?> getValue(String key) async {
    return await storage.read(key: key);
  }
}
