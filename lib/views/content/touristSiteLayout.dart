// import 'package:paseo_de_acordeon/components/constans.dart';
// import 'package:paseo_de_acordeon/controllers/LoginController.dart';
// import 'package:flutter/material.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:paseo_de_acordeon/models/event.dart';

// import 'package:paseo_de_acordeon/views/content/detail.dart';

// class SitesView extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MyHomePage();
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends StateMVC<MyHomePage> {
//   MainController _con;
//   List<TasktoDo> items = new List<TasktoDo>();

//   _MyHomePageState() : super(MainController()) {
//     _con = controller;
//     items.add(new TasktoDo("assets/plaza.jpg", "  Plaza Alfonso López Valledupar",
//         "La Plaza Mayor de Valledupar.","date4","event4",10.460642, -73.239397,5));
//     items.add(new TasktoDo("assets/rio.jpg", "  Balneario Rio Guatapurí",
//         "El rio guatapuri nace en la laguna Curigua, en la Sierra Nevada de Santa Marta.","date4","event4",10.460642, -73.239397,5));
//     items.add(new TasktoDo("assets/parque.jpg", "  Parque de la Leyenda",
//         "La leyenda Vallenata Consuelo Araujo Noguera.","date4","event4",10.460642, -73.239397,8));
//     items.add(new TasktoDo("assets/monedas.jpg", "  Monedas gigantes",
//         "Rinden honor a Vallenatos.","date4","event4",10.460642, -73.239397,9));
//   }

//   Widget TaskCell(BuildContext ctx, int index) {
//     TasktoDo tasktoDo = items[index];
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//             ctx, MaterialPageRoute(builder: (ctx) => MyDetailPage(tasktoDo)));
//       },
//       child: Card(
//         semanticContainer: true,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         color: Colors.black.withAlpha(1),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20))),
//         margin: EdgeInsets.all(18),
//         child: Container(
//           padding: EdgeInsets.all(18),
//           child: Column(
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   Hero(
//                     tag: tasktoDo,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Image.asset(
//                         tasktoDo.image,
//                         height: 70,
//                         width: 70,
//                       ),
//                     ),
//                   ),

//                   Text(
//                     tasktoDo.title,
//                     style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'OpenSans'),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: <Widget>[
//               Text(tasktoDo.body.substring(0,26)+"..."),
//                   Expanded(
//                     child:SizedBox() 
//                   ),
//                   Icon(
//                       Icons.thumb_up,
//                       color: Colors.blueAccent,
//                     ),
//                   Text(
//                     '49',
//                     style: kLabelStyle,
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> tasks =
//         List.generate(items.length, (index) => TaskCell(context, index));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             floating: true,
//             expandedHeight: 80,
//             backgroundColor: Colors.blue.withAlpha(200),
//             flexibleSpace: Center(
//               child: Text(
//                 'Sitios turisticos',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'OpenSans'),
//               ),
//             ),
//           ),
//           SliverList(delegate: SliverChildListDelegate(tasks))
//         ],
//         /* child: Center(
//           child: Stack(
//             children: <Widget>[
//               ListView.builder(
//                 itemCount: items.length,
//                 itemBuilder: (context, index) => TaskCell(context, index),
//               ),
//             ],

//           ),
//         ),*/
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
