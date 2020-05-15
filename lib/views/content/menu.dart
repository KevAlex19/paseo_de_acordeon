import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:paseo_de_acordeon/models/experiences.dart';
import 'package:paseo_de_acordeon/views/content/toDoLayout.dart';
import 'package:paseo_de_acordeon/components/constans.dart';
import 'package:paseo_de_acordeon/views/content/touristSiteLayout.dart';
import 'package:paseo_de_acordeon/views/experiencesLayout.dart';

class Menu extends StatelessWidget {
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
  String xpSelect= 'nada';
  ScrollController scrollController;
  final double expandedHight = 100.0;

   void routePage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
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
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  double get top {
    double res = expandedHight;
    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      if (offset < (res - kToolbarHeight)) {
        res -= offset;
      } else {
        res = kToolbarHeight;
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
       backgroundColor: Colors.white,
       body: Stack(
        children: [
          NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.blue.withAlpha(200),
                  expandedHeight: expandedHight,
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
              ];
            },
            body: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              cardTemplate(
                  Text(
                    '¿Qué hacer?',
                    style: kCLabelStyle,
                  ),
                  Text(
                    'Eventos: 5',
                    style: kLabelStyle,
                  ),
                  ToDoView(),Icons.directions_run),
              cardTemplate(Text('Sitios turístico',style: kCLabelStyle,), Text('Lugares: 14',style: kLabelStyle,), SitesView(),Icons.explore),
              cardTemplate(Text('Experiencias',style: kCLabelStyle,), Text('392',style: kLabelStyle,), ExperienceLayaout() ,Icons.eject),
              cardTemplate(Text('Gastronomía',style: kCLabelStyle,), Text('Platos: 42',style: kLabelStyle,), ToDoView(),Icons.fastfood),
              cardTemplate(Text('Galeria de fotos',style: kCLabelStyle,), Text('Collecciones: 19',style: kLabelStyle,), ToDoView(),Icons.photo_album),
              cardTemplate(Text('Restaurantes',style: kCLabelStyle,), Text('42',style: kLabelStyle,), ToDoView(),Icons.restaurant),
              cardTemplate(Text('Hospedaje',style: kCLabelStyle,), Text('Lugares: 26',style: kLabelStyle,), ToDoView(),Icons.restaurant),
              cardTemplate(Text('Transporte',style: kCLabelStyle,), Text('Lugares: 17',style: kLabelStyle,), ToDoView(),Icons.directions_bus),
            ],
          ),
          ),
        ],
      ),
    );
  }
}