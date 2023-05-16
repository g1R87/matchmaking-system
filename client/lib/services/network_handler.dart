import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkHandler {
  //todo: add other http requests here later

  final appurl = dotenv.env["appurl"];

  //local storage
  static const storage = FlutterSecureStorage();

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

  Future<http.StreamedResponse> updatePfp(String filepath) async {
    final url = "$appurl/image/pfp";
    final uri = Uri.parse(url);
    final token = await getValue("token");
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath("myImage", filepath));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "authorization": "Bearer $token",
    });
    var response = request.send();
    return response;
  }
}
