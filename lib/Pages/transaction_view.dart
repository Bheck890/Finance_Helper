// ignore_for_file: non_constant_identifier_names, unused_element
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:finance_helper/Pages/NewData/new_transaction.dart';
import 'package:finance_helper/common_widgets/transaction_card.dart';
import 'package:finance_helper/models/transaction.dart';
import 'package:finance_helper/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class TransactionView extends StatefulWidget {
  final String accountNameID;
  final int accountID;

  const TransactionView({
    super.key,
    required this.accountNameID,
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
    accountNameID: accountNameID,
  );
}

class _TransactionViewState extends State<TransactionView> {
  final String accountNameID;
  final int accountID;

  _TransactionViewState({
    required this.accountNameID,
    required this.accountID,
  });

  final DatabaseService _databaseService = DatabaseService();
  //late ScrollController _scrollController;
  late Future<List<Map<String, dynamic>>> _items;//= List.generate(20, (index) => 'Item $index');;

  Map<int, int> accountElements = {};

  void _OpenAccount() {
    setState(() {
      _fetchItems();
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchItems();
    // _scrollController = ScrollController();
    // // Setting the scroll to start from the top
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });

  }

  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> getItems(Database db) async {
    return await db.query(accountNameID);
  }

  void _fetchItems() {
    _items = _databaseService.transactData(accountNameID);

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
            //final items = snapshot.data!;

            // Make a copy of the data to sort
            List<Map<String, dynamic>> transact = List<Map<String, dynamic>>.from(snapshot.data!);
            transact.sort((a, b) {
              DateTime dateA = DateTime(
                a['year'],
                a['month'],
                a['day'],
                a['hour'],
                a['min'],
                a['sec'],
              );

              DateTime dateB = DateTime(
                b['year'],
                b['month'],
                b['day'],
                b['hour'],
                b['min'],
                b['sec'],
              );

              return dateB.compareTo(dateA); // Ascending order
            });


            // Specify the generic type of the data in the list.
            return ImplicitlyAnimatedList<Map<String, dynamic>>(

              // The current items in the list.
              items: transact,
              // Called by the DiffUtil to decide whether two object represent the same item.
              // For example, if your items have unique ids, this method should check their id equality.
              areItemsTheSame: (a, b) => a['id'] == b['id'],
              // Called, as needed, to build list item widgets.
              // List items are only built when they're scrolled into view.
              itemBuilder: (context, animation, item, index) {
                final Map<String, dynamic> item = transact[index];

                int itemId = item['id'];
                String accountName = item['name'];
                String description = item['description'];
                double ammount = item['ammount'];
                //int count = accountElements[itemId] ?? 0;
                
                // Specifiy a transition to be used by the ImplicitlyAnimatedList.
                // See the Transitions section on how to import this transition.
                return SizeFadeTransition(
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  animation: animation,
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
                          tableName: accountNameID,
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
                  
                  //Text(item['name']),
                );
                
              },
              // An optional builder when an item was removed from the list.
              // If not specified, the List uses the itemBuilder with
              // the animation reversed.
              removeItemBuilder: (context, animation, oldItem) {
                return FadeTransition(
                  opacity: animation,
                  child: Text(oldItem['name']),
                );
              },
            );

            // return ListView.builder(
            //   //controller: _scrollController,
            //   itemCount: items.length,
            //   reverse: true,
            //   itemBuilder: (context, index) {
            //     final item = items[index];
            //     int itemId = item['id'];
            //     String accountName = item['name'];
            //     String description = item['description'];
            //     double ammount = item['ammount'];
            //     int count = accountElements[itemId] ?? 0;  // Use a map to track counts for each item
                
            //     // Use the Dismissible widget to wrap the ItemCard
            //     return Dismissible(
            //       key: Key(itemId.toString()),  // A unique key for each item
            //       direction: DismissDirection.endToStart,  // Swipe to the left to delete
            //       background: Container(
            //         color: Colors.red,
            //         alignment: Alignment.centerRight,
            //         padding: EdgeInsets.symmetric(horizontal: 20),
            //         child: Icon(Icons.delete, color: Colors.white),
            //       ),
            //       onDismissed: (direction) {
            //         _deleteItem(itemId);  // Call the delete function when swiped
            //       },
            //       child: TransactCard(
            //         name: accountName,  // Pass the item name
            //         description: description,
            //         total: ammount,        // Pass the count
            //         openEditAccount: () async {
            //           print("Clicked Edit Account $accountName");
            //           //Push to another page and wait for the result
            //           final result = await Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => NewTransaction(
            //               name: accountName,
            //               description: description,
            //               total: "$ammount",
            //               id: itemId,
            //               tableName: accountNameID,
            //               )),
            //           );

            //           // Refresh the list after returning from the second page if needed
            //           if (result == 'refresh') {
            //             setState(() {
            //               _fetchItems();
            //             });
            //           }
            //         },
            //         openTransactions: () {

            //           print("Opened Transacction Page $itemId");
                      
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(builder: (context) => TransactionsNavigation(
            //           //     name: accountName,
            //           //     id: itemId,
            //           //     )),
            //           // );                      
            //         },
            //       )
            //    );
            //     // Use the new ItemCard widget
                
            //   },
            // );
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
              tableName: accountNameID
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
    await _databaseService.deleteTransaction(accountNameID, id);  // Make sure you have a deleteItem method
    setState(() {
      _fetchItems();  // Refresh the item list after deletion
    });
  }

  
}

// extension on Future<List<Map<String, dynamic>>> {
//   void sort(int Function(dynamic a, dynamic b) param0) {

//   }
// }
