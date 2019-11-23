import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/carros/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'carro.dart';

class CarrosListView extends StatelessWidget {

  List<Carro> carros;

  CarrosListView(this.carros);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: carros != null ? carros.length : 0,
          itemBuilder: (context, index) {
            Carro c = carros[index];

            return Container(
              child: InkWell(
                onTap: (){
                  _onClickCarro(context, c);
                },
                onLongPress: (){
                  _onLongClickCarro(context, c);
                },
                child: Card(
                  color: Colors.grey[100],
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: CachedNetworkImage(
                            imageUrl:
                            c.urlFoto ??
                              "http://www.livroandroid.com.br/livro/carros/esportivos/Lamborghini_Aventador.png",
                            width: 250,
                        )),
                        Text(
                          c.nome ?? "Carro",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          "descrição...",
                          style: TextStyle(fontSize: 16),
                        ),
                        ButtonTheme.bar(
                          // make buttons use the appropriate styles for cards
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('DETALHES'),
                                onPressed: () => _onClickCarro(context, c),
                              ),
                              FlatButton(
                                child: const Text('SHARE'),
                                onPressed: () {
                                  /* ... */
                                  _onClickShare(context, c);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _onClickCarro(context, Carro c) {
    push(context, CarroPage(c));
  }

  _onLongClickCarro(BuildContext context, Carro c) {
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(c.nome, style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold
            ),),
          ),
          ListTile(
            title: Text("Detlhes"),
            leading: Icon(Icons.directions_car),
            onTap: () {
              Navigator.pop(context);
              _onClickCarro(context, c);
            },
          ),
          ListTile(
            title: Text("Share  "),
            leading: Icon(Icons.share),
            onTap: () {
              Navigator.pop(context);
              _onClickShare(context, c);
            },
          ),
        ],
      );
    });
  }

  void _onClickShare(BuildContext context, Carro c) {
    print("Share ${c.nome}");

    Share.share(c.urlFoto);
  }

}



