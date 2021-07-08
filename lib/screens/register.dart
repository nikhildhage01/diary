import 'package:flutter/material.dart';
import 'package:diary/screens/login.dart';
import 'package:diary/services/authservice.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();
  String email = '';
  String pass = '';

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
         /* decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFFF559F),
                  Color(0xFFCF5CCF),
                  Color(0xFFFF57AC),
                  Color(0xFFFF6D91),
                  Color(0xFFFF8D7E),
                  Color(0xFFB6BAA6),
                ],
                stops: [0.05, 0.3, 0.5, 0.55, 0.8, 1],
              )
          ),*/
          padding: EdgeInsets.symmetric(vertical: 170.0, horizontal: 40.0),
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
                SizedBox(height: 20.0),
                TextFormField(
                  style: TextStyle(

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
                  validator: (val) => val.length < 6 ? 'Enter a strong password' : null,
                  onChanged: (val) {
                    setState(() => pass = val);
                  },
                ),
                SizedBox(height: 40,),
                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: () async {
                        if(_formKey.currentState.validate()){
                    dynamic result = await _authService.registerWithEmailAndPass(email,pass);
                    if(result == null){
                    print(result);
                    print(pass);
                      }
                    }
                  },
                  color: Color(0xFFFF57AC),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:20,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  child: InkWell(
                    child: Text('Already Register? Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'NotoSansJP',
                      ),
                    ),
                    onTap:() {Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login(),)
                    );},
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
