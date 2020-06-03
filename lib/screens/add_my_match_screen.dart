import 'package:flutter/material.dart';
import '../providers/squads.dart';
import '../helpers/errors_text.dart';
import '../providers/my_clubs.dart';
import '../providers/my_match.dart';
import '../providers/my_matches.dart';
import '../providers/timetables.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddMyMatchScreen extends StatefulWidget {
  static const routeName = '/add-my-match';

  @override
  _AddMyMatchScreenState createState() => _AddMyMatchScreenState();
}

class _AddMyMatchScreenState extends State<AddMyMatchScreen> {
  final _form = GlobalKey<FormState>();
  final datetimeController = TextEditingController();

  showDateTimePicker(context) {
    DatePicker.showDateTimePicker(context,
        currentTime: DateTime.now(),
        minTime: DateTime.now().subtract(new Duration(days: 360)),
        maxTime: DateTime.now().add(
          new Duration(days: 360),
        )).then((value) {
      datetimeController.text = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myMatchesProvider = Provider.of<MyMatches>(context);
    final squadsProvider = Provider.of<Squads>(context);

    final myClubsProvider = Provider.of<MyClubs>(context);
    final activeClub = myClubsProvider.getActiveClub();

    final timetablesProvider = Provider.of<Timetables>(context);
    final selectedTimetable = timetablesProvider.getSelectedTimetable();

    var squads = squadsProvider.items;

    var newMyMatch = MyMatch(
      id: '',
      datetimeMatch: null,
      opponentGoals: null,
      opponentName: '',
      ourGoals: null,
      revenue: null,
      squadId: squads.length > 0 ? squads[0].id : null,
      stadiumName: '',
    );

    List<DropdownMenuItem<int>> squadsList = [];

    void loadSquadsList() {
      squadsList = [];

      for (var i = 0; i < squads.length; i++)
        squadsList.add(new DropdownMenuItem(
          child: new Text(squads[i].name),
          value: i,
        ));
    }

    onSubmit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _form.currentState.save();
      myMatchesProvider.addMatch(
          newMyMatch, activeClub.id, selectedTimetable.id);

      Navigator.of(context).pop();
    }

    loadSquadsList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj nowy mecz'),
      ),
      body: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nazwa drużyny przeciwnej',
                  prefixIcon: Icon(Icons.directions_walk),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onSaved: (value) => {newMyMatch.opponentName = value},
                validator: (value) =>
                    value.isNotEmpty ? null : ErrorsText.requiredErrorText,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nazwa stadionu',
                  prefixIcon: Icon(Icons.place),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onSaved: (value) => {newMyMatch.stadiumName = value},
                validator: (value) =>
                    value.isNotEmpty ? null : ErrorsText.requiredErrorText,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Wybierz datę i czas rozpoczęcia meczu',
                  prefixIcon: Icon(Icons.date_range),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.datetime,
                controller: datetimeController,
                onSaved: (value) =>
                    {newMyMatch.datetimeMatch = DateTime.parse(value)},
                onTap: () => {showDateTimePicker(context)},
                key: ObjectKey('xd'),
                validator: (value) =>
                    value.isNotEmpty ? null : ErrorsText.requiredErrorText,
              ),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.fiber_manual_record),
                      labelText: 'Wybierz skład'),
                  items: squadsList,
                  value: 0,
                  onChanged: (value) {
                    newMyMatch.squadId = squads[value].id;
                  }),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
