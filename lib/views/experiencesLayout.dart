import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paseo_de_acordeon/models/experiences.dart';
import 'package:paseo_de_acordeon/models/toDo.dart';
import 'package:paseo_de_acordeon/views/content/uploadExp.dart';
import 'package:paseo_de_acordeon/views/content/toDoLayout.dart';

class ExperienceLayaout extends StatefulWidget {
  TasktoDo _superHero;

  MyDetailPage(TasktoDo _tasktoDo) {
    _superHero = _tasktoDo;
  }

  @override
  _MyDetailPageState createState() => _MyDetailPageState(_superHero);
}

class _MyDetailPageState extends State<ExperienceLayaout> {
  TasktoDo _tasktoDo;
  List<Experince> xpList = [];

  _MyDetailPageState(TasktoDo _tasktoDo) {
    this._tasktoDo = _tasktoDo;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postRef.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      xpList.clear();

      for (var individualKey in keys) {
        Experince exp = Experince(
            data[individualKey]['image'],
            data[individualKey]['description'],
            data[individualKey]['date'],
            data[individualKey]['time']);
        xpList.add(exp);
      }
      setState(() {
        print('largo: $xpList.length');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> empty = List.generate(
        1,
        (index) => Card(
              elevation: 10,
              margin: EdgeInsets.all(14),
              child: Text('No experiences Avaliables'),
            ));
    final List<Widget> items = List.generate(
      xpList.length,
      (index) => cardXP(xpList[index].image, xpList[index].description,
          xpList[index].date, xpList[index].time),
    );

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.blue.withAlpha(200),
          floating: true,
          expandedHeight: 150,
          flexibleSpace: Center(
                    child: Text(
                    'Experiencias',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                ),
                  ),
        ),
        SliverList(
            delegate: xpList.length == 0
                ? SliverChildListDelegate(empty)
                : SliverChildListDelegate(items)),
      ]
          /*
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[],
              
              
            ],
          ),
        ),*/
          ),
      
    );
  }

  Widget cardXP(String image, String description, String date, String time) {
    return Card(
      elevation: 10,
      color: Colors.black.withAlpha(1),
      margin: EdgeInsets.all(14),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Image.network(
              image,
              fit: BoxFit.cover,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
