import 'package:paseo_de_acordeon/controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MyHomePage();
  }
  //E7:16:A3:31:C5:4F:06:2B:9C:D5:59:7D:A9:C3:80:C8:A7:25:53:16
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends StateMVC<MyHomePage> {
  MainController _con;
  _MyHomePageState():super(MainController()){
    _con=controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.count(
        crossAxisCount:2,
        children: <Widget>[
          FlatButton(
            onPressed: ()=> Function,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      /*Image.file(
                        File('/assets/google.jpg'),
                      )*/
                      Text('proof, haz el menu'),
                    ],
                  )
                ),),
            ))
        ],
        )
    );
  }
}