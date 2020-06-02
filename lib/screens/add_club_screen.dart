import '../helpers/functions.dart';

import '../providers/sponsor.dart';
import 'package:flutter/material.dart';
import '../helpers/errors_text.dart';
import '../providers/my_club.dart';
import '../providers/my_clubs.dart';
import 'package:provider/provider.dart';

class AddClubScreen extends StatefulWidget {
  static const routeName = '/add-club';

  @override
  _AddClubScreenState createState() => _AddClubScreenState();
}

class _AddClubScreenState extends State<AddClubScreen> {
  final _form = GlobalKey<FormState>();

  var newClub = MyClub(
    id: '',
    name: '',
    owner: '',
    reveneus: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expenses: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    fortune: 0,
  );

  List<Sponsor> newSponsors = [];

  get currentMonthName {
    return DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    final myClubsProvider = Provider.of<MyClubs>(context);

    addSponsor() {
      setState(() {
        newSponsors.add(Sponsor(
          id: Functions.generateId(),
          name: '',
          revenue: 0.0,
        ));
      });
    }

    removeSponsor(index) {
      setState(() {
        newSponsors.removeAt(index);
      });
    }

    onSubmit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _form.currentState.save();
      myClubsProvider.addMyClub(newClub, newSponsors, context);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj nowy klub'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nazwa klubu',
                    prefixIcon: Icon(Icons.question_answer),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onSaved: (value) => {newClub.name = value},
                  validator: (value) =>
                      value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Zarządzca klubu',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onSaved: (value) => {newClub.owner = value},
                  validator: (value) =>
                      value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money),
                      labelText: 'Majątek klubu'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) => {newClub.fortune = double.parse(value)},
                  validator: (value) =>
                      value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Sponsorzy",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => addSponsor(),
                          ),
                        ],
                      ),
                      ...newSponsors
                          .asMap()
                          .map((i, element) => MapEntry(
                                i,
                                Dismissible(
                                  key: Key(element.id),
                                  onDismissed: (_) => {removeSponsor(i)},
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Nazwa sponsora'),
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        onSaved: (value) =>
                                            {newSponsors[i].name = value},
                                        validator: (value) => value.isNotEmpty
                                            ? null
                                            : ErrorsText.requiredErrorText,
                                      ),
                                      Container(
                                        width: 300,
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.attach_money),
                                              labelText:
                                                  'Przychody miesięczne'),
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          validator: (value) => value.isNotEmpty
                                              ? null
                                              : ErrorsText.requiredErrorText,
                                          onSaved: (value) => {
                                            newSponsors[i].revenue =
                                                double.parse(value)
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .values
                          .toList()
                    ],
                  ),
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
