import 'package:flutter/material.dart';
import 'package:paseo_de_acordeon/controllers/LoginController.dart' as loginC;
import 'package:paseo_de_acordeon/views/LoginLayaout.dart';
import 'package:paseo_de_acordeon/views/Login.dart';
import 'package:paseo_de_acordeon/views/content/maps.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home:  MyAppLogin(),
    ),
  );
}
