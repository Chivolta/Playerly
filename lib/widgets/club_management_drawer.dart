import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';
import '../screens/sponsors_screen.dart';
import '../screens/club_management_screen.dart';
import '../screens/employees_screen.dart';
import '../screens/finances_screen.dart';
import '../screens/players_screen.dart';
import '../screens/squads_screen.dart';
import '../screens/timetables_screen.dart';

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
            padding: const EdgeInsets.all(20),
            child: const Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Podsumowanie'),
            onTap: () =>
                {navigateToScreen(context, ClubManagementScreen.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Zawodnicy'),
            onTap: () => {navigateToScreen(context, PlayersScreen.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Pracownicy'),
            onTap: () => {navigateToScreen(context, EmployeesScreen.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.view_module),
            title: const Text('Składy'),
            onTap: () => {navigateToScreen(context, SquadsScreen.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Terminarze'),
            onTap: () =>
                {navigateToScreen(context, TimetablesScreen.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Finanse'),
            onTap: () => {navigateToScreen(context, FinancesScreen.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Sponsorzy'),
            onTap: () => {navigateToScreen(context, SponsorsScreen.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ustawienia'),
            onTap: () => {navigateToScreen(context, SettingsScreen.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Wybór klubów'),
            onTap: () =>
                {Navigator.of(context).popUntil(ModalRoute.withName('/'))},
          )
        ],
      ),
    );
  }
}
