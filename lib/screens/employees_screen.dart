import 'package:com.playerly/providers/employee.dart';
import 'package:com.playerly/providers/employees.dart';
import 'package:com.playerly/providers/my_clubs.dart';
import 'package:provider/provider.dart';

import '../screens/add_employee_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/club_management_drawer.dart';

class EmployeesScreen extends StatefulWidget {
  static const routeName = '/employees';

  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });
      final employeesProvider = Provider.of<Employees>(context);
      final clubsProvider = Provider.of<MyClubs>(context);
      var clubId = clubsProvider.getActiveClub().id;

      employeesProvider.getAllEmployees(clubId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeesProvider = Provider.of<Employees>(context);
    List<Employee> employees = employeesProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pracownicy'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddEmployeeScreen.routeName),
          )
        ],
      ),
      drawer: ClubManagementDrawer(),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: employees[i],
                  child: InkWell(
                    child: Card(
                      // elevation: 10,
                      margin: const EdgeInsets.all(1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                '${(i + 1).toString()}. ${employees[i].name} ${employees[i].surname}, Stanowisko: ${employees[i].position}'),
                          ],
                        ),
                      ),
                    ),
                    onTap: () => {},
                    hoverColor: Colors.purple,
                    focusColor: Colors.purple,
                    splashColor: Colors.purple,
                  )),
            ),
    );
  }
}
