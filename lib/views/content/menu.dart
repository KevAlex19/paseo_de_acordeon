import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:paseo_de_acordeon/views/content/toDoLayout.dart';
import 'package:paseo_de_acordeon/components/constans.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Home')),
          backgroundColor: Colors.blue.withAlpha(100),
        ),
        backgroundColor: Colors.blue.withAlpha(100),
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            cardTemplate(
                Text(
                  'What to Do?',
                  style: kCLabelStyle,
                ),
                Text(
                  'events: 5',
                  style: kLabelStyle,
                ),
                ToDoView(),Icons.directions_run),
            cardTemplate(Text('Tourist Sites',style: kCLabelStyle,), Text('Places: 14',style: kLabelStyle,), ToDoView(),Icons.explore),
            cardTemplate(Text('Experiences',style: kCLabelStyle,), Text('392',style: kLabelStyle,), ToDoView(),Icons.eject),
            cardTemplate(Text('Gastronomy',style: kCLabelStyle,), Text('Dishes: 42',style: kLabelStyle,), ToDoView(),Icons.fastfood),
            cardTemplate(Text('Photo Galery',style: kCLabelStyle,), Text('Collections: 19',style: kLabelStyle,), ToDoView(),Icons.photo_album),
            cardTemplate(Text('Restaurants',style: kCLabelStyle,), Text('42',style: kLabelStyle,), ToDoView(),Icons.restaurant),
            cardTemplate(Text('Hosting',style: kCLabelStyle,), Text('Sites: 26',style: kLabelStyle,), ToDoView(),Icons.restaurant),
            cardTemplate(Text('Transport',style: kCLabelStyle,), Text('Sites: 17',style: kLabelStyle,), ToDoView(),Icons.directions_bus),
          ],
        ));
  }

  void routePage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget cardTemplate(Text txtH, Text txtD, Widget fun, IconData ico) {
    return Card(
      color: Colors.black.withAlpha(80),
      elevation: 5,
      margin: EdgeInsets.all(25),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: FlatButton(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Icon(
                ico,
                size: 70,
                color: Colors.grey,
              ),
              txtH,
              txtD,
            ],
          ),
        ),
        onPressed: () => routePage(fun),
      ),
    );
  }
}
