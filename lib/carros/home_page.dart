import 'package:carros/carros/carro_form_page.dart';
import 'package:carros/carros/carros_api.dart';
import 'package:carros/carros/carros_page.dart';
import 'package:carros/drawer_list.dart';
import 'package:carros/favoritos/favoritos_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _initTabs();
  }

  _initTabs() async{
    _tabController = TabController(length: 4, vsync: this);

    _tabController.index = await Prefs.getInt("tabIdx");

    _tabController.addListener((){
      print("Tab ${_tabController.index}");

      Prefs.setInt("tabIdx", _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Clássicos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Esportivos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Luxo",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Favoritos",
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CarrosPage(TipoCarro.classicos),
          CarrosPage(TipoCarro.esportivos),
          CarrosPage(TipoCarro.luxo),
          FavoritosPage(),
        ],
      ),
      drawer: DrawerList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onCLickaAdicionarCarro,
      ),
    );
  }

  void onCLickaAdicionarCarro() {
    push(context, CarroFormPage());
  }
}
