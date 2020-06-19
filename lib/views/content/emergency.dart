import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final List<String> telefonos=[
    "Policía Nacional;123;assets/escudo_policia.png",
    "Cuerpo de Bomberos;119;assets/bomberos.jpg",
    "Defensa Civil;144;assets/defensaCivil.png",
    "Hospital Rosario Pumarejo de López E.S.E;5748462;assets/HRosario.jpg"
  ];

class Emergency extends StatelessWidget {
  
  List<Widget> items = List.generate(
      telefonos.length,
      (index) => cardTemplate(telefonos[index].split(';').last,telefonos[index].split(';').elementAt(1),telefonos[index].split(';').first));
  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.blue,
            brightness: Brightness.light,
          ),
          preferredSize: Size.fromHeight(0.1)),
      backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.blue.withAlpha(200),
              expandedHeight: 100,
              flexibleSpace: Center(
                child: Text(
                  'Emergencias',
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
Widget cardTemplate(String img,String tel, String autoridad){
       return GestureDetector(
            onTap: () async {
              if (await launch("tel://"+tel)) {
                await launch("tel://"+tel);
              } else {
                throw 'Could not launch $tel';
              }
            },
            child: Card(
              elevation: 24,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: <Widget>[
                  Center(child: Container(margin: EdgeInsets.fromLTRB(10, 10, 10, 10),child: Text(autoridad, style: TextStyle(fontSize: 20, color: Colors.blue),), )),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 70,
                        width: 70,
                        color: Colors.black12,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Image.asset(img, fit: BoxFit.cover,),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 7),
                        child: Text("Tel: "+tel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
      }