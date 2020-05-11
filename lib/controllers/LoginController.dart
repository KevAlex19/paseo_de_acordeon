import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainController extends ControllerMVC {
  int number = 0;
  GlobalKey<ScaffoldState> scaffoldKey;

  MainController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
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
