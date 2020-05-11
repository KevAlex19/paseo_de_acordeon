import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paseo_de_acordeon/models/users.dart' as user;

class UserController extends ControllerMVC {
  int number = 0;

  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseAuth auth = FirebaseAuth.instance;

  UserController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<String> signUp(String emailC, String passC, String confPassC) async {
    String result;
    if (passC != confPassC) {
      result = 1.toString();
    } else {
      try {
        await auth.createUserWithEmailAndPassword(
          email: emailC,
          password: passC,
        );

        result = 2.toString();
      } catch (e) {
        result = e.toString().substring(69);
      }
    }
    return result;
  }

  Future<String> login(String emailC, String passC) async {
    String result;
    try {
      await auth.signInWithEmailAndPassword(
        email: emailC,
        password: passC,
      );

      result = 2.toString();
    } catch (e) {
      result = e.toString().substring(69);
    }

    return result;
  }

  void incrementCounter() {
    setState(() {
      number = number += 1;
    });
  }

  void decrementCounter() {
    if (number == 0) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Number cant go below zero"),
      ));
    } else {
      setState(() {
        number = number--;
      });
    }
  }
}
