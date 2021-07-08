import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diary/screens/register.dart';
import 'package:diary/services/authservice.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  final snackBar = SnackBar(content: Text('Invalid Username or Password'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFF57AC),
        title: Text('Diary',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
        body: Container(

          padding: EdgeInsets.symmetric(vertical: 170.0, horizontal: 40.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                      SizedBox(height: 20,),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: new InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black
                              )
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide()
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);

                        },
                      ),
                    SizedBox(height: 20,),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w800,
                      ), 
                      decoration: new InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black
                            )
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide()
                        ),
                      ),
                      obscureText: true,
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => pass = val);

                      },
                    ),
                      SizedBox(height: 40,),
                      RaisedButton(
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              dynamic result = _authService.loginWithEmailAndPass(email,pass);

                            }
                          },
                        color: Color(0xFFFF57AC),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text('Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:20,
                            ),
                        ),
                      ),
                    SizedBox(height: 30),
                    Container(
                      child: InkWell(
                        child: Text('New User? Register',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'NotoSansJP',
                          ),
                        ),
                        onTap:() {Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Register(),)
                        );},
                      ),
                    )
                  ],
              ),
            ),
          ),
        )
    );
  }
}
