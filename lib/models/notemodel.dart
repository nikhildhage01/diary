import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

class NoteModel extends DatabaseItem{
  final String uid;
  final String title;
  final String description;
  final String eventDate;
  final String url;

  NoteModel({this.uid,this.title, this.description, this.eventDate, this.url}):super(uid);

  factory NoteModel.fromDocument(DocumentSnapshot doc) {
    return NoteModel(
      uid: doc['uid'] ?? ' ',
      title: doc['title'] ?? ' ',
      description: doc['details'] ?? ' ',
      eventDate: doc['dateTime'] ?? ' ',
      url: doc['url'] ?? ''
    );
  }

  factory NoteModel.fromDS(data) {
    return NoteModel(
      uid: data['uid'] ?? '',
      title: data['title'] ?? '',
      description: data['details'] ?? '',
      eventDate: data['dateTime'].toString() ?? '',
      url: data['url'] ?? ''
    );
  }

  List<NoteModel> _noteList(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return NoteModel(
        title: doc.data['title'] ?? '',
        uid: doc.data['uid'] ?? '',
        description: doc.data['details'] ?? '',
        eventDate: doc.data['dateTime'].toString(),
        url: doc.data['url']

      );
    }).toList();
  }


  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "details": description,
      "dateTime":eventDate,
      "uid":uid,
      "url": url
    };
  }
}