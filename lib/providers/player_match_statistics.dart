class PlayerMatchStatistics {
  String id;
  String matchId;
  String playerId;
  int goals;
  int assists;
  int tacles;
  int goalsConceded;
  double grade;
  DateTime injuryDate;

  PlayerMatchStatistics({
    this.id,
    this.matchId,
    this.playerId,
    this.goals,
    this.assists,
    this.tacles,
    this.goalsConceded,
    this.grade,
    this.injuryDate,
  });
}
