import 'package:flutter/material.dart';
import '../widgets/club_management_drawer.dart';

class EmployeesScreen extends StatelessWidget {
  static const routeName = '/employees';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pracownicy'),
      ),
      drawer: ClubManagementDrawer(),
      body: Text('test'),
    );
  }
}
