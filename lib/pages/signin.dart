import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/authentication.dart';
import '../utils/showerror.dart';
import 'home.dart';

//
// Classe para sigin no Web Service
//
class SignIn extends StatelessWidget {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  User _user = User.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formStateKey,
              autovalidate: true,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _user.email,
                      decoration: InputDecoration(labelText: 'Email',),
                      validator: (value) => _validateEmail(value),
                      onSaved: (value) => _user.email = value,
                    ),
                    TextFormField(
                      initialValue: _user.password,
                      decoration: InputDecoration(labelText: 'Password',),
                      obscureText: true,
                      validator: (value) => _validatePassword(value),
                      onSaved: (value) => _user.password = value,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite, // set width to maxFinite
              child: RaisedButton(
                onPressed: () => _signinEmail(context),
                color: Colors.blue[300],
                child: Text("Log In")
              ),
            ),
            FlatButton(
              onPressed: () => _register(context),
              child: Text("Register")
            ),
            OutlineButton(
              splashColor: Colors.grey,
              onPressed: () => _signinGoogle(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.grey),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/images/google_logo.jpg"),
                      height: 35.0
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 20,color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  //
  // Valida o email
  //
  String _validateEmail(String value) {
    String ret = null;
    value = value.trim();
    if (value.isEmpty)
      ret = "Email e obrigatorio";
    else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
      ret = "Email inválido";
    return ret;
  }

  //
  // Valida a password
  //
  String _validatePassword(String value) {
    String ret = null;
    value = value.trim();
    if (value.isEmpty)
      ret = "Pasword e obrigatoria";
    else if(value.length < 4)
      ret = "Minimo de 4 caracteres";
    return ret;
  }

  //
  // Autenticar email/password
  //
  void _signinEmail(BuildContext context) async {
    print("Email signin");
    String _errorMsg;
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
      var _signed = await AuthHelper.signInWithEmail(
          _user.email,
          _user.password
      ).catchError((_error) {
        _errorMsg = "${_error}";
      });
      if(_signed != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home())
        );
      } else
        showError(context, _errorMsg);
    }
  }

  //
  // Registrar email/password
  //
  void _register(BuildContext context) async {
    print("Register");
    String _errorMsg;
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
      var _signed = await AuthHelper.createUser(
        _user.email,
        _user.password
      ).catchError((_error) {
        _errorMsg = "${_error}";
      });
      if(_signed != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home())
        );
      } else
        showError(context, _errorMsg);
    }
  }

  //
  // Autenticar conta do Google
  //
  void _signinGoogle(BuildContext context) async {
    print("Google signin");
    String _errorMsg = "";
    var _signed = await AuthHelper.signInWithGoogle().catchError((_error) {
      _errorMsg = _error;
    });
    if(_signed != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Home())
      );
    } else
      showError(context, _errorMsg);
  }
}