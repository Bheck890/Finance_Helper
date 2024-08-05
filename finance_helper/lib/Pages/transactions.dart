// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key, required this.title});
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
  State<StatefulWidget> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  int _transactionIndex = 0;

  void _OpenTransaction() {
    setState(() {
      _transactionIndex++;
    });
  }

  void _AddTransaction() {
    setState(() {
      _transactionIndex++;
    });
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
                  title: const Text('Transaction 1'),
                  subtitle: Text('This is a notification $_transactionIndex'),
                  onTap: () {_OpenTransaction();},
                ),
              ),
              Card(
                child: ListTile(
                  //leading: const Icon(Icons.notifications_sharp),
                  title: const Text('Transaction 2'),
                  subtitle: const Text('This is a notification'),
                  onTap: () {_OpenTransaction();},
                ),
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _AddTransaction,
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}