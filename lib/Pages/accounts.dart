// ignore_for_file: non_constant_identifier_names, unused_element

import 'package:finance_helper/Pages/NewData/new_account.dart';
import 'package:finance_helper/models/account.dart';
import 'package:finance_helper/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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

  late Future<List<Map<String, dynamic>>> _items;
  Map<int, int> itemCounts = {};  // Track counts for each item
  int _selectedAge = 0;
  int _selectedColor = 0;
  int _selectedBreed = 0;

  void _OpenAccount() {
    setState(() {
      _accountIndex++;
      _fetchItems();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchItems();
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

  Future<List<Map<String, dynamic>>> getItems(Database db) async {
    return await db.query('accounts');
  }

  void _fetchItems() {
    _items = _databaseService.accountsData();
    print('Fetching items...'); // Debugging
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _fetchItems();  // Manually trigger a refresh
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                int itemId = item['id'];  // Assuming your items have an 'id' field
                int count = itemCounts[itemId] ?? 0;  // Use a map to track counts for each item

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    title: Text(item['name']),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (count > 0) {
                                    itemCounts[itemId] = count - 1;
                                  }
                                });
                              },
                              child: Text('-'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                '$count',  // Show the count in the middle
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  itemCounts[itemId] = count + 1;
                                });
                              },
                              child: Text('+'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("Clicked");
          // Push to another page and wait for the result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewAccount()),
          );

          // Refresh the list after returning from the second page if needed
          if (result == 'refresh') {
            setState(() {
              _fetchItems();
            });
          }
          
          //Navigator.of(context).push(MaterialPageRoute( builder: (context) => const NewAccount()));
          // setState(() {
          //   _fetchItems();
          // });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _onAccountDelete(Account dog) async {
    await _databaseService.deleteAccount(dog.id!);
    setState(() {});
  }

  
}
