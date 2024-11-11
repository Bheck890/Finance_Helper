// ignore_for_file: use_build_context_synchronously

import 'package:finance_helper/models/account.dart';
import 'package:finance_helper/models/transaction.dart';
import 'package:finance_helper/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Adding account';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const NewTransaction(
          name: "",
          description: "",
          total: "",
          id: 0,
          tableName: "",
        ),
      ),
    );
  }
}

// Create a Form widget.
class NewTransaction extends StatefulWidget {
  final String tableName;
  final String name;
  final String description;
  final String total;
  final int id;

  const NewTransaction({
    super.key,
    required this.name,
    required this.description,
    required this.total,
    required this.id,
    required this.tableName
  });

  @override
  NewTransactionState createState() {
    // ignore: no_logic_in_create_state
    return NewTransactionState(
      name: name,
      description: description,
      total: total,
      id: id, 
      accountID: tableName,
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewTransactionState extends State<NewTransaction> {
  final String name;
  final String description;
  final String total;
  final int id;
  final String accountID;

  NewTransactionState({
    required this.name,
    required this.description,
    required this.total,
    required this.id,
    required this.accountID
  });
  

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  //final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _nameText = TextEditingController();
  final _ammountText = TextEditingController();
  final _descText = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  
  late FocusNode myFocusNode;


  Future<void> _newTransact() async {
    final transactName = _nameText.text;
    final transactDescript = _descText.text;
    final ammount = _ammountText.text;
    double balance = 0.0;
    
    try {
      balance = double.parse(ammount);
    } catch (e) {
        print('Invalid input string');
    }
    
    final DateTime now = DateTime.now();

    //var number = double.parse(ammount);

    await _databaseService
        .insertTransact(
          Transact(name: transactName, description: transactDescript, ammount: balance,
          sec: now.second, min: now.minute, hour: now.hour, day: now.day, month: now.month, year: now.year), table: accountID);

    Navigator.pop(context, "refresh");
  }

  Future<void> _editTransact() async {
    final name = _nameText.text;
    final descript = _descText.text;
    final ammount = _ammountText.text;
    double balance = 0.0;
    
    try {
      balance = double.parse(ammount);
    } catch (e) {
        print('Invalid input string');
    }
    
    await _databaseService.updateTransact(id, name, descript, balance, accountID);

    Navigator.pop(context, "refresh");
  }


  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final bool newMode = name.isEmpty;

    _nameText.text = name;
    _ammountText.text = total;
    _descText.text = description;

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: newMode ? const Text('New Transaction Data') : const Text('Update Transaction Data'),
        automaticallyImplyLeading: false,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(

        child: Column(
          
          children: [
            // The first text field is focused on as soon as the app starts.
            SizedBox(
              width: 200,
              height: 100,
              child: TextField(
              
                maxLength: 20,
                autofocus: true,
                controller: _nameText,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Transaction Name',
                  counterText: "",
                ),
              ),
            ),

            SizedBox(
              width: 200,
              height: 150,
              child: TextField(
                maxLines: 3,
                maxLength: 20,
                autofocus: true,
                controller: _descText,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Transaction Description',
                  counterText: "",
                ),
              ),
            ),


            // The second text field is focused on when a user taps the
            // FloatingActionButton.
            
            SizedBox(
              width: 200,
              height: 50,
              
              child: TextField(
                controller: _ammountText,
                maxLength: 16,
                // keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],  
                //inputFormatters: [DecimalTextInputFormatter(decimalRange: 1)],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Transaction Ammount',
                  prefix: Text(
                    "\$",
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  prefixStyle: TextStyle(),
                  counterText: "",
                ),
                focusNode: myFocusNode,

              ),
            ),

            const SizedBox(
              width: 200,
              height: 50,
            ),


            TextButton(
              //padding: const EdgeInsets.symmetric(horizontal: 16),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 43, 9, 235),
                foregroundColor: const Color.fromARGB(255, 208, 217, 224), 
                disabledForegroundColor: Colors.red.withOpacity(0.38),
              ),
              onPressed: () { 

                String name = _nameText.text;
                String ammount = _ammountText.text;
                if(name.isEmpty || ammount.isEmpty)
                {
                  print("Invalid Input");
                  //TODO: Add Invalid Message

                  return;
                }

                // ignore: avoid_print
                print("Add Transaction ${name} - ${ammount}");

                if(newMode) {
                  _newTransact();
                } else {
                  _editTransact();
                }
              },
              child: newMode ? const Text('Create Transaction') : const Text('Update Transaction'),
            )
          ],
        ),
        ),
      ),
    );
  }
  
  
}