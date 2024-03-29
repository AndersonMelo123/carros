import 'dart:async';
import 'package:carros/carros/carro.dart';
import 'package:http/http.dart' as http;

class LoripsumApiBloc {

  static String lorim;

  final _streamController = StreamController<String>();

  Stream<String> get stream => _streamController.stream;

  fetch() async {
    try {
      String s = lorim ?? await LoripsumApi.getLoripsum();

      lorim = s;

      _streamController.add(s);
    } catch (e) {
      _streamController.addError(e);
    }
  }

  void dispose() {
    _streamController.close();
  }
}

class LoripsumApi {
  static Future<String> getLoripsum() async {
    var url = 'https://loripsum.net/api';

    var response = await http.get(url);

    String text = response.body;

    text = text.replaceAll("<p>", "");
    text = text.replaceAll("</p>", "");

    return text;
  }
}
