import 'package:flutter/material.dart';
import 'package:playerly/providers/players.dart';
import 'package:playerly/providers/squads.dart';
import 'package:playerly/screens/add_club_screen.dart';
import 'package:playerly/screens/add_employee_screen.dart';
import 'package:playerly/screens/add_match_screen.dart';
import 'package:playerly/screens/add_player_screen.dart';
import 'package:playerly/screens/add_squad_screen.dart';
import 'package:playerly/screens/club_management_screen.dart';
import 'package:playerly/screens/employees_screen.dart';
import 'package:playerly/screens/finances_screen.dart';
import 'package:playerly/screens/players_screen.dart';
import 'package:playerly/screens/show_squad_screen.dart';
import 'package:playerly/screens/squads_screen.dart';
import 'package:playerly/screens/timetable_screen.dart';
import 'package:playerly/widgets/club_lists.dart';
import 'package:playerly/widgets/no_created_any_club.dart';

import './providers/my_clubs.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MyClubs(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Players(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Squads(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Playerly'),
        routes: {
          AddClubScreen.routeName: (ctx) => AddClubScreen(),
          AddEmployeeScreen.routeName: (ctx) => AddEmployeeScreen(),
          AddMatchScreen.routeName: (ctx) => AddMatchScreen(),
          AddPlayerScreen.routeName: (ctx) => AddPlayerScreen(),
          AddSquadScreen.routeName: (ctx) => AddSquadScreen(),
          ClubManagementScreen.routeName: (ctx) => ClubManagementScreen(),
          EmployeesScreen.routeName: (ctx) => EmployeesScreen(),
          FinancesScreen.routeName: (ctx) => FinancesScreen(),
          PlayersScreen.routeName: (ctx) => PlayersScreen(),
          SquadsScreen.routeName: (ctx) => SquadsScreen(),
          TimetableScreen.routeName: (ctx) => TimetableScreen(),
          ShowSquadScreen.routeName: (ctx) => ShowSquadScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  static const routeName = '/';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final myClubsData = Provider.of<MyClubs>(context);
    final myClubs = myClubsData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Zarządzane kluby'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddClubScreen.routeName),
          )
        ],
      ),
      body: myClubs.length > 0 ? ClubLists() : NoCreatedAnyClub(),
    );
  }
}
