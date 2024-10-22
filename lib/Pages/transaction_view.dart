// ignore_for_file: non_constant_identifier_names, unused_element
import 'package:finance_helper/Pages/NewData/new_transaction.dart';
import 'package:finance_helper/common_widgets/transaction_card.dart';
import 'package:finance_helper/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class TransactionView extends StatefulWidget {
  final String accountName;
  final int accountID;

  const TransactionView({
    super.key,
    required this.accountName,
    required this.accountID,
  });
  
  
  get id => null;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
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
  State<StatefulWidget> createState() => _TransactionViewState(
    accountID: accountID,
    accountName: accountName,
  );
}

class _TransactionViewState extends State<TransactionView> {
  final String accountName;
  final int accountID;

  _TransactionViewState({
    required this.accountName,
    required this.accountID,
  });


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
    return await db.query(accountName);
  }

  void _fetchItems() {
    _items = _databaseService.transactData(accountName);
    // ignore: avoid_print
    print('Fetching items...'); // Debugging
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
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
                  child: TransactCard(
                    name: accountName,  // Pass the item name
                    description: description,
                    total: ammount,        // Pass the count
                    openEditAccount: () async {
                      print("Clicked Edit Account $accountName");
                      //Push to another page and wait for the result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewTransaction(
                          name: accountName,
                          description: description,
                          total: "$ammount",
                          id: itemId,
                          tableName: accountName,
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
                      
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => TransactionsNavigation(
                      //     name: accountName,
                      //     id: itemId,
                      //     )),
                      // );                      
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

          print("New Transaction Clicked");
          // Push to another page and wait for the result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTransaction(
              name: "",
              description: "",
              total: "",
              id: 0,
              tableName: accountName
              )),
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
  
  // Function to delete an item from the database
  void _deleteItem(int id) async {
    await _databaseService.deleteTransaction(accountName, id);  // Make sure you have a deleteItem method
    setState(() {
      _fetchItems();  // Refresh the item list after deletion
    });
  }

  
}
