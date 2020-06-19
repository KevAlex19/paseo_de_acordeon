import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Gallery extends StatefulWidget {
  final String title;

  Gallery(this.title);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Gallery> {
  List<String> images = [];
  Map<String, List<dynamic>> galleryURLs = new Map<String, List<dynamic>>();
  bool clockWait=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (!clockWait) {
      Future.delayed(Duration(seconds: 10)).whenComplete((){
        setState(() {
          clockWait=true;
        });
      });
    }

    Firestore.instance
          .collection("likes")
          .document(widget.title)
          .get()
          .then((value) {
        if (value.data != null) {
          setState(() {
            images = galleryURLs
              .putIfAbsent(widget.title, () => value.data["gallery"])
              .cast<String>();
          });
        }
      });
  }



  int currentIndex = 0;

  void _next() {
    setState(() {
      if (currentIndex < images.length -1) {
        currentIndex++;
      } else {
        currentIndex = currentIndex;
      }
    });
  }

  void _preve() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.blue,),
        preferredSize: Size.fromHeight(0.9)
        ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details) {
                if (details.velocity.pixelsPerSecond.dx > 0) {
                  _preve();
                } else if (details.velocity.pixelsPerSecond.dx < 0) {
                  _next();
                }
              },
              child: Container(
                width: double.infinity,
                height: 550,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: images.length == 0? (clockWait? AssetImage("assets/no_found.png") : AssetImage("assets/loading.gif")) : NetworkImage(images[currentIndex]),
                    fit: BoxFit.none
                  )
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.grey[700].withOpacity(.9),
                        Colors.grey.withOpacity(.0),
                      ]
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 90,
                        margin: EdgeInsets.only(bottom: 60),
                        child: Row(
                          children: _buildIndicator(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> Viewer(images))),
            ),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -50),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.title, style: TextStyle(color: Colors.grey[800], fontSize: 30, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return Expanded(
      child: Container(
        height: 4,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isActive ? Colors.grey[800] : Colors.white
        ),
      ),
    );
  }


  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for(int i = 0; i < images.length; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}

class Viewer extends StatefulWidget {
  final List<String> img;
  List<PhotoViewGalleryPageOptions> pageOptions = [];
  Viewer(this.img);
  //Viewer({Key key}) : super(key: key);

  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.img[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
        );
      }, itemCount: widget.img.length,
  ),
    );
  }
}