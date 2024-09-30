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
        body: const NewAccount(),
      ),
    );
  }
}

// Create a Form widget.
class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  NewAccountState createState() {
    return NewAccountState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewAccountState extends State<NewAccount> {
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

  late FocusNode myFocusNode;

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
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account Data'),
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
                  return;
                }

                // ignore: avoid_print
                print("Add account ${name} - ${ammount}");
              },
              child: const Text('Create Account'),
            )
          ],
        ),
        ),
      ),
    );
  }
}