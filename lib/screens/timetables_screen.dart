import 'package:flutter/material.dart';
import '../providers/my_clubs.dart';
import '../providers/timetables.dart';
import '../widgets/club_management_drawer.dart';
import 'package:provider/provider.dart';

import 'add_squad_screen.dart';
import 'add_timetable_screen.dart';
import 'my_matches_screen.dart';

class TimetablesScreen extends StatefulWidget {
  static const routeName = '/timetables';

  @override
  _TimetablesScreenState createState() => _TimetablesScreenState();
}

class _TimetablesScreenState extends State<TimetablesScreen> {
  @override
  void didChangeDependencies() {
    final timetablesProvider = Provider.of<Timetables>(context, listen: false);
    final clubsData = Provider.of<MyClubs>(context);
    timetablesProvider.getAllTimetablesFromClub(clubsData.getActiveClub().id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final timetablesProvider = Provider.of<Timetables>(context, listen: false);

    final timetables = timetablesProvider.items;

    void showMyMatches(context, timetableId) {
      timetablesProvider.setSelectedTimetable(timetableId);
      Navigator.of(context).pushNamed(MyMatchesScreen.routeName);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Terminarze'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddTimetableScreen.routeName),
            )
          ],
        ),
        drawer: ClubManagementDrawer(),
        body: ListView(
          children: timetables
              .map((t) => InkWell(
                    child: Card(
                      margin: EdgeInsets.all(1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(t.name),
                      ),
                    ),
                    onTap: () => {showMyMatches(context, t.id)},
                  ))
              .toList(),
        ));
  }
}
