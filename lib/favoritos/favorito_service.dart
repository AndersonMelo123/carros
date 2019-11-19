import 'package:carros/carros/carro.dart';
import 'package:carros/carros/carro_dao.dart';
import 'package:carros/favoritos/favorito.dart';
import 'package:carros/favoritos/favorito_dao.dart';

class FavoritoService{
  static Future<bool> favoritar(Carro c) async{
    Favorito f = Favorito.fromCarro(c);

    final dao = FavoritoDAO();

    final exists = await dao.exists(c.id);
    
    if(exists){
      dao.delete(c.id);
      return false;
    }else{
      dao.save(f);
      return true;
    }
  }
  static Future<List<Carro>> getCarros() {
    return CarroDAO().query("select * from carro c, favorito f where c.id = f.id");
  }

  static Future<bool> isFavorito(Carro c) async {
    final dao = FavoritoDAO();
    final exists = await dao.exists(c.id);

    return exists;
  }
}