import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diary/services/authservice.dart';
import 'package:diary/models/notemodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'addnotepage.dart';
NoteModel noteModel;
String uid;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseUser user;
  Future<void> getUserData() async{
    FirebaseUser usr = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = usr;
      uid = user.uid;
    });
  }
  CalendarController _controller;
  AuthService _authService = AuthService();
  Map<DateTime, List<NoteModel>> _groupedEvents;
  List<NoteModel> _selectedEvents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    _controller = CalendarController();

  }

  _groupEvents(QuerySnapshot events) {
    _groupedEvents = {};
    events.documents.forEach((event) {
      DateTime dt = DateTime.parse(event.data['dateTime']);
      DateTime date =
      DateTime.utc(dt.year, dt.month, dt.day);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      noteModel = NoteModel.fromDocument(event);
      _groupedEvents[date].add(noteModel);

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFF57AC),
        title: Text('Diary',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'NotoSansJP',
          ),
        ),
        actions: [
          Padding(padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Logout'),
              onPressed: () async{
                _authService.signOut();

              },
              style: ElevatedButton.styleFrom(primary: Colors.deepPurpleAccent),
            ),
          )
        ],
      ),
      //drawer: MainDrawer(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: Firestore.instance.collection('users').where('uid', isEqualTo: uid).snapshots(),
            builder:  (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                  if(snapshot.hasData) {
                    final events = snapshot.data;
                    _groupEvents(events);
                    DateTime selectedDate = _controller.selectedDay;
                    _selectedEvents = _groupedEvents[selectedDate] ?? [];
                  }
                    return Column(
                      children: <Widget>[
                        // ignore: missing_return
                        TableCalendar(
                            events: _groupedEvents,

                            calendarController: _controller),



                      ],
                    );

            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddNotePage(),)
        ),
        backgroundColor: Color(0xFFFF57AC),
      ),
    );


  }

}
