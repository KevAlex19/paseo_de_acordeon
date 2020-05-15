import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class UploadXP extends StatefulWidget {
  UploadXP({Key key}) : super(key: key);

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
      appBar: AppBar(),
      body: Center(
        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
      ),
      bottomSheet: Align(
        heightFactor: 1,
        alignment: Alignment.bottomCenter,
              child: RaisedButton.icon(
          color: Colors.blueAccent,
          label: Text(
            'Upload',
          ),
          onPressed: getImage,
          icon: Icon(Icons.file_upload),
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
            Image.file(
              sampleImage,
              height: 300,
              width: 600,
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Description"),
              validator: (value) {
                return value.isEmpty ? "Description is requiered" : null;
              },
              onSaved: (value) {
                return _value = value;
              },
            ),
            SizedBox(height: 15,),
            RaisedButton(onPressed: uploadPost,
            color: Colors.blueAccent,
            child: Text('Add a new Post'),
            )
          ],
        ),
      ),
    );
  }

  void uploadPost()async{
    if (validateAndSave()) {
      final StorageReference newpost = FirebaseStorage.instance.ref().child("Post Exp");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask = newpost.child(timeKey.toString()+".jpg").putFile(sampleImage);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
      print('url: '+url);

      saveToDatabase(url);

      Navigator.pop(context);
    } else {
    }
  }

  void saveToDatabase(String url){
    var dbTimeKey = DateTime.now();
    var formatDate= DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      'image': url,
      'description': _value,
      'date': date,
      'time': time
    };

    ref.child("Posts").push().set(data);
  }

  bool validateAndSave(){
    final form = key.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }
}
