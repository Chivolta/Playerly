import 'package:flutter/material.dart';
import '../helpers/errors_text.dart';
import '../providers/my_clubs.dart';
import '../providers/timetables.dart';
import 'package:provider/provider.dart';
import '../providers/timetable.dart';

class AddTimetableScreen extends StatefulWidget {
  static const routeName = '/add-timetable';

  @override
  _AddTimetableScreenState createState() => _AddTimetableScreenState();
}

class _AddTimetableScreenState extends State<AddTimetableScreen> {
  final _form = GlobalKey<FormState>();

  var newTimetable = Timetable(
    id: '',
    name: '',
  );

  @override
  Widget build(BuildContext context) {
    final timetablesProvider = Provider.of<Timetables>(context);
    final clubsData = Provider.of<MyClubs>(context);
    final clubId = clubsData.getActiveClub().id;

    onSubmit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _form.currentState.save();
      timetablesProvider.addTimetable(newTimetable, clubId);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj nowy terminarz'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: Column(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nazwa terminarza',
                prefixIcon: Icon(Icons.description),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              onSaved: (value) => {newTimetable.name = value},
              validator: (value) =>
                  value.isNotEmpty ? null : ErrorsText.requiredErrorText,
            )
          ]),
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
