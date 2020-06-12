import '../providers/employees.dart';
import '../providers/my_clubs.dart';
import '../providers/my_matches.dart';
import '../providers/players.dart';
import '../providers/sponsors.dart';
import '../widgets/club_management_drawer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinancesScreen extends StatefulWidget {
  static const routeName = '/finances';

  @override
  _FinancesScreenState createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen> {
  var _isLoading = false;
  var _isInit = false;
  var _sumOfMatchesRevenues = 0.0;

  void didChangeDependencies() async {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });

      final myClubsProvider = Provider.of<MyClubs>(context);
      final playersProvider = Provider.of<Players>(context);
      final employeesProvider = Provider.of<Employees>(context);
      final matchesProvider = Provider.of<MyMatches>(context);
      final sponsorsProvider = Provider.of<Sponsors>(context);
      final clubId = myClubsProvider.getActiveClub().id;

      await playersProvider.getAllPlayerFromClub(clubId);
      await employeesProvider.getAllEmployees(clubId);
      await sponsorsProvider.getAllSponsors(clubId);
      await matchesProvider.getSumOfRevenuesFromAllMatches(clubId);
      _sumOfMatchesRevenues =
          await matchesProvider.getSumOfRevenuesFromAllMatches(clubId);
      setState(() {
        _isLoading = false;
      });
    }

    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<Players>(context);
    final employeesProvider = Provider.of<Employees>(context);
    final sponsorsProvider = Provider.of<Sponsors>(context);

    var sumOfPlayersSalary = playersProvider.getSumOfPlayersSalary();
    var sumOfEmployeesSalary = employeesProvider.getSumOfEmployeesSalary();
    var sumOfSponsorsRevenues = sponsorsProvider.getSumOfRevenueFromSponsors();

    var sumOfExpenses = sumOfEmployeesSalary + sumOfPlayersSalary;
    var sumOfRevenues = _sumOfMatchesRevenues + sumOfSponsorsRevenues;

    final myClubsProvider = Provider.of<MyClubs>(context);
    final clubId = myClubsProvider.getActiveClub().id;

    var selectedClub = myClubsProvider.getActiveClub();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanse'),
      ),
      drawer: ClubManagementDrawer(),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Przychody: $sumOfRevenues\$',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Wydatki: $sumOfExpenses\$',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Stan: ${sumOfRevenues - sumOfExpenses}\$',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Majątek: ${selectedClub.fortune}\$',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sponsorzy: +$sumOfSponsorsRevenues\$',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Mecze: +$_sumOfMatchesRevenues\$',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Piłkarze: -$sumOfPlayersSalary\$',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Pracownicy: -$sumOfEmployeesSalary\$',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
