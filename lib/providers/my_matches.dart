import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/my_match.dart';

import 'my_match.dart';

class MyMatches with ChangeNotifier {
  List<MyMatch> _matches = [];
  bool _ifPlayersWereRated = false;

  final databaseReference = Firestore.instance;
  MyMatch _selectedMyMatch;

  List<MyMatch> get items {
    return [..._matches];
  }

  bool getIfPlayersWereRated() {
    return _ifPlayersWereRated;
  }

  MyMatch getSelectedMyMatchById(myMatchId) {
    return _matches.firstWhere((m) => m.id == myMatchId);
  }

  MyMatch getSelectedMyMatch() {
    return _selectedMyMatch;
  }

  Future<double> getSumOfRevenuesFromAllMatches(clubId) async {
    var timetablesQuery = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .getDocuments();

    var timetables = timetablesQuery.documents;

    var sum = 0.0;
    for (var t in timetables) {
      var matchesQuery = await databaseReference
          .collection("clubs")
          .document(clubId)
          .collection('timetables')
          .document(t.documentID)
          .collection('matches')
          .getDocuments();

      var matches = matchesQuery.documents;

      for (var m in matches) {
        if (m.data['revenue'] != null) {
          sum += m.data['revenue'];
        }
      }
    }

    return sum;
  }

  Future<void> checkIfPlayersWereRated(clubId, timetableId, matchId) async {
    print('Checking if players was Rated');
    var result = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .document(timetableId)
        .collection('matches')
        .document(matchId)
        .collection('playerMatchesStatistics')
        .getDocuments();

    _ifPlayersWereRated = result.documents.length > 0 ? true : false;
    notifyListeners();
  }

  Future<MyMatch> getNextMatch(clubId) async {
    print('Getting Next Match');
    var timetablesQuery = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .getDocuments();

    var timetables = timetablesQuery.documents;

    List<MyMatch> matches = [];

    for (var t in timetables) {
      var matchesQuery = await databaseReference
          .collection("clubs")
          .document(clubId)
          .collection('timetables')
          .document(t.documentID)
          .collection('matches')
          .where('isEnd', isEqualTo: false)
          // .orderBy('datetimeMatch', descending: true)
          // .limit(1)
          .getDocuments();

      List<MyMatch> matchesTemp =
          matchesQuery.documents.map((e) => MyMatch.fromFirestore(e)).toList();

      matchesTemp.where((m) =>
          (m.datetimeMatch).compareTo(DateTime.now()) > 0 ? true : false);
      matchesTemp.sort((a, b) => (b.datetimeMatch).compareTo(a.datetimeMatch));

      if (matchesTemp.length > 0) {
        matches.add(matchesTemp[0]);
      }
    }

    matches.sort((a, b) => (b.datetimeMatch).compareTo(a.datetimeMatch));
    if (matches.length > 0) {
      return matches[0];
    } else {
      return null;
    }
  }

  Future<MyMatch> getLastMatch(clubId) async {
    print('Getting Last Match');
    var timetablesQuery = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .getDocuments();

    var timetables = timetablesQuery.documents;

    List<MyMatch> matches = [];

    for (var t in timetables) {
      var matchesQuery = await databaseReference
          .collection("clubs")
          .document(clubId)
          .collection('timetables')
          .document(t.documentID)
          .collection('matches')
          .where('isEnd', isEqualTo: true)
          // .orderBy('datetimeMatch', descending: true)
          // .limit(1)
          .getDocuments();

      List<MyMatch> matchesTemp =
          matchesQuery.documents.map((e) => MyMatch.fromFirestore(e)).toList();

      matchesTemp = matchesTemp.where((m) => m.isEnd == true).toList();
      matchesTemp.sort((a, b) => (b.datetimeMatch).compareTo(a.datetimeMatch));

      if (matchesTemp.length > 0) {
        matches.add(matchesTemp[0]);
      }
    }

    matches.sort((a, b) => (b.datetimeMatch).compareTo(a.datetimeMatch));
    if (matches.length > 0) {
      return matches[0];
    } else {
      return null;
    }
  }

  Future<void> getAllMatchesFromTimetable(clubId, timetableId) async {
    print('Getting all matches');
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

      matches.map((e) => print(e.isEnd));
      _matches = matches;
      notifyListeners();
    });
  }

  setSelectedMyMatch(myMatchId) {
    _selectedMyMatch = getSelectedMyMatchById(myMatchId);
  }

  Future<void> addMatch(MyMatch match, clubId, timetableId) async {
    print('Adding match');
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

    notifyListeners();
  }

  void updateMatch(clubId, timetableId, matchId, MyMatch match) async {
    print('Updating match');
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
}
