import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Employee with ChangeNotifier {
  String id;
  String name;
  String surname;
  String position;
  double salary;

  Employee({
    @required this.id,
    @required this.name,
    @required this.surname,
    @required this.position,
    this.salary = 0.0,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Employee(
      id: doc.documentID,
      name: data['name'],
      surname: data['surname'],
      position: data['position'],
      salary: data['salary'],
    );
  }
}
