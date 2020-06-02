import './providers/sponsors.dart';
import 'package:flutter/material.dart';
import './providers/my_matches.dart';
import './providers/player_matches_statistics.dart';
import './providers/players.dart';
import './providers/squads.dart';
import './providers/timetables.dart';
import './screens/add_club_screen.dart';
import './screens/add_employee_screen.dart';
import './screens/add_my_match_screen.dart';
import './screens/add_player_screen.dart';
import './screens/add_squad_screen.dart';
import './screens/club_management_screen.dart';
import './screens/employees_screen.dart';
import './screens/end_match_screen.dart';
import './screens/finances_screen.dart';
import './screens/match_description_screen.dart';
import './screens/my_matches_screen.dart';
import './screens/players_screen.dart';
import './screens/show_squad_screen.dart';
import './screens/squads_screen.dart';
import './screens/timetables_screen.dart';
import './widgets/club_lists.dart';
import './widgets/no_created_any_club.dart';

import './providers/my_clubs.dart';
import 'package:provider/provider.dart';

import 'screens/add_timetable_screen.dart';

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
        ChangeNotifierProvider(
          create: (ctx) => Timetables(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MyMatches(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PlayerMatchesStatistics(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Sponsors(),
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
          AddMyMatchScreen.routeName: (ctx) => AddMyMatchScreen(),
          AddPlayerScreen.routeName: (ctx) => AddPlayerScreen(),
          AddSquadScreen.routeName: (ctx) => AddSquadScreen(),
          AddTimetableScreen.routeName: (ctx) => AddTimetableScreen(),
          ClubManagementScreen.routeName: (ctx) => ClubManagementScreen(),
          EmployeesScreen.routeName: (ctx) => EmployeesScreen(),
          FinancesScreen.routeName: (ctx) => FinancesScreen(),
          PlayersScreen.routeName: (ctx) => PlayersScreen(),
          SquadsScreen.routeName: (ctx) => SquadsScreen(),
          TimetablesScreen.routeName: (ctx) => TimetablesScreen(),
          ShowSquadScreen.routeName: (ctx) => ShowSquadScreen(),
          MyMatchesScreen.routeName: (ctx) => MyMatchesScreen(),
          MatchDescriptionScreen.routeName: (ctx) => MatchDescriptionScreen(),
          EndMatchScreen.routeName: (ctx) => EndMatchScreen()
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
  void didChangeDependencies() {
    final myClubsData = Provider.of<MyClubs>(context);
    myClubsData.getAllClubs();
    super.didChangeDependencies();
  }

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
