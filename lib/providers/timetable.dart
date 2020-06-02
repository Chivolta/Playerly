import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Timetable {
  String id;
  String name;

  Timetable({@required this.id, @required this.name});

  factory Timetable.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Timetable(
      id: doc.documentID,
      name: data['name'],
    );
  }
}
