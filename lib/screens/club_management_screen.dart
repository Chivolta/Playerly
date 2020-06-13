import 'package:com.playerly/providers/my_match.dart';

import '../providers/my_clubs.dart';
import '../providers/my_matches.dart';
import '../providers/players.dart';
import '../providers/sponsors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/club_management_drawer.dart';

class ClubManagementScreen extends StatefulWidget {
  static const routeName = '/club-management';

  @override
  _ClubManagementScreenState createState() => _ClubManagementScreenState();
}

class _ClubManagementScreenState extends State<ClubManagementScreen> {
  var _isLoading = false;
  var _isInit = false;
  MyMatch _lastMatch;
  MyMatch _nextMatch;

  void didChangeDependencies() async {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });

      final myClubsProvider = Provider.of<MyClubs>(context);
      final playersProvider = Provider.of<Players>(context);
      final matchesProvider = Provider.of<MyMatches>(context);
      final sponsorsProvider = Provider.of<Sponsors>(context);
      final clubId = myClubsProvider.getActiveClub().id;

      _lastMatch = await matchesProvider.getLastMatch(clubId);
      _nextMatch = await matchesProvider.getNextMatch(clubId);
      await playersProvider.getAllPlayerFromClub(clubId);
      _isInit = true;
    }

    _isLoading = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<Players>(context);
    final sponsorsProvider = Provider.of<Sponsors>(context);

    final myClubsProvider = Provider.of<MyClubs>(context);
    final clubId = myClubsProvider.getActiveClub().id;

    Color getCardColor(MyMatch m) {
      if (m.isEnd == true) {
        if (m.ourGoals > m.opponentGoals) {
          return Colors.green[100];
        }
        if (m.ourGoals < m.opponentGoals) {
          return Colors.red[100];
        }

        if (m.ourGoals == m.opponentGoals) {
          return Colors.yellow[100];
        }
      }
      return Colors.white;
    }

    String getMatchResultText(MyMatch m) {
      if (m.ourGoals > m.opponentGoals) {
        return 'Wygrana ${m.ourGoals} - ${m.opponentGoals}';
      }
      if (m.ourGoals < m.opponentGoals) {
        return 'Przegrana ${m.ourGoals} - ${m.opponentGoals}';
      }

      if (m.ourGoals == m.opponentGoals) {
        return 'Remis ${m.ourGoals} - ${m.opponentGoals}';
      }
      return '';
    }

    var selectedClub = myClubsProvider.getActiveClub();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Podsumowanie'),
        ),
        drawer: ClubManagementDrawer(),
        body: _isLoading == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Card(
                    child: Card(
                      color: getCardColor(_lastMatch),
                      margin: const EdgeInsets.all(1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: _lastMatch != null
                              ? <Widget>[
                                  Center(
                                    child: Text(
                                      'Poprzedni mecz:',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      '${selectedClub.name} vs ${_lastMatch.opponentName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        'Miejsce: ${_lastMatch.stadiumName}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        'Data: ${_lastMatch.datetimeMatch}'),
                                  ),
                                  _lastMatch.isEnd == true
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            getMatchResultText(_lastMatch),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Text(''),
                                ]
                              : Text(''),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Card(
                      margin: const EdgeInsets.all(1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: _nextMatch != null
                              ? <Widget>[
                                  Center(
                                    child: Text(
                                      'Następny mecz:',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      '${selectedClub.name} vs ${_nextMatch.opponentName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        'Miejsce: ${_nextMatch.stadiumName}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        'Data: ${_nextMatch.datetimeMatch}'),
                                  ),
                                ]
                              : Text(''),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
