import 'package:finance_helper/Pages/accounts.dart';
import 'package:finance_helper/Pages/settings.dart';
import 'package:finance_helper/Pages/transactions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanace Checker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FinanceNavigation(title: 'Dashboard'),
    );
  }
}

class FinanceNavigation extends StatefulWidget {
  const FinanceNavigation({super.key, required this.title});

  final String title;

  @override
  State<FinanceNavigation> createState() => _FinanceNavigationState();
}

class _FinanceNavigationState extends State<FinanceNavigation> {
  int currentPageIndex = 0;



  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
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
            label: 'Accounts',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.settings),
            ),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        /// Account page
        const Accounts(title: 'Add Accounts'),

        /// Settings page
        const Settings(),
      ][currentPageIndex],
    );
  }
}