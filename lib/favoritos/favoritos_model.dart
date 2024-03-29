
import 'package:carros/carros/carro.dart';
import 'package:carros/favoritos/favorito_service.dart';
import 'package:flutter/material.dart';

class FavoritosModel extends ChangeNotifier {
    List<Carro> carros = [];

    Future<List<Carro>> getCarros() async {
      carros = await FavoritoService.getCarros();

      notifyListeners();

      return carros;
    }
}