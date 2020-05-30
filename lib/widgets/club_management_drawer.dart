import 'package:flutter/material.dart';
import 'package:playerly/screens/club_management_screen.dart';
import 'package:playerly/screens/employees_screen.dart';
import 'package:playerly/screens/finances_screen.dart';
import 'package:playerly/screens/players_screen.dart';
import 'package:playerly/screens/squads_screen.dart';
import 'package:playerly/screens/timetable_screen.dart';

class ClubManagementDrawer extends StatelessWidget {
  void navigateToScreen(context, routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            color: Colors.purple,
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Podsumowanie'),
            onTap: () =>
                {navigateToScreen(context, ClubManagementScreen.routeName)},
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Zawodnicy'),
            onTap: () => {navigateToScreen(context, PlayersScreen.routeName)},
          ),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text('Pracownicy'),
            onTap: () => {navigateToScreen(context, EmployeesScreen.routeName)},
          ),
          ListTile(
            leading: Icon(Icons.view_module),
            title: Text('Składy'),
            onTap: () => {navigateToScreen(context, SquadsScreen.routeName)},
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Terminarz'),
            onTap: () => {navigateToScreen(context, TimetableScreen.routeName)},
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Finanse'),
            onTap: () => {navigateToScreen(context, FinancesScreen.routeName)},
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Wybór klubów'),
            onTap: () =>
                {Navigator.of(context).popUntil(ModalRoute.withName('/'))},
          )
        ],
      ),
    );
  }
}
