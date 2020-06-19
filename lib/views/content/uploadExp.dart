import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:paseo_de_acordeon/controllers/pushNotification.dart';

class UploadXP extends StatefulWidget {
  final String _type;
  UploadXP(this._type);
  //UploadXP({Key key}) : super(key: key);

  @override
  _UploadXPState createState() => _UploadXPState();
}

class _UploadXPState extends State<UploadXP> {
  File sampleImage;
  final key = GlobalKey<FormState>();
  String _value;
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: sampleImage == null
                  ? Text("Seleccione una imagen")
                  : Expanded(child: enableUpload()),
            ),
            Container(),
            Container(
              child: sampleImage == null
                  ? RaisedButton.icon(
                      color: Colors.blueAccent,
                      label: Text(
                        'Seleccionar',
                      ),
                      onPressed: getImage,
                      icon: Icon(Icons.file_upload),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  Widget enableUpload() {
    return Container(
      child: Form(
        key: key,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Descripción"),
              validator: (value) {
                return value.isEmpty
                    ? "Por favor agregue una descripción"
                    : null;
              },
              onSaved: (value) {
                return _value = value;
              },
            ),
            SizedBox(
              height: 5,
            ),
            Image.file(
              sampleImage,
              height: 300,
              width: 600,
            ),
            RaisedButton(
              onPressed: ()=> showAlertDialog(context),
              color: Colors.blueAccent,
              child: Text('Añadir post'),
            )
          ],
        ),
      ),
    );
  }

  void uploadPost() async {
    if (validateAndSave()) {
      final StorageReference newpost =
          FirebaseStorage.instance.ref().child("Post Exp");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask =
          newpost.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
      print('url: ' + url);

      saveToDatabase(url);

      Navigator.pop(context);
    } else {}
  }

  void saveToDatabase(String url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      'image': url,
      'description': _value,
      'date': date,
      'time': time,
      'type': this.widget._type
    };

    ref.child("Posts").push().set(data);
  }

  bool validateAndSave() {
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  showAlertDialog(BuildContext context) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Subiendo experiencia"),
        content: Text("Desea publicar su historia?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Continuar"),
            onPressed: (){uploadPost();Navigator.pop(context);}
          ),
          FlatButton(
            child: Text("Cancelar"),
            onPressed: (){ Navigator.pop(context);},
          )
        ],
      );
    },
  );
}
}


