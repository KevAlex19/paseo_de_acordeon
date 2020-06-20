import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paseo_de_acordeon/views/content/detailGallery.dart';
import 'package:progress_indicators/progress_indicators.dart';

class GalleryLayaout extends StatefulWidget {
  GalleryLayaout();
  @override
  _MyDetailPageState createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<GalleryLayaout> {
  List<String> images = [], collections = [];
  Map<String, List<dynamic>> galleryURLs = new Map<String, List<dynamic>>();
  Map<String, List<String>> gallery = new Map<String, List<String>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firestore.instance.collection("likes").getDocuments().then((value) {
      for (var item in value.documents) {
        collections.add(item.documentID);

        Firestore.instance
            .collection("likes")
            .document(item.documentID)
            .get()
            .then((value) {
          if (value.data != null) {
            images = galleryURLs
                .putIfAbsent(item.documentID, () => value.data["gallery"])
                .cast<String>();
            setState(() {
              gallery.putIfAbsent(item.documentID, () => images);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wait = List.generate(
        6,
        (index) => GlowingProgressIndicator(
                child: Container(
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.035),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        width: 300,
                        height: 50,
                        child:
                            Center(),
                      ),
                    ),
                  ],
                ),
              )));

    List<Widget> items = List.generate(
        gallery.length,
        (index) => GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Gallery(gallery.keys.toList()[index]))),
              child: Container(
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.035),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            image: DecorationImage(
                                image: NetworkImage(
                                  gallery.entries.elementAt(index).value[1],
                                ),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        width: 300,
                        height: 50,
                        child:
                            Center(child: Text(gallery.keys.toList()[index], textAlign: TextAlign.center ,style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'))),
                      ),
                    ),
                  ],
                ),
              ),
            ));

    // TODO: implement build
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Colors.blue,
            ),
            preferredSize: Size.fromHeight(0.1)),
      backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                expandedHeight: 80,
                backgroundColor: Colors.blue.withAlpha(200),
                flexibleSpace: Center(
                  child: Text(
                    "Galeria",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                ),
              ),
              SliverGrid.count(
                crossAxisCount: 2,
                children: items.isEmpty ? wait : items,
              ),
            ],
          ),
        ));
  }
}
