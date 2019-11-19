import 'dart:async';

import 'package:carros/carros/carro.dart';
import 'package:carros/carros/carros_api.dart';
import 'package:carros/carros/carro_dao.dart';
import 'package:carros/favoritos/favorito_service.dart';
import 'package:carros/utils/network.dart';

class FavoritosBloc {

  final _streamController = StreamController<List<Carro>>();

  Stream<List<Carro>> get stream => _streamController.stream;

  Future<List<Carro>> fetch() async{
    try{

      List<Carro> carros = await FavoritoService.getCarros();

      if(carros.isNotEmpty){
        final dao = CarroDAO();
        carros.forEach(dao.save);
      }
      _streamController.sink.add(carros);
      return carros;
    }catch (e){
      _streamController.addError(e);
    }
  }

  void dispose() {
    _streamController.close();
  }
}