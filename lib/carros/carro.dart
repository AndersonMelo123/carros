import 'package:carros/utils/entity.dart';
import 'dart:convert' as convert;

import 'package:carros/utils/event_bus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class  CarroEvent extends Event{
  String acao;

  String tipo;

  CarroEvent(this.acao, this.tipo);

  @override
  String toString() {
    return 'CarroEvent{acao: $acao, tipo: $tipo}';
  }


}

class Carro extends Entity{
  int id;
  String nome;
  String tipo;
  String descricao;
  String urlFoto;
  String urlVideo;
  String latitude;
  String longitude;

  latLng(){
    return LatLng(
        latitude == null || latitude.isEmpty ? 0.0 : double.parse(latitude),
        longitude == null || longitude.isEmpty ? 0.0 : double.parse(longitude)
    );
  }

  Carro(
      {this.id,
        this.nome,
        this.tipo,
        this.descricao,
        this.urlFoto,
        this.urlVideo,
        this.latitude,
        this.longitude});

  Carro.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    tipo = map['tipo'];
    descricao = map['descricao'];
    urlFoto = map['urlFoto'];
    urlVideo = map['urlVideo'];
    latitude = map['latitude'];
    longitude = map['longitude'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['tipo'] = this.tipo;
    data['descricao'] = this.descricao;
    data['urlFoto'] = this.urlFoto;
    data['urlVideo'] = this.urlVideo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }

  String toJson() {
    return convert.json.encode(toMap());
  }
}