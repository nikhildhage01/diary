import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:diary/models/notemodel.dart';
import 'package:flutter/material.dart';

class AuthService{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final snackBar = SnackBar(content: Text('Invalid Username or Password'));
  bool log = true;
  Stream<FirebaseUser> get user{
    return _firebaseAuth.onAuthStateChanged;
  }

  Future registerWithEmailAndPass(String email,String pass) async{
    try{
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      FirebaseUser firebaseUser = result.user;
      return firebaseUser;
    }
    catch(e){

      return 0;
    }
  }

  Future loginWithEmailAndPass(String email,String pass) async{

    try{
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser firebaseUser = result.user;
      return firebaseUser;
    }
    catch(e){
      log = false;
      return log;
    }
  }

  Future<void> updateNote(DateTime dateTime, String title, String details, String url) async{
      CollectionReference user = Firestore.instance.collection('users');
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser usr = await auth.currentUser();
      String uid = usr.uid;
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
      String docId = uid+formattedDate;
      user.document(docId).setData(
        {
          'uid' : uid,
          'dateTime' : formattedDate,
          'title' : title,
          'details' : details,
          'url' : url
        }
      );
      return;

  }

  Future signOut() async{
    try{
      return await _firebaseAuth.signOut();
    }
    catch(e){
      print(e);
    }
  }
  getUid(String uid) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usr = await auth.currentUser();
    uid = usr.uid;
    return uid;
  }
}