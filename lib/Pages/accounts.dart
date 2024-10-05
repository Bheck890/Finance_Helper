// ignore_for_file: non_constant_identifier_names, unused_element

import 'package:finance_helper/Pages/NewData/new_account.dart';
import 'package:finance_helper/models/account.dart';
import 'package:finance_helper/services/database_service.dart';
import 'package:flutter/material.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key, required this.title, this.account});
  final String title;
  final Account? account;
  
  get id => null;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: const Text('Next'),
        ),
      ),
    );
  }
  
  @override
  State<StatefulWidget> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  int _accountIndex = 0;

  final DatabaseService _databaseService = DatabaseService();

  static final List<Accounts> _accounts = [];

  int _selectedAge = 0;
  int _selectedColor = 0;
  int _selectedBreed = 0;

  void _OpenAccount() {
    setState(() {
      _accountIndex++;
    });
  }

  Future<List<Accounts>> _getAccounts() async {
    final accounts = await _databaseService.accounts();
    if (_accounts.length == 0) _accounts.addAll(accounts as Iterable<Accounts>);
    if (widget.account != null) {
      _selectedBreed = _accounts.indexWhere((e) => e.id == widget.account!.id);
    }
    return _accounts;
  }

  void _AddAccount() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewAccount()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListTile Sample')),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  //leading: const Icon(Icons.notifications_sharp),
                  title: const Text('Account 1'),
                  subtitle: Text('This is a notification $_accountIndex'),
                  onTap: () {_OpenAccount();},
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // ignore: avoid_print
            print("Clicked");
            Navigator.of(context).push(MaterialPageRoute( builder: (context) => const NewAccount()));
          },
          tooltip: 'Add Account',
          child: const Icon(Icons.add),
      ),
    );
  }

  
}
