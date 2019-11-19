import 'package:carros/carros/home_page.dart';
import 'package:carros/utils/db_helper.dart';
import 'package:carros/login/login_pages.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

import 'usuario.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future futureA = DatabaseHelper.getInstance().db;

    Future futureB = Future.delayed(Duration(seconds: 3));

    Future<Usuario> futureC = Usuario.get();

    Future.wait([futureA, futureB, futureC]).then((List values){

      Usuario user = values[2];

      if(user != null) {
        push(context, HomePage(), replace: true);
      }else{
        push(context, LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
