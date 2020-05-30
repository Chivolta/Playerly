import 'package:flutter/material.dart';
import 'package:playerly/widgets/club_management_drawer.dart';

class FinancesScreen extends StatelessWidget {
  static const routeName = '/finances';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanse'),
      ),
      drawer: ClubManagementDrawer(),
      body: Text('test'),
    );
  }
}