import 'package:flutter/material.dart';
import '../widgets/club_management_drawer.dart';

class ClubManagementScreen extends StatelessWidget {
  static const routeName = '/club-management';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podsumowanie'),
      ),
      drawer: ClubManagementDrawer(),
      body: Text('test'),
    );
  }
}
