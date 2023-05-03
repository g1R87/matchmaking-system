import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkHandler {
  //todo: add other http requests here later

  //local storage
  static const storage = FlutterSecureStorage();
  //store token
  static Future<void> storeToken(String token) async {
    await storage.write(
      key: "token",
      value: token,
    );
  }

  //read token
  static Future<String?> getToken(String token) async {
    return await storage.read(key: "token");
  }
}
