import 'package:flutter/material.dart';
import '../providers/timetables.dart';
import '../providers/my_clubs.dart';
import '../helpers/errors_text.dart';
import '../providers/my_match.dart';
import '../providers/my_matches.dart';
import 'package:provider/provider.dart';

class EndMatchScreen extends StatefulWidget {
  static const routeName = '/end-match-screen';
  @override
  _EndMatchScreenState createState() => _EndMatchScreenState();
}

class _EndMatchScreenState extends State<EndMatchScreen> {
  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    final myMatchesProvider = Provider.of<MyMatches>(context, listen: false);
    final clubsProvider = Provider.of<MyClubs>(context, listen: false);
    final timetableProvider = Provider.of<Timetables>(context, listen: false);

    final selectedMyMatch = myMatchesProvider.getSelectedMyMatch();
    final selectedMyClub = clubsProvider.getActiveClub();
    final selectedTimetable = timetableProvider.getSelectedTimetable();

    MyMatch selectedMyMatchCopy = MyMatch(
      id: selectedMyMatch.id,
      datetimeMatch: selectedMyMatch.datetimeMatch,
      squadId: selectedMyMatch.squadId,
      stadiumName: selectedMyMatch.stadiumName,
      isEnd: selectedMyMatch.isEnd,
      opponentName: selectedMyMatch.opponentName,
    );

    onSubmit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _form.currentState.save();
      selectedMyMatchCopy.isEnd = true;
      myMatchesProvider.updateMatch(
        selectedMyClub.id,
        selectedTimetable.id,
        selectedMyMatchCopy.id,
        selectedMyMatchCopy,
      );

      final clubsProvider = Provider.of<MyClubs>(context, listen: false);
      final timetablesProvider =
          Provider.of<Timetables>(context, listen: false);
      final matchesProvider = Provider.of<MyMatches>(context, listen: false);
      matchesProvider.getAllMatchesFromTimetable(
          clubsProvider.getActiveClub().id,
          timetablesProvider.getSelectedTimetable().id);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Zakończ mecz z ${selectedMyMatch.opponentName}'),
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.add), labelText: 'Strzelone gole'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSaved: (value) =>
                  {selectedMyMatchCopy.ourGoals = int.parse(value)},
              validator: (value) =>
                  value.isNotEmpty ? null : ErrorsText.requiredErrorText,
            ),
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.remove), labelText: 'Stracone gole'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSaved: (value) =>
                  {selectedMyMatchCopy.opponentGoals = int.parse(value)},
              validator: (value) =>
                  value.isNotEmpty ? null : ErrorsText.requiredErrorText,
            ),
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money), labelText: 'Przychód'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSaved: (value) =>
                  {selectedMyMatchCopy.revenue = double.parse(value)},
              validator: (value) =>
                  value.isNotEmpty ? null : ErrorsText.requiredErrorText,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
