import 'dart:convert' as convert;

import 'package:carros/carros/carro.dart';
import 'package:carros/carros/carro_dao.dart';
import 'package:carros/login/usuario.dart';
import 'package:carros/pages/api_response.dart';
import 'package:http/http.dart' as http;

class TipoCarro {
  static final String classicos = "classicos";
  static final String esportivos = "esportivos";
  static final String luxo = "luxo";
}

class CarrosApi {
  static Future<List<Carro>> getCarros(String tipo) async {
    try {
      Usuario user = await Usuario.get();

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      };

      var url =
          'http://carros-springboot.herokuapp.com/api/v2/carros/tipo/$tipo';

      print("GET >> $url");

      var response = await http.get(url, headers: headers);

      List list = convert.json.decode(response.body);

      List<Carro> carros =
          list.map<Carro>((map) => Carro.fromMap(map)).toList();

      return carros;
    } catch (er) {
      print("ERRO >>> $er");
      throw er;
    }
  }

  static Future<ApiResponse<bool>> save(Carro c) async {
    try {
      Usuario user = await Usuario.get();

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      };

      var url = 'http://carros-springboot.herokuapp.com/api/v2/carros/';
      if(c.id != null){
        url += "${c.id}";
      }

      print("POST >> $url");

      String json = c.toJson();

      var response = await (c.id == null
          ? http.post(url, body: json, headers: headers)
          : http.put(url, body: json, headers: headers));

      print('response status ${response.statusCode}');
      print('response body $response.body');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Carro carro = Carro.fromMap(mapResponse);
        print("Novo carro ${carro.id}");
        return ApiResponse.ok(true);
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error("Não foi possivel salvar o carro");
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(mapResponse["error"]);

    } catch (e) {
      print(e);
      return ApiResponse.error("Não foi possivel salvar o carro");
    }
  }
}
