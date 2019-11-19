import 'package:carros/utils/base_dao.dart';
import 'package:carros/favoritos/favorito.dart';

class FavoritoDAO extends BaseDAO<Favorito>{
  @override
  Favorito fromMap(Map<String, dynamic> map) {
    return Favorito.fromMap(map);
  }

  @override
  String get tableName => "favorito";

}