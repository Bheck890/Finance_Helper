import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String name;
  final int count;
  final Function onIncrement;
  final Function onDecrement;

  const AccountCard({
    Key? key,
    required this.name,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(name),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onDecrement();  // Call the decrement function passed as a prop
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
                    onIncrement();  // Call the increment function passed as a prop
                  },
                  child: Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
