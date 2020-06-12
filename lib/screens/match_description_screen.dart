import '../screens/rate_players_screen.dart';
import '../providers/my_clubs.dart';
import '../providers/my_matches.dart';
import '../providers/squad.dart';
import '../providers/squads.dart';
import '../providers/timetables.dart';
import '../screens/end_match_screen.dart';
import '../widgets/ended_match_statistics.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchDescriptionScreen extends StatefulWidget {
  static const routeName = '/match-description';

  @override
  _MatchDescriptionScreenState createState() => _MatchDescriptionScreenState();
}

class _MatchDescriptionScreenState extends State<MatchDescriptionScreen> {
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });
      final clubsProvider = Provider.of<MyClubs>(context);
      final timetablesProvider = Provider.of<Timetables>(context);
      final matchesProvider = Provider.of<MyMatches>(context);
      final squadsProvider = Provider.of<Squads>(context);

      final clubId = clubsProvider.getActiveClub().id;
      final timetableId = timetablesProvider.getSelectedTimetable().id;

      final selectedMyMatch = matchesProvider.getSelectedMyMatch();
      final matchId = selectedMyMatch.id;
      matchesProvider
          .getAllMatchesFromTimetable(
            clubId,
            timetableId,
          )
          .then((_) => matchesProvider.checkIfPlayersWereRated(
              clubId, timetableId, matchId))
          .then((_) => squadsProvider.getAllSquadsFromClub(clubId))
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      _isInit = true;

      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final myMatchesProvider = Provider.of<MyMatches>(context);
    final myClubsProvider = Provider.of<MyClubs>(context);
    final squadsProvider = Provider.of<Squads>(context);
    final selectedClub = myClubsProvider.getActiveClub();

    final selectedMyMatch = myMatchesProvider.getSelectedMyMatch();

    Squad getSelectedSquad(squadId) {
      return squadsProvider.getSquadById(squadId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMyMatch.opponentName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => {},
          )
        ],
      ),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Card(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${selectedClub.name} vs ${selectedMyMatch.opponentName}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Miejsce: ${selectedMyMatch.stadiumName}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Data: ${selectedMyMatch.datetimeMatch}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getSelectedSquad(selectedMyMatch.squadId) != null
                            ? Text(
                                'Skład: ${getSelectedSquad(selectedMyMatch.squadId).name}',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            : Text(
                                'Skład został usunięty',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                      ),
                      selectedMyMatch.isEnd != true &&
                              getSelectedSquad(selectedMyMatch.squadId) != null
                          ? RaisedButton(
                              child: Text("Zakończ mecz"),
                              color: Colors.orange,
                              onPressed: () => {
                                Navigator.of(context)
                                    .pushNamed(EndMatchScreen.routeName)
                              },
                            )
                          : EndedMatchStatistics(selectedMyMatch),
                      selectedMyMatch.isEnd == true &&
                              myMatchesProvider.getIfPlayersWereRated() ==
                                  false &&
                              getSelectedSquad(selectedMyMatch.squadId) != null
                          ? RaisedButton(
                              child: const Text("Oceń zawodników"),
                              color: Colors.green,
                              onPressed: () => {
                                Navigator.of(context)
                                    .pushNamed(RatePlayersScreen.routeName)
                              },
                            )
                          : selectedMyMatch.isEnd == true &&
                                  getSelectedSquad(selectedMyMatch.squadId) !=
                                      null
                              ? Text('Zawodnicy zostali już ocenieni')
                              : Text(''),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
