import 'dart:io';

import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diary/services/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:diary/models/notemodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


NoteModel noteModel;
String docId;
String uid;
String url = '';
class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final picker = ImagePicker();
  bool checked = false;
  File sampleImage;
  DateTime dateTime;
  String stringDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  AuthService authService = AuthService();
  FirebaseUser user;

  Future getImage() async {
    // ignore: deprecated_member_use
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  Future<void> getUserData() async {
    FirebaseUser usr = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = usr;
      uid = user.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(stringDate);
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Date not selected'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[800],
      ));
    });

    dateTime = DateTime.now();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.blueAccent,
        elevation: 0.0,

        backgroundColor: Color(0xFFFF57AC),
        title: Text('Diary'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              handleClick(value);
            },
            itemBuilder: (BuildContext context) {
              return {'Save', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(

        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("Date (YYYY-MM-DD)"),
                  subtitle: Text(
                      "${dateTime.year} - ${dateTime.month} - ${dateTime.day}"),
                  onTap: () async {
                    DateTime picked = await showDatePicker(context: context,
                        initialDate: dateTime,
                        firstDate: DateTime(dateTime.year - 25),
                        lastDate: DateTime(dateTime.year + 80));
                    if (picked != null) {
                      setState(() {
                        dateTime = picked;
                        String formattedDate = DateFormat('yyyy-MM-dd').format(
                            dateTime);
                        docId = uid + formattedDate;
                        getData(formattedDate);
                      });
                    }
                  },
                ),

                SizedBox(height: 20,),
                TextFormField(
                  controller: _title,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w800,

                  ),
                  decoration: new InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        )
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _description,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: new InputDecoration(
                    labelText: 'Write something...',
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
                ),
                SizedBox(height: 20,),
                Container(
                  child:
                  checked ? Image.network(url) : sampleImage == null ? Text(
                      'No image for event') : enableUpload(),
                  // child: Image.network(url) == null ? sampleImage == null ? Text('No image for event'): enableUpload(),
                  // child: sampleImage == null ? Text('No image for event'): enableUpload(),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {

                    });
                  },
                  color: Color(0xFFFF57AC),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Refresh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),


              ],

            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: getImage,
        tooltip: 'Add Image',
        backgroundColor: Color(0xFFFF57AC),
      ),

    );
  }


  Widget enableUpload() {
    return Container(
      child: Column(

        children: <Widget>[
          Image.file(sampleImage, height: 300,
            width: 400,
            alignment: Alignment.centerLeft,),
          SizedBox(height: 20,),
          RaisedButton(
            onPressed: () async {
              final StorageReference ref = FirebaseStorage.instance.ref().child(
                  docId);
              final StorageUploadTask task = ref.putFile(sampleImage);
              StorageTaskSnapshot storageSnapshot = await task.onComplete;
              var downloadUrl = await storageSnapshot.ref.getDownloadURL();
              if (task.isComplete) {
                url = downloadUrl.toString();
                authService.updateNote(
                    dateTime, _title.text, _description.text, url);
              }
            },
            color: Color(0xFFFF57AC),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text('Upload',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future getData(String date) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usr = await auth.currentUser();
    String uid = usr.uid;
    _title.text = '';
    _description.text = '';
    url = '';
    var result = await Firestore.instance.collection('users')
        .where("dateTime", isEqualTo: date)
        .where('uid', isEqualTo: uid)
        .getDocuments();
    result.documents.forEach((doc) {
      if (doc.exists) {
        noteModel = NoteModel.fromDocument(doc);
        _title.text = noteModel.title;
        _description.text = noteModel.description;
        print(noteModel.url);
        if (noteModel.url != "") {
          checked = true;
          url = noteModel.url;
          print(url);
        }
        else
          checked = false;
        print(checked);
      }
    });
  }

  void handleClick(String value) async {
    switch (value) {
      case "Save":
        await authService.updateNote(
            dateTime, _title.text, _description.text, url);
        Navigator.pop(context);
        break;
      case 'Delete':
        final confirm = await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Warning!!!"),
                content: Text("Are you sure you want to delete?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("Delete")),
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
        ) ??
            false;
        if (confirm) {
          Firestore.instance.collection('users').document(docId).delete();
          _title.text = '';
          _description.text = '';
          Navigator.pop(context);
        }
        break;
    }
  }
}
