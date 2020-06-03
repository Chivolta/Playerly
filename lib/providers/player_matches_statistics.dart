import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../providers/player_match_statistics.dart';

class PlayerMatchesStatistics with ChangeNotifier {
  List<PlayerMatchStatistics> _playerMatchesStatistics = [];
  final databaseReference = Firestore.instance;

  List<PlayerMatchStatistics> get items {
    return [..._playerMatchesStatistics];
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
      'injuryTo': playerMatchStatistics.isInjured
    });

    playerMatchStatistics.id = ref.documentID;
    _playerMatchesStatistics.add(playerMatchStatistics);

    notifyListeners();
  }

  Future<void> getAllMatchesFromTimetable(
      String clubId, String timetableId, String matchId) async {
    print('Getting all matches');
    await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('timetables')
        .document(timetableId)
        .collection('matches')
        .document(matchId)
        .collection('playerMatchesStatistics')
        .getDocuments()
        .then((value) {
      var playerMatchesStatistics = value.documents
          .map((e) => PlayerMatchStatistics.fromFirestore(e))
          .toList();

      _playerMatchesStatistics = playerMatchesStatistics;
      notifyListeners();
    });
  }
}
