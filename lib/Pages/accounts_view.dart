// ignore_for_file: non_constant_identifier_names, unused_element
import 'package:finance_helper/Pages/Controllers/transaction_layout.dart';
import 'package:finance_helper/Pages/NewData/new_account.dart';
import 'package:finance_helper/models/account.dart';
import 'package:finance_helper/common_widgets/account_card.dart';
import 'package:finance_helper/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({super.key, required this.title, this.account});
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
  State<StatefulWidget> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  final DatabaseService _databaseService = DatabaseService();

  late Future<List<Map<String, dynamic>>> _items;
  Map<int, int> accountElements = {};  // Track counts for each item

  void _OpenAccount() {
    setState(() {
      _fetchItems();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<List<Map<String, dynamic>>> getItems(Database db) async {
    return await db.query('accounts');
  }

  void _fetchItems() {
    _items = _databaseService.accountsData();
    // ignore: avoid_print
    print('Fetching items...'); // Debugging
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                int itemId = item['id']; 
                String accountName = item['name'];
                String description = item['description'];
                double ammount = item['ammount'];
                String accountID = item['tableID'];
                int count = accountElements[itemId] ?? 0;  // Use a map to track counts for each item
                
                // Use the Dismissible widget to wrap the ItemCard
                return Dismissible(
                  key: Key(itemId.toString()),  // A unique key for each item
                  direction: DismissDirection.endToStart,  // Swipe to the left to delete
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteItem(itemId);  // Call the delete function when swiped
                  },
                  child: AccountCard(
                    name: accountName,  // Pass the item name
                    description: description,
                    total: ammount,        // Pass the count
                    openEditAccount: () async {
                      print("Clicked Edit Account $accountName");
                      // Push to another page and wait for the result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewAccount(
                          name: accountName,
                          description: description,
                          total: "$ammount",
                          id: itemId,
                          tableCode: accountID,
                          )),
                      );

                      // Refresh the list after returning from the second page if needed
                      if (result == 'refresh') {
                        setState(() {
                          _fetchItems();
                        });
                      }
                    },
                    openTransactions: () {

                      print("Opened Transacction Page $itemId");
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TransactionsNavigation(
                          name: accountID,
                          id: itemId,
                          )),
                      );                      
                    },
                  )
               );
                // Use the new ItemCard widget
                
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          print("New Account Clicked");
          // Push to another page and wait for the result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewAccount(
              name: "",
              description: "",
              total: "",
              id: 0,
              tableCode: "")),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onAccountDelete(Account dog) async {
    await _databaseService.deleteAccount(dog.id!);
    setState(() {});
  }
  
  // Function to delete an item from the database
  void _deleteItem(int id) async {
    await _databaseService.deleteAccount(id);  // Make sure you have a deleteItem method
    setState(() {
      _fetchItems();  // Refresh the item list after deletion
    });
  }

  
}
