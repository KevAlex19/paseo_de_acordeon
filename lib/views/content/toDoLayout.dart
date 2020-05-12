import 'package:paseo_de_acordeon/components/constans.dart';
import 'package:paseo_de_acordeon/controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

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

class MySuperHero {
  final String img;
  final String title;
  final String body;

  MySuperHero(this.img, this.title, this.body);
}

class _MyHomePageState extends StateMVC<MyHomePage> {
  MainController _con;
  List<MySuperHero> items = new List<MySuperHero>();

  _MyHomePageState() : super(MainController()) {
    _con = controller;
    items.add(new MySuperHero("assets/aves.jpg", "  Avistamiento de aves",
        "Genius. Billionaire. Playboy. Philanthropist. Tony Stark's confidence is only matched by his high-flying abilities as the hero called Iron Man."));
    items.add(new MySuperHero("assets/rio.jpg", "  Bañarse en el río",
        "Recipient of the Super-Soldier serum, World War II hero Steve Rogers fights for American ideals as one of the world’s mightiest heroes and the leader of the Avengers."));
    items.add(new MySuperHero("assets/aves.jpg", "  Caminatas",
        "The son of Odin uses his mighty abilities as the God of Thunder to protect his home Asgard and planet Earth alike."));
    items.add(new MySuperHero("assets/aves.jpg", "  Parapente",
        "Dr. Bruce Banner lives a life caught between the soft-spoken scientist he’s always been and the uncontrollable green monster powered by his rage."));
    items.add(new MySuperHero("assets/aves.jpg", "  Ciclco montañismo",
        "Despite super spy Natasha Romanoff’s checkered past, she’s become one of S.H.I.E.L.D.’s most deadly assassins and a frequent member of the Avengers."));
  }

  Widget SuperHeroCell(BuildContext ctx, int index) {
    MySuperHero superHero = items[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            ctx, MaterialPageRoute(builder: (ctx) => MyDetailPage(superHero)));
      },
      child: Card(
        color: Colors.black.withAlpha(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.all(18),
        child: Container(
          padding: EdgeInsets.all(18),
          child: Row(
            children: <Widget>[
              Hero(
                tag: superHero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    superHero.img,
                    height: 70,
                    width: 70,
                  ),
                ),
              ),
              Text(
                superHero.title,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
              Expanded(child: SizedBox()),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Icon(
                    Icons.thumb_up,
                    color: Colors.blueAccent,
                  ),
                  Text('20',style: kLabelStyle,)
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
    return Scaffold(
      backgroundColor: Colors.blue.withAlpha(100),
      appBar: AppBar(
        backgroundColor: Colors.blue.withAlpha(100),
        title: Text(
          'What to do?',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => SuperHeroCell(context, index),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
