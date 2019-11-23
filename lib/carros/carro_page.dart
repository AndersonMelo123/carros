import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/carros/carro.dart';
import 'package:carros/carros/carro_form_page.dart';
import 'package:carros/carros/loripsum_api.dart';
import 'package:carros/favoritos/favorito_service.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/mapa_page.dart';
import 'package:carros/pages/video_page.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'carros_api.dart';

class CarroPage extends StatefulWidget {
  Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumApiBloc = LoripsumApiBloc();

  Color color = Colors.grey;

  Carro get carro => widget.carro;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FavoritoService.isFavorito(carro).then((bool fav) {
      setState(() {
        color = fav ? Colors.red : Colors.grey;
      });
    });

    _loripsumApiBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carro.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: () {_onClickMapa(context);},
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {_onClickVideo(context);},
          ),
          PopupMenuButton<String>(
            onSelected: _onClickPopupMenu,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "Editar",
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  value: "Deletar",
                  child: Text("Deletar"),
                ),
                PopupMenuItem(
                  value: "Share",
                  child: Text("Share"),
                )
              ];
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.carro.urlFoto ??
                "http://www.livroandroid.com.br/livro/carros/esportivos/Lamborghini_Aventador.png",
          ),
          _bloco1(),
          Divider(),
          _bloco2(),
        ],
      ),
    );
  }

  Row _bloco1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text(widget.carro.nome, fontSize: 20, bold: true),
            text(widget.carro.tipo, fontSize: 16),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: color,
                size: 40,
              ),
              onPressed: _onClickFavorito,
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                size: 40,
              ),
              onPressed: _onClickShare,
            )
          ],
        )
      ],
    );
  }

  void _onClickMapa(context) {
    if(carro.latitude != null && carro.longitude != null){
      //launch(carro.urlVideo);
      push(context, MapaPage(carro));
    }else{
      alert(context, "Mapa não encontrado!!");
    }
  }

  void _onClickVideo(context) {
    if(carro.urlVideo != null && carro.urlVideo.isNotEmpty){
      launch(carro.urlVideo);
      //push(context, VideoPage(carro));
    }else{
      alert(context, "Video não encontrado!!");
    }
  }

  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        push(
            context,
            CarroFormPage(
              carro: carro,
            ));
        print("Editar!!");
        break;
      case "Deletar":
        deletar();
        break;
      case "Share":
        print("Share!!");
        break;
    }
  }

  void _onClickFavorito() async {
    bool fav = await FavoritoService.favoritar(context, carro);

    setState(() {
      color = fav ? Colors.red : Colors.grey;
    });
  }

  void _onClickShare() {}

  _bloco2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        text(widget.carro.descricao, fontSize: 16, bold: true),
        SizedBox(
          width: 20,
        ),
        StreamBuilder<String>(
          stream: _loripsumApiBloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return text(snapshot.data, fontSize: 16);
          },
        )
      ],
    );
  }

  void deletar() async {
    ApiResponse<bool> response = await CarrosApi.delete(carro);

    if (response.ok) {
      alert(context, "Carro deletado com sucesso", callback: (){
        EventBus.get(context).sendEvent(CarroEvent("carro_deletado", carro.tipo));
        Navigator.pop(context);
      });
    } else {
      alert(context, response.msg);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loripsumApiBloc.dispose();
  }
}
