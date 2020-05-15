import 'package:paseo_de_acordeon/components/constans.dart';
import 'package:paseo_de_acordeon/controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:paseo_de_acordeon/models/toDo.dart';

import 'package:paseo_de_acordeon/views/content/detail.dart';

class ToDoView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends StateMVC<MyHomePage> {
  MainController _con;
  List<TasktoDo> items = new List<TasktoDo>();

  _MyHomePageState() : super(MainController()) {
    _con = controller;
    items.add(new TasktoDo("assets/festival.jpg", "  Festival Vallenato",
        "Es el evento mas importante del Vallenato."));
    items.add(new TasktoDo("assets/aves.jpg", "  Avistamiento de aves",
        "La capital del Cesar se suma al Global Big Day."));
    items.add(new TasktoDo("assets/quinta.jpg", "  Festival de la 5ta",
        " En el centro histórico de Valledupar."));
    items.add(new TasktoDo("assets/parapente.jpg", "  Parapente Manaure, Cesar",
        "¡Olvídate de tus miedos volando en Parapente!."));
  }

  Widget TaskCell(BuildContext ctx, int index) {
    TasktoDo tasktoDo = items[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            ctx, MaterialPageRoute(builder: (ctx) => MyDetailPage(tasktoDo)));
      },
      child: Card(
        color: Colors.black.withAlpha(1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.all(18),
        child: Container(
          padding: EdgeInsets.all(18),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: tasktoDo,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        tasktoDo.img,
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),

                  Text(
                    tasktoDo.title,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
              Text(tasktoDo.body.substring(0,26)+"..."),
                  Expanded(
                    child:SizedBox() 
                  ),
                  Icon(
                      Icons.thumb_up,
                      color: Colors.blueAccent,
                    ),
                  Text(
                    '20',
                    style: kLabelStyle,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tasks =
        List.generate(items.length, (index) => TaskCell(context, index));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            expandedHeight: 80,
            backgroundColor: Colors.blue.withAlpha(200),
            flexibleSpace: Center(
              child: Text(
                '¿Qué hacer?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(tasks))
        ],
        /* child: Center(
          child: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => TaskCell(context, index),
              ),
            ],

          ),
        ),*/
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
