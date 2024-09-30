// ignore_for_file: non_constant_identifier_names, unused_element

import 'package:finance_helper/Pages/NewData/new_account.dart';
import 'package:flutter/material.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key, required this.title});
  final String title;
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

  void _OpenAccount() {
    setState(() {
      _accountIndex++;
    });
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
