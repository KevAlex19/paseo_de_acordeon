import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:paseo_de_acordeon/models/experiences.dart';
import 'package:paseo_de_acordeon/views/content/detailGallery.dart';
import 'package:paseo_de_acordeon/views/content/favMenu.dart';
import 'package:paseo_de_acordeon/views/content/gallery.dart';
import 'package:paseo_de_acordeon/views/content/toDoLayout.dart';
import 'package:paseo_de_acordeon/components/constans.dart';
import 'package:paseo_de_acordeon/views/content/touristSiteLayout.dart';
import 'package:paseo_de_acordeon/views/experiencesLayout.dart';

import '../LoginLayaout.dart';

class Menu extends StatefulWidget {
  final String user;
  Menu(this.user);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends StateMVC<Menu> {
  List<Widget> items = [];
  ScrollController scrollController;
  final double expandedHight = 100.0;

  void routePage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget cardTemplate2(Text txtH, Text txtD, Widget fun, IconData ico) {
    final planetThumbnail = new Container(
        margin: new EdgeInsets.symmetric(vertical: 16.0),
        alignment: FractionalOffset.centerLeft,
        child: Icon(
          ico,
          size: 92,
          color: Colors.blue,
        ));

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
          new Text(txtH.data, style: headerTextStyle),
          new Container(height: 10.0),
          new Text(txtD.data, style: subHeaderTextStyle),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: Colors.blueGrey),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: Container()),
              
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
      onTap: () => routePage(fun),
    );
  }

  Widget cardTemplate(Text txtH, Text txtD, Widget fun, IconData ico) {
    return Card(
      color: Colors.black.withAlpha(50),
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
                color: Colors.blue,
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

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));

    items.add(cardTemplate2(
        Text(
          '¿Qué hacer?',
          style: kCLabelStyle,
        ),
        Text(
          'Eventos: 2',
          style: kLabelStyle,
        ),
        ToDoView("EventsPlaces", "¿Qué hacer?", "all", widget.user),
        Icons.directions_run));
    items.add(cardTemplate2(
        Text(
          'Sitios turísticos',
          style: kCLabelStyle,
        ),
        Text(
          'Lugares: 1',
          style: kLabelStyle,
        ),
        ToDoView("EventsPlaces", "Sitios turísticos", "place", widget.user),
        Icons.explore));
    items.add(cardTemplate2(
        Text(
          'Gallery',
          style: kCLabelStyle,
        ),
        Text(
          '2',
          style: kLabelStyle,
        ),
        GalleryLayaout(),
        Icons.photo_library));
    items.add(cardTemplate2(
        Text(
          'Gastronomía',
          style: kCLabelStyle,
        ),
        Text(
          'Platos: 2',
          style: kLabelStyle,
        ),
        ToDoView("EventsPlaces", '¿Qué hacer?', "all", widget.user),
        Icons.fastfood));
    items.add(cardTemplate2(
        Text(
          'Restaurantes',
          style: kCLabelStyle,
        ),
        Text(
          '1',
          style: kLabelStyle,
        ),
        ToDoView("Services", "Restaurant", "restaurant", widget.user),
        Icons.restaurant));
    items.add(cardTemplate2(
        Text(
          'Hospedaje',
          style: kCLabelStyle,
        ),
        Text(
          'Lugares: 2',
          style: kLabelStyle,
        ),
        ToDoView("EventsPlaces", '¿Qué hacer?', "all", widget.user),
        Icons.hotel));
    items.add(cardTemplate2(
        Text(
          'Transporte',
          style: kCLabelStyle,
        ),
        Text(
          'Lugares: 17',
          style: kLabelStyle,
        ),
        ToDoView("EventsPlaces", '¿Qué hacer?', "all", widget.user),
        Icons.directions_bus));

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  //List<Widget> menus = List.generate(1, (index) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.blue,
          ),
          preferredSize: Size.fromHeight(0.1)),
      backgroundColor: Colors.grey[100],
      drawer: SafeArea(
        child: Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(children: <Widget>[
                    Align(
                      child: Text(widget.user),
                      alignment: Alignment.bottomLeft,
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            )))
                  ]),
                  height: 120,
                  color: Colors.blue,
                ),
                FlatButton.icon(
                  color: Colors.white,
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    label: Expanded(child: Text("   Favoritos")),
                    onPressed: ()=> widget.user == ""? showDialogExit(context, "Si", "No", "Accion denegada", "Para continnuar debe iniciar sesion") : {Navigator.pop(context), Navigator.push(context, MaterialPageRoute(builder: (context) => FavView("EventsPlaces", "Favoritos", "all", widget.user)))}),
                FlatButton.icon(
                  color: Colors.white,
                    icon: Icon(
                      Icons.settings,
                      color: Colors.blue,
                    ),
                    label: Expanded(child: Text("   Configuracion")),
                    onPressed: () => print('object')),
                Expanded(child: Container()),
                FlatButton.icon(
                  color: Colors.white,
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                    label: Expanded(child: Text("   Salir")),
                    onPressed: ()=> showDialogExit(context, "Si", "No", "Saliendo", "¿Desea salir de la sesión?"),)
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.blue.withAlpha(200),
            expandedHeight: 100,
            flexibleSpace: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
          SliverSafeArea(
              sliver: SliverList(delegate: SliverChildListDelegate(items)))
        ]),
      ),
    );
  }
}

showDialogExit(BuildContext context, String resp1, String resp2, String head, String body) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text(resp1),
    onPressed: () {Navigator.pop(context); Navigator.pop(context); Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp())); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    elevation: 24,
    title: Text(head),
    content: Text(body),
    actions: [
      FlatButton(onPressed: () { Navigator.pop(context); },
      child: Text(resp2),),
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