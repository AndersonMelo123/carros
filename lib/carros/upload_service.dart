import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:carros/login/usuario.dart';
import 'package:carros/pages/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UploadService {
  static Future<ApiResponse<String>> upload(File file) async {
    try {

      Usuario user = await Usuario.get();

      String url = "https://carros-springboot.herokuapp.com/api/v2/upload";
      
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = convert.base64Encode(imageBytes);
      
      String fileName = path.basename(file.path);
      
      //var headers = {"Content-Type": "application/json"};
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      };
      
      var params = {
        "fileName": fileName,
        "mimeType": "image/jpeg",
        "base64": base64Image
      };
      
      String json = convert.jsonEncode(params);
      
      print("http.upload: " + url);
      print("params: " + json);
      
      final response = await http.post(url, body: json, headers: headers).timeout(
        Duration(seconds: 120),
        onTimeout: _onTimeOut,
      );
      
      print("http.upload << " + response.body);
      
      Map<String, dynamic> map = convert.json.decode(response.body);
      
      String urlFoto = map["url"];
      
      return ApiResponse.ok(urlFoto);
    } catch (er , e) {
      print("Erro no uploaf $er - $e");
      return ApiResponse.error("Erro no Upload");
    }
  }

  static FutureOr<http.Response> _onTimeOut() {
    print("timeout!");
    throw SocketException("Não foi possível se comunicar com o servidor.");
  }
}