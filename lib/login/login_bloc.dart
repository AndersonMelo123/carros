import 'dart:async';

import 'package:carros/login/usuario.dart';
import 'package:carros/pages/api_response.dart';

import 'login_api.dart';

class LoginBloc{

  final _streamController = StreamController<bool>();

  get stream => _streamController.stream;

  Future<ApiResponse<Usuario>> login(String login, String senha) async {
    _streamController.add(true);

    ApiResponse response = await LoginApi.login(login, senha);

    _streamController.add(false);

    return response;
  }

  void dispose(){
    _streamController.close();
  }
}