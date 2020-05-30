import 'package:flutter/material.dart';
import 'package:playerly/screens/add_club_screen.dart';

class NoCreatedAnyClub extends StatelessWidget {
  void addClub(context) {
    Navigator.of(context).pushNamed(AddClubScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Nie masz jeszcze żadnego klubu, którym zarządzasz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Naciśnij przycisk poniżej, aby dodać nowy klub',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () => addClub(context),
                ),
              ))
        ],
      ),
    );
  }
}
