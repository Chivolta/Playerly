import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../providers/player_match_statistics.dart';

class PlayerMatchesStatistics with ChangeNotifier {
  List<PlayerMatchStatistics> _playerMatchesStatistics = [];
  var _ratingsList = [];
  final databaseReference = Firestore.instance;

  List<PlayerMatchStatistics> get items {
    return [..._playerMatchesStatistics];
  }

  getRatingsList() {
    return [..._ratingsList];
  }

  clearRatingList() {
    _ratingsList = [];
    notifyListeners();
  }

  Future<void> addPlayerMatchStatistics(
    PlayerMatchStatistics playerMatchStatistics,
    String clubId,
    String timetableId,
    String matchId,
    String playerId,
  ) async {
    print('Adding player match statistics');
    DocumentReference ref = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .document(timetableId)
        .collection('matches')
        .document(matchId)
        .collection('playerMatchesStatistics')
        .add({
      'playerId': playerMatchStatistics.playerId,
      'goals': playerMatchStatistics.goals,
      'goalsConceded': playerMatchStatistics.goalsConceded,
      'rating': playerMatchStatistics.rating,
      'isInjured': playerMatchStatistics.isInjured,
      'injuryTo': playerMatchStatistics.injuryTo
    });

    playerMatchStatistics.id = ref.documentID;
    _playerMatchesStatistics.add(playerMatchStatistics);

    notifyListeners();
  }

  Future<double> getAveragePlayerRating(String clubId, String playerId) async {
    print('Getting players rating');
    var rating = 0.0;
    var numberOfMatches = 0;
    DocumentReference clubDocRef =
        databaseReference.collection('clubs').document(clubId);

    QuerySnapshot timetablesQuery =
        await clubDocRef.collection('timetables').getDocuments();
    var timetables = timetablesQuery.documents;

    var matches = [];
    var playerMatchesStatistics = [];

    for (var t in timetables) {
      var matchesQuery = await clubDocRef
          .collection('timetables')
          .document(t.documentID)
          .collection('matches')
          .getDocuments();
      matches = matchesQuery.documents;
      numberOfMatches = matches.length;

      for (var m in matches) {
        var playerMatchesStatisticsQuery = await clubDocRef
            .collection('timetables')
            .document(t.documentID)
            .collection('matches')
            .document(m.documentID)
            .collection('playerMatchesStatistics')
            .where("playerId", isEqualTo: playerId)
            .getDocuments();

        if (playerMatchesStatisticsQuery.documents.isNotEmpty) {
          playerMatchesStatistics
              .add(playerMatchesStatisticsQuery.documents[0]);
        }
      }
    }

    for (var i = 0; i < playerMatchesStatistics.length; i++) {
      rating += playerMatchesStatistics[i]['rating'];
    }

    return rating / numberOfMatches;
  }

  // Future<void> getAllMatchesFromTimetable(
  //     String clubId, String timetableId, String matchId) async {
  //   print('Getting all matches');
  //   await databaseReference
  //       .collection("clubs")
  //       .document(clubId)
  //       .collection('timetables')
  //       .document(timetableId)
  //       .collection('matches')
  //       .document(matchId)
  //       .collection('playerMatchesStatistics')
  //       .getDocuments()
  //       .then((value) {
  //     var playerMatchesStatistics = value.documents
  //         .map((e) => PlayerMatchStatistics.fromFirestore(e))
  //         .toList();

  //     _playerMatchesStatistics = playerMatchesStatistics;
  //     notifyListeners();
  //   });
  // }
}
