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
    final myTimetablesProvider =
        Provider.of<Timetables>(context, listen: false);
    final myClubsProvider = Provider.of<MyClubs>(context, listen: false);
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

    myMatches.sort((a, b) => (b.datetimeMatch).compareTo(a.datetimeMatch));

    return Scaffold(
      appBar: AppBar(
        title: Text('Mecze'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddMyMatchScreen.routeName),
          )
        ],
      ),
      body: ListView(
        children: myMatches
            .map((m) => InkWell(
                  child: Card(
                    margin: EdgeInsets.all(1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                                '${selectedClub.name} vs ${m.opponentName}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('Miejsce: ${m.stadiumName}.'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('Data: ${m.datetimeMatch}'),
                          ),
                          Text(
                              'Wybrany skład: ${getSelectedSquad(m.squadId).name}'),
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
