// ignore_for_file: use_build_context_synchronously

import 'dart:math';

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
        body: const NewAccount(
          name: "",
          description: "",
          total: "",
          id: 0,
          tableCode: "",
        ),
      ),
    );
  }
}

// Create a Form widget.
class NewAccount extends StatefulWidget {
  final String name;
  final String description;
  final String total;
  final int id;
  final String tableCode;

  const NewAccount({
    super.key,
    required this.name,
    required this.description,
    required this.total,
    required this.id,
    required this.tableCode,
  });
  
  //const NewAccount({super.key});

  @override
  NewAccountState createState() {
    // ignore: no_logic_in_create_state
    return NewAccountState(
      name: name,
      description: description,
      total: total,
      id: id,
      tableCode: tableCode,
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewAccountState extends State<NewAccount> {
  final String name;
  final String description;
  final String total;
  final int id;
  final String tableCode;

  NewAccountState({
    required this.name,
    required this.description,
    required this.total,
    required this.id,
    required this.tableCode,
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

  String generateHexCode() {
    final random = Random();
    final int randomValue = random.nextInt(0xFFFFFF);  // Generates a random value up to FFFFFF
    return randomValue.toRadixString(16).padLeft(8, '0').toUpperCase();
  }


  Future<void> _newSave() async {
    final hex = 'G${generateHexCode()}';
    final name = _nameText.text;
    final descript = _descText.text;
    final ammount = _ammountText.text;
    double balance = 0.0;
    
    try {
      balance = double.parse(ammount);
    } catch (e) {
        print('Invalid input string');
    }


    final DateTime now = DateTime.now();

    var number = double.parse(ammount);

    await _databaseService
        .insertAccount(
          Account(name: name, tableID: hex, description: descript, ammount: number), 
          Transact(name: "First Balance", description: "First Transaction", ammount: balance,
            sec: now.second, min: now.minute, hour: now.hour, day: now.day, month: now.month, year: now.year)
          );

    Navigator.pop(context, "refresh");
  }

  Future<void> _editSave() async {
    final name = _nameText.text;
    final descript = _descText.text;

    await _databaseService.updateAccount(id, name, descript);

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

    final bool _newMode = name.isEmpty;

    _nameText.text = name;
    _ammountText.text = total;
    _descText.text = description;

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: _newMode ? const Text('New Account Data') : const Text('Update Account Data'),
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
                  labelText: 'Account Name',
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
                  labelText: 'Account Description',
                  counterText: "",
                ),
              ),
            ),


            // The second text field is focused on when a user taps the
            // FloatingActionButton.
            
            _newMode ? 
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
                  labelText: 'Starting Ammount',
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
            )
            :
            const SizedBox(
              width: 200,
              height: 50,
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
                print("Add account ${name} - ${ammount}");

                if(_newMode) {
                  _newSave();
                } else {
                  _editSave();
                }
              },
              child: _newMode ? const Text('Create Account') : const Text('Update Account'),
            )
          ],
        ),
        ),
      ),
    );
  }
  
  
}