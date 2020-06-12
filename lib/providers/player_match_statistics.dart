import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerMatchStatistics {
  String id;
  String playerId;
  int goals;
  int goalsConceded;
  double rating;
  bool isInjured;
  DateTime injuryTo;

  PlayerMatchStatistics({
    this.id,
    this.playerId,
    this.goals,
    this.goalsConceded,
    this.rating,
    this.isInjured,
    this.injuryTo,
  });

  factory PlayerMatchStatistics.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return PlayerMatchStatistics(
      id: doc.documentID,
      playerId: data['matchId'],
      goals: data['goals'],
      goalsConceded: data['goalsConceded'],
      rating: data['grade'],
      isInjured: data['isInjured'],
      injuryTo: DateTime.parse(data['injuryTo'].toDate().toString()),
    );
  }
}
