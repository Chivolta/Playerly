import 'package:com.playerly/helpers/errors_text.dart';
import 'package:flutter/services.dart';

import '../providers/my_clubs.dart';
import '../providers/employee.dart';
import '../providers/employees.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatefulWidget {
  static const routeName = '/add-employee';

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _form = GlobalKey<FormState>();
  final _surnameFocusNode = FocusNode();
  final _positionFocusNode = FocusNode();
  final _salaryFocusNode = FocusNode();
  var _isLoading = false;

  var newEmployee = Employee(
    id: '',
    name: '',
    surname: '',
    position: '',
    salary: 0,
  );

  @override
  Widget build(BuildContext context) {
    final clubsProvider = Provider.of<MyClubs>(context);
    final employeesProvider = Provider.of<Employees>(context);
    final clubId = clubsProvider.getActiveClub().id;

    onSubmit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _isLoading = true;
      _form.currentState.save();
      employeesProvider.addEmployee(newEmployee, clubId).then((value) {
        _isLoading = false;
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj pracownika'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Imię',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_surnameFocusNode),
                      onSaved: (value) => {newEmployee.name = value},
                      validator: (value) => value.isNotEmpty
                          ? null
                          : ErrorsText.requiredErrorText,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nazwisko',
                        prefixIcon: Icon(Icons.description),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _surnameFocusNode,
                      keyboardType: TextInputType.text,
                      onSaved: (value) => {newEmployee.surname = value},
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_positionFocusNode),
                      validator: (value) => value.isNotEmpty
                          ? null
                          : ErrorsText.requiredErrorText,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.work),
                          labelText: 'Stanowisko'),
                      textInputAction: TextInputAction.next,
                      focusNode: _positionFocusNode,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_salaryFocusNode),
                      onSaved: (value) => {newEmployee.position = value},
                      validator: (value) => value.isNotEmpty
                          ? null
                          : ErrorsText.requiredErrorText,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.fingerprint),
                          labelText: 'Zarobki miesięczne'),
                      initialValue: newEmployee.salary.toString(),
                      focusNode: _salaryFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      onSaved: (value) =>
                          {newEmployee.salary = double.parse(value)},
                      validator: (value) => value.isNotEmpty
                          ? null
                          : ErrorsText.requiredErrorText,
                    ),
                  ],
                )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
