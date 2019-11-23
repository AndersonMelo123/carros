import 'dart:async';

import 'package:carros/carros/carro.dart';
import 'package:carros/carros/carros_listview.dart';
import 'package:carros/favoritos/favoritos_model.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {
  List<Carro> carros;



  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    FavoritosModel model = Provider.of<FavoritosModel>(context, listen: false);
    model.getCarros();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    FavoritosModel model = Provider.of<FavoritosModel>(context);

    List<Carro> carros = model.carros;

    if(carros.isEmpty){
      return Center(
        child: Text(
          "Sem Carros aqui",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
    }

    return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CarrosListView(carros),
        );
  }


  Future<void> _onRefresh() {
    return Provider.of<FavoritosModel>(context, listen: false).getCarros();
  }

}
