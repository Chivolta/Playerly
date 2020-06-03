import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerMatchStatistics {
  String id;
  String playerId;
  int goals;
  int goalsConceded;
  double rating;
  bool isInjured;

  PlayerMatchStatistics({
    this.id,
    this.playerId,
    this.goals,
    this.goalsConceded,
    this.rating,
    this.isInjured,
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
    );
  }
}
