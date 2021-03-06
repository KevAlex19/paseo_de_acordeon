import 'package:flutter/rendering.dart';
import 'package:paseo_de_acordeon/components/constans.dart';
import 'package:paseo_de_acordeon/controllers/pushNotification.dart';
import 'package:paseo_de_acordeon/views/registerLayaou.dart' as register;
import 'package:paseo_de_acordeon/views/loginGoogle.dart' as google;
import 'package:paseo_de_acordeon/views/content/menu.dart' as menu;
import 'package:paseo_de_acordeon/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:achievement_view/achievement_view.dart';

class MyAppLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePageLogin();
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class MyHomePageLogin extends StatefulWidget {
  MyHomePageLogin({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageLogin> {
  @override
  void initState() {
    super.initState();
    final notify = MyAppN();
    notify.createState().initState();
  }

  UserController _con;
  String emailUser = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _rememberMe = false;

  Widget _wForm(String name, IconData ico, bool p,
      TextEditingController control, Widget widg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              child: SizedBox(
            width: 20,
          )),
          widg
        ]),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: control,
            obscureText: p,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                ico,
                color: Colors.white,
              ),
              hintText: 'Ingrese su ' + name,
              hintStyle: kHintTextStyle,
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Verifique los campos';
              }
            },
          ),
        )
      ],
    );
  }

  Widget _forgotPassBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _rememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _loginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => _signIn(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue,
        child: Text(
          'Ingresar',
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

  Widget _signInWithText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          'Ingresa con',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _signupBtn() {
    return FlatButton.icon(
      textColor: Colors.lightBlueAccent,
      color: Colors.blue.withOpacity(0.5),
      shape: StadiumBorder(),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => register.MyApp()),
        );
      },
      label: Text(
        'Registrarse',
        style: kCLabelStyle,
      ),
      icon: Icon(Icons.supervised_user_circle, color: Colors.white),
    );
  }

  Widget _continueBtn() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15),
        child: RaisedButton(
          color: Colors.blue.withAlpha(180),
          textColor: Colors.lightBlueAccent,
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => menu.Menu(emailUser)));
          },
          child: Row(
            children: <Widget>[
              Text(
                'Omitir inicio de sesión',
                style: kCLabelStyle,
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                semanticLabel: kCLabelStyle.fontFamily,
              ),
            ],
          ),
          shape: StadiumBorder(),
        ),
      ),
    );
  }

  Widget _socialBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => google.SignInDemo())),
      child: Container(
        alignment: Alignment.bottomLeft,
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: AssetImage('assets/GoogleLogo.png'),
          ),
        ),
      ),
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      'assets/ico_logo.png',
                      scale: 2.0,
                    ),
                    _wForm('Email', Icons.email, false, _emailController,
                        _signupBtn()),
                    SizedBox(
                      height: 20.0,
                    ),
                    _wForm('Contraseña', Icons.lock, true, _passController,
                        Text('')),
                    _forgotPassBtn(),
                    _loginBtn(),
                    _signInWithText(),
                    SizedBox(
                      height: 5,
                    ),
                    _socialBtn(),
                    SizedBox(height: 30.0),
                    _continueBtn(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    if (_formKey.currentState.validate() == true) {
      try {
        final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        ))
            .user;
        setState(() {
          emailUser = user.email;
        });
        showAlert(
            context,
            "Acceso permitido!",
            "Bienvenido",
            Icon(
              Icons.done,
              color: Colors.cyanAccent,
            ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => menu.Menu(emailUser)));
      } catch (e) {
        showAlert(
            context,
            "Error!",
            e.toString().substring(18, 38),
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ));
      }
    } else {
      showAlert(
          context,
          "Error!",
          "Porfavor verifique...",
          Icon(
            Icons.error_outline,
            color: Colors.red,
          ));
    }
  }

  void showAlert(BuildContext context, String tittle, String sub, Widget ico) {
    AchievementView(context,
        icon: ico,
        title: tittle,
        subTitle: sub,
        isCircle: true,
        duration: Duration(milliseconds: 3000),
        color: Colors.blueGrey.withOpacity(0.5), listener: (status) {
      print(status);
    })
      ..show();
  }
}
