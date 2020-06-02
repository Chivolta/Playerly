import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/my_match.dart';

import 'my_match.dart';

class MyMatches with ChangeNotifier {
  List<MyMatch> _matches = [];

  final databaseReference = Firestore.instance;
  MyMatch _selectedMyMatch;

  List<MyMatch> get items {
    return [..._matches];
  }

  MyMatch getSelectedMyMatchById(myMatchId) {
    return _matches.firstWhere((m) => m.id == myMatchId);
  }

  MyMatch getSelectedMyMatch() {
    return _selectedMyMatch;
  }

  getAllMatchesFromTimetable(clubId, timetableId) async {
    await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .document(timetableId)
        .collection('matches')
        .getDocuments()
        .then((value) {
      var matches =
          value.documents.map((e) => MyMatch.fromFirestore(e)).toList();

      print('xd---------------');
      matches.map((e) => print(e.isEnd));
      print('xd---------------');
      _matches = matches;
      notifyListeners();
    });
  }

  setSelectedMyMatch(myMatchId) {
    _selectedMyMatch = getSelectedMyMatchById(myMatchId);
  }

  void addMatch(MyMatch match, clubId, timetableId) async {
    DocumentReference ref = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .document(timetableId)
        .collection('matches')
        .add({
      'opponentName': match.opponentName,
      'stadiumName': match.stadiumName,
      'datetimeMatch': match.datetimeMatch,
      'opponentGoals': match.opponentGoals,
      'ourGoals': match.ourGoals,
      'revenue': match.revenue,
      'isEnd': match.isEnd,
      'squadId': match.squadId,
    });

    match.id = ref.documentID;
    _matches.add(match);

    notifyListeners(); // notify all widgets about changes - so we used ChangeNotifier
  }

  void updateMatch(clubId, timetableId, matchId, MyMatch match) async {
    await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .document(timetableId)
        .collection('matches')
        .document(matchId)
        .updateData({
      'ourGoals': match.ourGoals,
      'opponentGoals': match.opponentGoals,
      'revenue': match.revenue,
      'isEnd': match.isEnd
    });

    var index = _matches.indexWhere((m) => m.id == matchId);
    _matches[index] = match;
    _selectedMyMatch = match;

    notifyListeners();
  }

  MyMatch getMyClubById(matchId) {
    return _matches.firstWhere((m) => m.id == matchId);
  }
}