import 'package:flutter/material.dart';
import 'package:paseo_de_acordeon/controllers/LoginController.dart' as loginC;
import 'package:paseo_de_acordeon/views/LoginLayaout.dart' as loginV;
import 'package:paseo_de_acordeon/views/Login.dart' as loginV;

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loginV.MyApp(),
    )
    );
}