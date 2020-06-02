import 'package:flutter/cupertino.dart';
import '../providers/player_match_statistics.dart';

class PlayerMatchesStatistics with ChangeNotifier {
  List<PlayerMatchStatistics> _playerMatchesStatistics = [];

  List<PlayerMatchStatistics> get items {
    return [..._playerMatchesStatistics];
  }

  void addPlayerMatchStatistics(playerMatchStatistics) {
    _playerMatchesStatistics.add(playerMatchStatistics);
    notifyListeners(); // notify all widgets about changes - so we used ChangeNotifier
  }

  PlayerMatchStatistics getPlayerMatchStatisticsByMatchId(matchId) {
    return _playerMatchesStatistics.firstWhere((p) => p.matchId == matchId);
  }

  List<PlayerMatchStatistics> getPlayerMatchesStatisticsByPlayerId(playerId) {
    return _playerMatchesStatistics
        .where((p) => p.playerId == playerId)
        .toList();
  }
}
