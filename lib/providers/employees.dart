import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/employee.dart';
import 'package:flutter/material.dart';

class Employees with ChangeNotifier {
  List<Employee> _employees = [];
  final databaseReference = Firestore.instance;

  Future<void> getAllEmployees(clubId) async {
    print('Getting all employees');
    await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('employees')
        .getDocuments()
        .then((value) {
      var employees =
          value.documents.map((e) => Employee.fromFirestore(e)).toList();
      _employees = employees;
      notifyListeners();
    });
  }

  List<Employee> get items {
    return [..._employees];
  }

  // TODO: Usuwanie reszty rzeczy
  Future<void> deleteClub(clubId, employeeId) async {
    print('Deleting employee');
    var deletedIndex = _employees.indexWhere((e) => e.id == employeeId);
    // var deletedClub = _myClubs[deletedIndex];
    _employees.removeAt(deletedIndex);

    try {
      await databaseReference
          .collection('clubs')
          .document(clubId)
          .collection('employees')
          .document(employeeId)
          .delete();
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addEmployee(Employee employee, clubId) async {
    print('Adding employee');
    DocumentReference ref = await databaseReference
        .collection('clubs')
        .document(clubId)
        .collection('employees')
        .add({
      'name': employee.name,
      'surname': employee.surname,
      'position': employee.position,
      'salary': employee.salary,
    });

    employee.id = ref.documentID;
    _employees.add(employee);

    notifyListeners();
  }
}
