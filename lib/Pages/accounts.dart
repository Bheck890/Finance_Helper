// ignore_for_file: non_constant_identifier_names, unused_element

import 'package:finance_helper/Pages/NewData/new_account.dart';
import 'package:finance_helper/common_widgets/account_builder.dart';
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

  static final List<Account> _accounts = [];
  
  int _selectedAge = 0;
  int _selectedColor = 0;
  int _selectedBreed = 0;

  void _OpenAccount() {
    setState(() {
      _accountIndex++;
    });
  }



  Future<List<Account>> _getAccounts() async {
    final accounts = await _databaseService.accounts();
    if (_accounts.length == 0) 
      _accounts.addAll(accounts as Iterable<Account>);
    if (widget.account != null) {
      _selectedBreed = _accounts.indexWhere((e) => e.id == widget.account!.id);
    }
    return _accounts;
  }

  Future<List<Map<String, dynamic>>> getData() async {
    //final accounts = await _databaseService.accounts();
    var db = _databaseService;
    // Add debugging here to ensure the query is executed
    try {
      List<Map<String, dynamic>> result = await db.query('items');
      print('Fetched items: $result'); // Debugging
      return result;
    } catch (e) {
      print('Error fetching items: $e'); // Debugging
      return [];
    }
  }

  void _AddAccount() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewAccount()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
          return DataTable(
            columns: [
              DataColumn(label: Text("ID")),
              DataColumn(label: Text("Name")),
            ],
            rows: data
                .map((e) => DataRow(cells: [
                      DataCell(Text(e["id"].toString())),
                      DataCell(Text(e["name"])),
                    ]))
                .toList(),
          );
        }
      },
    );
  }

  Future<void> _onAccountDelete(Account dog) async {
    await _databaseService.deleteAccount(dog.id!);
    setState(() {});
  }

  
}
