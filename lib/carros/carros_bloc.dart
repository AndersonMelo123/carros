import 'dart:async';

import 'package:carros/carros/carro.dart';
import 'package:carros/carros/carros_api.dart';
import 'package:carros/carros/carro_dao.dart';
import 'package:carros/utils/network.dart';

class CarrosBloc {

  final _streamController = StreamController<List<Carro>>();

  Stream<List<Carro>> get stream => _streamController.stream;

  Future<List<Carro>> fetch(String tipo) async{
    try{

      bool onNetwork = await isNetworkOn();

      if(!onNetwork){
        List<Carro> carros = await CarroDAO().findAllByTipo(tipo);
        _streamController.sink.add(carros);
        return carros;
      }

      List<Carro> carros = await CarrosApi.getCarros(tipo);

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