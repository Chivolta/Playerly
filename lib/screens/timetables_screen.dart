import 'package:flutter/material.dart';
import '../providers/my_clubs.dart';
import '../providers/timetables.dart';
import '../widgets/club_management_drawer.dart';
import 'package:provider/provider.dart';

import 'add_timetable_screen.dart';
import 'my_matches_screen.dart';

class TimetablesScreen extends StatefulWidget {
  static const routeName = '/timetables';

  @override
  _TimetablesScreenState createState() => _TimetablesScreenState();
}

class _TimetablesScreenState extends State<TimetablesScreen> {
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });
      final timetablesProvider = Provider.of<Timetables>(context);
      final clubsData = Provider.of<MyClubs>(context);
      timetablesProvider
          .getAllTimetablesFromClub(clubsData.getActiveClub().id)
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
    final timetablesProvider = Provider.of<Timetables>(context);

    final timetables = timetablesProvider.items;

    void showMyMatches(context, timetableId) {
      timetablesProvider.setSelectedTimetable(timetableId);
      Navigator.of(context).pushNamed(MyMatchesScreen.routeName);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Terminarze'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddTimetableScreen.routeName),
            )
          ],
        ),
        drawer: ClubManagementDrawer(),
        body: _isLoading == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
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
