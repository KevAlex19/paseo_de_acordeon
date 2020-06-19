import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:paseo_de_acordeon/components/constans.dart';
import 'package:paseo_de_acordeon/controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:paseo_de_acordeon/models/recipe.dart';
import 'package:paseo_de_acordeon/views/content/recipeDetail.dart';
import 'package:progress_indicators/progress_indicators.dart';

class RecipesView extends StatefulWidget {
  //RecipesView({Key key, this.title}) : super(key: key);
  final String base, title, user;
  RecipesView(this.base, this.title, this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends StateMVC<RecipesView> {
  MainController _con;
  List<Recipe> items = [];
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
        Recipe recipe = Recipe(
            data[individualKey]['image'],
            data[individualKey]['title'],
            data[individualKey]['body'],
            data[individualKey]['sources'],
            data[individualKey]['steps'],
            data[individualKey]['like']);
          items.add(recipe);
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


  Widget cardTemplate2(BuildContext ctx, int index) {
    Recipe recipe = items[index];
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: Hero(
        tag: recipe,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            recipe.image,
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
          new Text(recipe.title, style: headerTextStyle),
          new Container(height: 5.0),
          Expanded(
            child: new Text(recipe.body.substring(0, 30) + "...",
                style: subHeaderTextStyle),
          ),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: Colors.blueGrey),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: _planetValue(
                      value: recipe.like.toString(),
                      ico: Icons.favorite,
                      color: Colors.blue))
            ],
          ),
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      margin: new EdgeInsets.only(left: 36.0),
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
          height: MediaQuery.of(context).size.width*0.34,
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
              ctx,
              MaterialPageRoute(
                  builder: (ctx) =>
                      RecipeDetail(recipe, widget.user, widget.base)));
        });
  }

  

  @override
  Widget build(BuildContext context) {
    List<Widget> recipes =
        List.generate(items.length, (index) => cardTemplate2(context, index));

    List<Widget> wait = List.generate(
        4,
        (index) => GlowingProgressIndicator(
                child: Card(
              elevation: 24,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 70,
                    width: 70,
                    color: Colors.black12,
                    margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.black12,
                        margin: EdgeInsets.only(bottom: 7),
                      ),
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.black12,
                        margin: EdgeInsets.only(bottom: 7),
                      ),
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.black12,
                        margin: EdgeInsets.only(bottom: 7),
                      ),
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.black12,
                        margin: EdgeInsets.only(bottom: 7),
                      ),
                    ],
                  ),
                ],
              ),
            )));

    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.blue,
            brightness: Brightness.light,
          ),
          preferredSize: Size.fromHeight(0.1)),
      backgroundColor: Colors.grey[100],
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
            SliverList(
                delegate:
                    SliverChildListDelegate(recipes.isEmpty ? wait : recipes)),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
