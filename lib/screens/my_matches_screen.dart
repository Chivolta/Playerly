import 'package:com.playerly/providers/my_match.dart';
import 'package:flutter/material.dart';
import '../providers/my_matches.dart';
import '../providers/timetables.dart';
import '../providers/my_clubs.dart';
import '../providers/my_matches.dart';
import '../providers/squad.dart';
import '../providers/squads.dart';
import '../providers/timetables.dart';
import '../screens/add_my_match_screen.dart';
import '../screens/match_description_screen.dart';
import 'package:provider/provider.dart';

class MyMatchesScreen extends StatefulWidget {
  static const routeName = '/matches';

  @override
  _MyMatchesScreenState createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
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

      matchesProvider
          .getAllMatchesFromTimetable(clubsProvider.getActiveClub().id,
              timetablesProvider.getSelectedTimetable().id)
          .then((_) => squadsProvider
              .getAllSquadsFromClub(clubsProvider.getActiveClub().id))
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
    final myTimetablesProvider = Provider.of<Timetables>(context);
    final myClubsProvider = Provider.of<MyClubs>(context);
    final squadsProvider = Provider.of<Squads>(context);

    final selectedClub = myClubsProvider.getActiveClub();
    final selectedTimetable = myTimetablesProvider.getSelectedTimetable();

    final myMatches = myMatchesProvider.items;

    Squad getSelectedSquad(squadId) {
      return squadsProvider.getSquadById(squadId);
    }

    void showSelectedMyMatch(context, myMatchId) {
      myMatchesProvider.setSelectedMyMatch(myMatchId);
      Navigator.of(context).pushNamed(MatchDescriptionScreen.routeName);
    }

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
    }

    myMatches.sort((a, b) => (b.datetimeMatch).compareTo(a.datetimeMatch));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mecze'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddMyMatchScreen.routeName),
          )
        ],
      ),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: myMatches
                  .map((m) => InkWell(
                        child: Card(
                          color: getCardColor(m),
                          margin: const EdgeInsets.all(1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    '${selectedClub.name} vs ${m.opponentName}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Miejsce: ${m.stadiumName}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Data: ${m.datetimeMatch}'),
                                ),
                                Text(
                                    'Wybrany skład: ${getSelectedSquad(m.squadId).name}'),
                                m.isEnd == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          getMatchResultText(m),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Text(''),
                              ],
                            ),
                          ),
                        ),
                        onTap: () => {showSelectedMyMatch(context, m.id)},
                      ))
                  .toList(),
            ),
    );
  }
}
