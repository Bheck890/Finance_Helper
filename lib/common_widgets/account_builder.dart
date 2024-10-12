import 'package:finance_helper/models/account.dart';
import 'package:flutter/material.dart';
import 'package:finance_helper/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountBuilder extends StatelessWidget {
  const AccountBuilder({
    Key? key,
    required this.future,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);
  final Future<List<Account>> future;
  final Function(Account) onEdit;
  final Function(Account) onDelete;

  Future<String> getAccountName(int id) async {
    final DatabaseService _databaseService = DatabaseService();
    final accnt = await _databaseService.account(id);
    return accnt.name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final accnt = snapshot.data![index];
              return _buildDogCard(accnt, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildDogCard(Account accnt, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: FaIcon(FontAwesomeIcons.dog, size: 18.0),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accnt.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: getAccountName(accnt.id!),
                    builder: (context, snapshot) {
                      return Text('Name: ${snapshot.data}');
                    },
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('Description: ${accnt.description.toString()}, Color: '),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(accnt),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.edit, color: Colors.orange[800]),
              ),
            ),
            SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onDelete(accnt),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.delete, color: Colors.red[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
