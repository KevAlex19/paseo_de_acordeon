import 'package:achievement_view/achievement_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:paseo_de_acordeon/components/constans.dart';
import 'package:paseo_de_acordeon/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:achievement_view/achievement_view.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePageRe();
  }
}

//final FirebaseAuth _auth = FirebaseAuth.instance;

class MyHomePageRe extends StatefulWidget {
  MyHomePageRe({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends StateMVC<MyHomePageRe> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passConfController = TextEditingController();

  bool _success;
  String _userEmail;

  UserController _con;
  _MyHomePageState() : super(UserController()) {
    _con = controller;
  }
  Widget _wForm(
      String name, IconData ico, bool p, TextEditingController control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          name,
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: control,
            keyboardType: TextInputType.emailAddress,
            obscureText: p,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                ico,
                color: Colors.white,
              ),
              hintText: 'Enter your ' + name,
              hintStyle: kHintTextStyle,
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
        )
      ],
    );
  }

  Widget _registerBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => _register(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue,
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _backBtn() {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.blue,
          ),
          preferredSize: Size.fromHeight(0.1)),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.9,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                  boxShadow: [BoxShadow(color: Colors.black)],
                  image: DecorationImage(
                    image: AssetImage('assets/glorieta.jpg'),
                    colorFilter:
                        ColorFilter.mode(Colors.black, BlendMode.dstATop),
                    alignment: Alignment.center,
                    centerSlice: Rect.largest,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 50.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _wForm('Email', Icons.email, false, _emailController),
                  SizedBox(
                    height: 30.0,
                  ),
                  _wForm('Password', Icons.lock, true, _passController),
                  SizedBox(
                    height: 30.0,
                  ),
                  _wForm('Confirm password', Icons.lock_outline, true,
                      _passConfController),
                  _registerBtn(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _backBtn(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showAlert(BuildContext context, String tittle, String sub, Widget ico) {
    AchievementView(context,
        icon: ico,
        title: tittle,
        subTitle: sub,
        typeAnimationContent: AnimationTypeAchievement.fadeSlideToLeft,
        isCircle: true,
        duration: Duration(milliseconds: 1000),
        color: Colors.blueGrey.withOpacity(0.5), listener: (status) {
      print(status);
    })
      ..show();
  }

  void _register() {
    if (_formKey.currentState.validate() == true) {
      _con
          .signUp(_emailController.text.trim(), _passController.text.trim(),
              _passConfController.text.trim())
          .then((value) {
        if (value.toString() == 1.toString()) {
          showAlert(
              context,
              "Error!",
              "Please verify the passwords",
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ));
        } else if (value.toString() == 2.toString()) {
          setState(() {
            _success = true;
            _userEmail = _emailController.text;
          });
          showAlert(
              context,
              "Great!",
              "Thanks, Your registration has been successful",
              Icon(
                Icons.done,
                color: Colors.cyanAccent,
              ));
          Navigator.pop(context);
        } else {
          _success = false;
          showAlert(
              context,
              "Error!",
              value.toString() + " [Ivalid email, Please verify...]",
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ));
        }
      });
    } else {
      showAlert(
          context,
          "Error!",
          "Please verify...",
          Icon(
            Icons.error_outline,
            color: Colors.red,
          ));
    }
  }
}
