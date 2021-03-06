import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paseo_de_acordeon/models/experiences.dart';
import 'package:paseo_de_acordeon/models/recipe.dart';
import 'package:paseo_de_acordeon/views/content/maps.dart';
import 'package:paseo_de_acordeon/views/content/uploadExp.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../LoginLayaout.dart';
import 'detailGallery.dart';

class RecipeDetail extends StatefulWidget {
  Recipe recipe;
  final String user, base;

  RecipeDetail(this.recipe, this.user, this.base);

  @override
  _MyDetailPageState createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<RecipeDetail> {
  List<Experince> xpList = [];

  bool fav = false, liked = false, clockWait = false;
  Map<String, List<dynamic>> uLikes = new Map<String, List<dynamic>>();
  List<String> likes, favs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
    print(widget.recipe.steps.length);
    print("-------------------------------------------");
    print(widget.recipe.sources.replaceAll('. ', '\n\n').length);

    Firestore.instance
        .collection("likes")
        .document(widget.recipe.title)
        .get()
        .then((value) {
      if (value.data != null) {
        likes = uLikes
            .putIfAbsent(widget.recipe.title, () => value.data["emails"])
            .cast<String>();
        uLikes = Map<String, List<dynamic>>();
      } else {
        setState(() {
          likes = new List<String>();
        });
      }

      for (var i = 0; i < likes.length; i++) {
        if (likes[i] == widget.user) {
          setState(() {
            liked = true;
          });
        }
      }
    });

    Firestore.instance
        .collection("favorites")
        .document("users")
        .get()
        .then((value) {
      if (value.data != null) {
        favs = uLikes
            .putIfAbsent(
                "users", () => value.data[widget.user.replaceAll('.', '^')])
            .cast<String>();
      } else {
        setState(() {
          favs = new List<String>();
        });
      }

      for (var i = 0; i < favs.length; i++) {
        if (favs[i] == widget.recipe.title) {
          setState(() {
            fav = true;
          });
        }
      }
    });

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
            data[individualKey]['time'],
            data[individualKey]['type']);
        if (exp.type == widget.recipe.title) {
          xpList.add(exp);
        }
      }
    });

    if (!clockWait) {
      Future.delayed(Duration(seconds: 10)).whenComplete(() {
        setState(() {
          clockWait = true;
        });
      });
    }
  }

  _pressedLike() {
    DatabaseReference postRef = FirebaseDatabase.instance
        .reference()
        .child(widget.base)
        .child(widget.recipe.title);

    if (widget.user == "") {
      showAlertDialog(context);
    } else {
      if (!liked) {
        Firestore.instance
            .collection("likes")
            .document(widget.recipe.title)
            .updateData({
          'emails': FieldValue.arrayUnion([widget.user]),
        });

        setState(() {
          widget.recipe.like++;
        });
      } else {
        Firestore.instance
            .collection("likes")
            .document(widget.recipe.title)
            .updateData({
          'emails': FieldValue.arrayRemove([widget.user])
        });
        setState(() {
          widget.recipe.like--;
        });
      }
      setState(() {
        liked = !liked;
      });
      postRef.update({'like': widget.recipe.like});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> empty = List.generate(
        1,
        (index) => Card(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: Container(
              margin: EdgeInsets.all(7),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    widget.recipe.title,
                    style: TextStyle(fontSize: 25, color: Colors.blue),
                  ),
                  Text(
                    widget.recipe.body,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            )));
    final List<Widget> xp = List.generate(
        1,
        (index) => Card(
              shape: BeveledRectangleBorder(),
              color: Colors.blue,
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                child: Text(
                  'Experiencias',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ));
    final List<Widget> noXP = List.generate(
        1,
        (index) => Card(
              shape: BeveledRectangleBorder(),
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                child: Text(
                  'Actualmente no hay experiencias',
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                ),
              ),
            ));
    final List<Widget> map = List.generate(
        1,
        (index) => Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                              onTap: () => _pressedLike(),
                              child: Icon(
                                liked ? Icons.favorite : Icons.favorite_border,
                                color: Colors.blue,
                              )),
                          Text("\n" + widget.recipe.like.toString()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            child: Stack(children: <Widget>[
                              Icon(
                                fav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.red,
                              )
                            ]),
                            onTap: () => _pressFav(),
                          ),
                          Text('\nFavoritos')
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15,),
                Container(
                  height: 2,
                  //width: MediaQuery.of(context).size.width*0.7,
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  color: Colors.blue,
                ),
              ],
            ));
    final List<Widget> items = List.generate(
      xpList.length,
      (index) => cardXP(xpList[index].image, xpList[index].description,
          xpList[index].date, xpList[index].time, ""),
    );

    List<Widget> wait = List.generate(
        4,
        (index) => GlowingProgressIndicator(
                child: Card(
              elevation: 24,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width * 0.4,
                    width: 270,
                    color: Colors.black12,
                    margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
                  ),
                  Container(
                    height: 10,
                    width: 280,
                    color: Colors.black12,
                    margin: EdgeInsets.only(bottom: 7),
                  ),
                  Container(
                    height: 10,
                    width: 290,
                    color: Colors.black12,
                    margin: EdgeInsets.only(bottom: 7),
                  ),
                ],
              ),
            )));

    final List<Widget> details = List.generate(
        1,
        (index) => Container(
              height: ((widget.recipe.sources.split('.').length*40)+80.0),
              child: PageView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(14),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text("Recursos\n", style: TextStyle(fontSize: 25, color: Colors.blue))),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text("instrucciones>"),
                            )
                          ],
                        ),
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(widget.recipe.sources.replaceAll('.', '\n\n'), textAlign: TextAlign.left,)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(14),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text("Instrucciones\n", style: TextStyle(fontSize: 25, color: Colors.blue))),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("<recursos"),
                            )
                          ],
                        ),
                        Text(widget.recipe.steps.replaceAll('. ', '\n\n'),),
                      ],
                    ),
                  ),
                ],
                onPageChanged: (index)=> print(index.toString()),
              ),
            ));

    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.blue,
          ),
          preferredSize: Size.fromHeight(0.1)),
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            floating: true,
            expandedHeight: 150,
            flexibleSpace: Hero(
              transitionOnUserGestures: true,
              tag: widget.recipe,
              child: Transform.scale(
                scale: 1.0,
                child: Image.network(
                  widget.recipe.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: xpList.length == 0
                  ? SliverChildListDelegate(
                      empty + map + details + xp + (clockWait ? noXP : wait))
                  : SliverChildListDelegate(
                      empty + map + details + xp + items)),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.user == ""
            ? showAlertDialog(context)
            : Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UploadXP(widget.recipe.title);
              })),
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  void buildSetStateFav() {
    return setState(() {
      fav = !fav;
    });
  }

  Widget cardXP(
      String image, String description, String date, String time, String type) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(14, 0, 14, 14),
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
                ),
                Text(
                  type,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }

  _pressFav() {
    if (widget.user == "") {
      showAlertDialog(context);
    } else {
      if (!fav) {
        Firestore.instance
            .collection("favorites")
            .document("users")
            .updateData({
          widget.user.replaceAll('.', '^'):
              FieldValue.arrayUnion([widget.recipe.title]),
        });
      } else {
        Firestore.instance
            .collection("favorites")
            .document("users")
            .updateData({
          widget.user.replaceAll('.', '^'):
              FieldValue.arrayRemove([widget.recipe.title]),
        });
      }
      setState(() {
        fav = !fav;
      });
    }
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyAppLogin()));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    elevation: 24,
    title: Text("Accion denegada"),
    content: Text("Para continuar inicie sesión o registrese"),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancelar"),
      ),
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
