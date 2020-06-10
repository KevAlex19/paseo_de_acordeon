import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:paseo_de_acordeon/components/constans.dart';
import 'package:paseo_de_acordeon/controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:paseo_de_acordeon/models/event.dart';
import 'package:paseo_de_acordeon/views/content/detail.dart';

class ToDoView extends StatefulWidget {
  //ToDoView({Key key, this.title}) : super(key: key);
  final String base, title, filter, user;
  ToDoView(this.base, this.title, this.filter,this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends StateMVC<ToDoView> {
  MainController _con;
  List<TasktoDo> items = [];
  Map<String, List<dynamic>> likes = new Map<String, List<dynamic>>();

  @override
  void initState() {
    super.initState();
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child(widget.base);
    postRef.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      items.clear();
      print('object');
      for (var individualKey in keys) {

        TasktoDo event = TasktoDo(
            data[individualKey]['image'],
            data[individualKey]['title'],
            data[individualKey]['body'],
            data[individualKey]['date'],
            data[individualKey]['type'],
            data[individualKey]['latitude'],
            data[individualKey]['longitude'],
            data[individualKey]['like']);
        if (widget.filter == "all") {
          items.add(event);
        } else {
          if (event.type == widget.filter) {
            items.add(event);
          }
        }
        print('2');
      }
      setState(() {
        print('largo: $items.length');
      });
    });
  }

  _MyHomePageState() : super(MainController()) {
    _con = controller;
  }

  Widget TaskCell(BuildContext ctx, int index) {
    TasktoDo tasktoDo = items[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            ctx, MaterialPageRoute(builder: (ctx) => MyDetailPage(tasktoDo,widget.user,"")));
      },
      child: Card(
        color: Colors.black.withAlpha(1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.all(14),
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
                      child: Image.network(
                        tasktoDo.image,
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
                  Text(tasktoDo.body.substring(0, 26) + "..."),
                  Icon(
                    Icons.thumb_up,
                    color: Colors.blueAccent,
                  ),
                  Text(
                    tasktoDo.like.toString(),
                    style: kLabelStyle,
                  ),
                  Expanded(child: SizedBox()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardTemplate2(BuildContext ctx, int index) {
    TasktoDo tasktoDo = items[index];
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: Hero(
        tag: tasktoDo,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            tasktoDo.image,
            height: 92,
            width: 92,
          ),
        ),
      ),
    );

    final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 12.0,
        fontWeight: FontWeight.w400);
    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 14.0);
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.blue, fontSize: 18.0, fontWeight: FontWeight.w600);

    Widget _planetValue({String value, IconData ico, Color color}) {
      return new Row(children: <Widget>[
        new Icon(
          ico,
          size: 19.0,
          color: color,
        ),
        new Container(width: 8.0),
        new Text(value, style: regularTextStyle),
      ]);
    }

    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(tasktoDo.title, style: headerTextStyle),
          new Container(height: 10.0),
          new Text(tasktoDo.body.substring(0, 26) + "...",
              style: subHeaderTextStyle),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: Colors.blueGrey),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: _planetValue(
                      value: tasktoDo.like.toString(),
                      ico: Icons.thumb_up,
                      color: Colors.blue))
            ],
          ),
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      height: 124.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return new GestureDetector(
        child: Container(
          height: 120.0,
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard,
              planetThumbnail,
            ],
          ),
        ),
        onTap: () {
          print(likes);
          print('object');
          Navigator.push(
              ctx, MaterialPageRoute(builder: (ctx) => MyDetailPage(tasktoDo,widget.user,widget.base)));
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tasks =
        List.generate(items.length, (index) => cardTemplate2(context, index));

    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.blue,
            brightness: Brightness.light,
          ),
          preferredSize: Size.fromHeight(0.1)),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              expandedHeight: 80,
              backgroundColor: Colors.blue.withAlpha(200),
              flexibleSpace: Center(
                child: Text(
                  widget.title,
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
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
