import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../providers/timetable.dart';

class Timetables with ChangeNotifier {
  List<Timetable> _timetables = [];
  final databaseReference = Firestore.instance;

  Timetable _selectedTimetable;

  List<Timetable> get items {
    return [..._timetables];
  }

  Future<void> addTimetable(Timetable timetable, clubId) async {
    print('Adding timetable');
    DocumentReference ref = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .add({
      'name': timetable.name,
    });

    timetable.id = ref.documentID;
    _timetables.add(timetable);

    notifyListeners();
  }

  Future<void> getAllTimetablesFromClub(clubId) async {
    print('Getting all timetables from club');
    await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .getDocuments()
        .then((value) {
      var timetables =
          value.documents.map((e) => Timetable.fromFirestore(e)).toList();
      _timetables = timetables;
      notifyListeners();
    });
  }

  Timetable getSelectedTimetable() {
    return _selectedTimetable;
  }

  void setSelectedTimetable(timetableId) {
    _selectedTimetable = getTimetableById(timetableId);
  }

  Timetable getTimetableById(timetableId) {
    return _timetables.firstWhere((t) => t.id == timetableId);
  }
}
