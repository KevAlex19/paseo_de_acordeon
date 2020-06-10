import 'package:flutter/material.dart';
import 'package:paseo_de_acordeon/controllers/LoginController.dart' as loginC;
import 'package:paseo_de_acordeon/views/LoginLayaout.dart' as loginV;
import 'package:paseo_de_acordeon/views/Login.dart' as loginV;
import 'package:paseo_de_acordeon/views/content/maps.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: PreferredSize(
              child: AppBar(
                backgroundColor: Colors.blue,
                brightness: Brightness.light,
              ),
              preferredSize: Size.fromHeight(0.1)),
          body: loginV.MyApp()),
    ),
  );
}
