import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _goalsConcededFocusNode = FocusNode();
  final _revenueFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    final myMatchesProvider = Provider.of<MyMatches>(context);
    final clubsProvider = Provider.of<MyClubs>(context);
    final timetablesProvider = Provider.of<Timetables>(context);

    final selectedMyMatch = myMatchesProvider.getSelectedMyMatch();
    final selectedMyClub = clubsProvider.getActiveClub();
    final selectedTimetable = timetablesProvider.getSelectedTimetable();

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

      myMatchesProvider.getAllMatchesFromTimetable(
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
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_goalsConcededFocusNode),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
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
              focusNode: _goalsConcededFocusNode,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_revenueFocusNode),
              onSaved: (value) =>
                  {selectedMyMatchCopy.opponentGoals = int.parse(value)},
              validator: (value) =>
                  value.isNotEmpty ? null : ErrorsText.requiredErrorText,
            ),
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money), labelText: 'Przychód'),
              textInputAction: TextInputAction.done,
              focusNode: _revenueFocusNode,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
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
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
