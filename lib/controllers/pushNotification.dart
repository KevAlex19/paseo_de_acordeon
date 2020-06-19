import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:paseo_de_acordeon/views/LoginLayaout.dart';



class MyAppN extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppN> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
      
      _reciveNotify();
  }

  _reciveNotify(){
    _firebaseMessaging.getToken().then((value) => print(value));

    _firebaseMessaging.configure(
      onMessage: (value) async {
        print('================Message============');
        //print(value);
        showNotification("Actualizacion de eventos",value['data']['place'],"al darle click XD");
      },
      onLaunch: (value) async {
        print('================Launch============');
        print(value);
      },
      onResume: (value) async {
        print('================Resume============');
        print(value);
      }
    );
  }



  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload "+ MyHomePageLogin().createState().emailUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Local Notification'),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: ()=> showNotification("prueba title","body sassssssssssssssssssssssssssssssssssssssss","no se pa que"),
          child: new Text(
            'Demo',
            style: Theme.of(context).textTheme.headline,
          ),
        ),
      ),
    );
  }

  showNotification(String title, String body, String payload) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platform,
        payload: payload);
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => null));
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