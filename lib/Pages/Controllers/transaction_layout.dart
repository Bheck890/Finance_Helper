import 'package:finance_helper/Pages/account_settings.dart';
import 'package:finance_helper/Pages/transactions.dart';
import 'package:flutter/material.dart';

class TransactionsNavigation extends StatefulWidget {
  final String name;
  final int id;

  const TransactionsNavigation({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  State<TransactionsNavigation> createState() => _TransactionsNavigationState(
    name: name,
    id: id);
}

class _TransactionsNavigationState extends State<TransactionsNavigation> {
  final String name;
  final int id;

  _TransactionsNavigationState({
    required this.name,
    required this.id,
  });
  
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    print("Opened Transacction For $id");
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.account_box),
            label: 'Transactions',
          ),
          // NavigationDestination(
          //   icon: Badge(child: Icon(Icons.settings),
          //   ),
          //   label: 'Stats',
          // ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.settings),
            ),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        /// Account page
        const Transactions(title: 'Transactions'),
        //const Settings(),
        /// Settings page
        const Settings(),
      ][currentPageIndex],
    );
  }
}