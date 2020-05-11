import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class User {
  int _id;
  String _email;
  String _password;
  User(this._email, this._password);

  User.map(dynamic obj) {
    this._email = obj['email'];
    this._password = obj['password'];
  }

  int get id => _id;
  String get email => _email;
  String get password => _password;
  
  User.fromSnapshot(DataSnapshot snapshot){
    _id = int.parse(snapshot.key);
    _email = snapshot.value['email'];
    _password = snapshot.value['password'];
  }
}