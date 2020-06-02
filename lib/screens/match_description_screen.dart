import 'package:flutter/material.dart';
import '../providers/player_matches_statistics.dart';
import '../providers/my_clubs.dart';
import '../providers/my_matches.dart';
import '../providers/player_matches_statistics.dart';
import '../providers/squad.dart';
import '../providers/squads.dart';
import '../providers/timetables.dart';
import '../screens/end_match_screen.dart';
import '../widgets/ended_match_statistics.dart';
import 'package:provider/provider.dart';

class MatchDescriptionScreen extends StatefulWidget {
  static const routeName = '/match-description';

  @override
  _MatchDescriptionScreenState createState() => _MatchDescriptionScreenState();
}

class _MatchDescriptionScreenState extends State<MatchDescriptionScreen> {
  bool isInit = false;

  @override
  void didChangeDependencies() {
    if (isInit == false) {
      final clubsProvider = Provider.of<MyClubs>(context, listen: false);
      final timetablesProvider =
          Provider.of<Timetables>(context, listen: false);
      final matchesProvider = Provider.of<MyMatches>(context, listen: false);
      matchesProvider.getAllMatchesFromTimetable(
          clubsProvider.getActiveClub().id,
          timetablesProvider.getSelectedTimetable().id);

      final squadsProvider = Provider.of<Squads>(context);
      squadsProvider.getAllSquadsFromClub(clubsProvider.getActiveClub().id);
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    isInit = true;
    final myMatchesProvider = Provider.of<MyMatches>(context);
    final myClubsProvider = Provider.of<MyClubs>(context, listen: false);
    final squadsProvider = Provider.of<Squads>(context, listen: false);

    final playerMatchesStatisticsProvider =
        Provider.of<PlayerMatchesStatistics>(context, listen: false);
    // final selectedPlayerMatchesStatistics = playerMatchesStatisticsProvider

    final selectedClub = myClubsProvider.getActiveClub();

    final selectedMyMatch = myMatchesProvider.getSelectedMyMatch();

    // print(selectedMyMatch.isEnd);

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
      body: Card(
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
                  child: Text(
                    'Skład: ${getSelectedSquad(selectedMyMatch.squadId).name}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                selectedMyMatch.isEnd != true
                    ? RaisedButton(
                        child: Text("Zakończ mecz"),
                        color: Colors.orange,
                        onPressed: () => {
                          Navigator.of(context)
                              .pushNamed(EndMatchScreen.routeName)
                        },
                      )
                    : EndedMatchStatistics(selectedMyMatch),
                selectedMyMatch.isEnd == true
                    ? RaisedButton(
                        child: Text("Oceń zawodników"),
                        color: Colors.green,
                        onPressed: () => {},
                      )
                    : Text(''),
              ],
            )
          ],
        ),
      ),
    );
  }
}
