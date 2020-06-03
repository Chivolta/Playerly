import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatelessWidget {
  static const routeName = '/add-employee';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj pracownika'),
      ),
    );
  }
}
