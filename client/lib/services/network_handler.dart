import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:online_matchmaking_system/utils/api.dart';

class NetworkHandler {
  //todo: add other http requests here later

  final appurl = Api.appurl;

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

  static Future<void> deleteOne(String key) async {
    return await storage.delete(key: key);
  }

  //clear all after logout
  static Future<void> deleteAll() async {
    return await storage.deleteAll();
  }

  Future<http.StreamedResponse> uploadImage(
      String route, String filepath, String key) async {
    final url = "$appurl$route";
    final uri = Uri.parse(url);
    final token = await getValue("token");
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(key, filepath));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "authorization": "Bearer $token",
    });
    var response = request.send();
    return response;
  }

  Future<http.Response> getData(String route) async {
    final url = "$appurl$route";
    final uri = Uri.parse(url);
    final token = await getValue("token");
    var response = await http.get(uri, headers: {
      "authorization": "Bearer $token",
    });
    return response;
  }

  Future<http.Response> vote(String route) async {
    final url = "$appurl$route";
    final uri = Uri.parse(url);
    final token = await getValue("token");
    var response = await http.post(uri, headers: {
      "authorization": "Bearer $token",
    });
    return response;
  }

  Future<http.Response> handleReq(String route, String id) async {
    final reqBody = {
      "reqI": id,
    };
    final url = "$appurl$route";
    final uri = Uri.parse(url);
    final token = await getValue("token");
    final response = await http.post(uri, body: jsonEncode(reqBody), headers: {
      "authorization": "Bearer $token",
      "Content-type": "application/json",
    });
    return response;
  }

  Future<http.Response> deleteData(String route, String id) async {
    final url = "$appurl$route";
    final uri = Uri.parse(url);
    final token = await getValue("token");
    final body = {
      "reqId": id,
    };

    var response = await http.delete(uri, body: jsonEncode(body), headers: {
      "authorization": "Bearer $token",
      "Content-type": "application/json",
    });
    return response;
  }
}
