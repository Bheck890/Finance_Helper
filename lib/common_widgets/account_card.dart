import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String name;
  final String description;
  final int total;
  final Function openEditAccount;
  final Function openTransactions;

  const AccountCard({
    Key? key,
    required this.name,
    required this.description,
    required this.total,
    required this.openEditAccount,
    required this.openTransactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // Align items to the start (left)
          children: [
            Text(
              description,
              style: const TextStyle(fontSize: 14),  // You can adjust the font size if needed
            ),  // Display the description below the name
            const SizedBox(height: 10),  // Add some spacing between the description and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    openTransactions();  // Call the decrement function passed as a prop
                  },
                  child: const Text('Transactions'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '$total',  // Show the count in the middle
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    openEditAccount();  // Call the increment function passed as a prop
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
