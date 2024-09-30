import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            // The first text field is focused on as soon as the app starts.
            const TextField(
              autofocus: true,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Account Name',
              ),
            ),
            Container(
                width: 50,
                height: 20,
                //color: Colors.red,
              ),
            // The second text field is focused on when a user taps the
            // FloatingActionButton.
            TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Starting Ammount',
              ),
              focusNode: myFocusNode,
              
            ),

            Container(
                width: 50,
                height: 20,
              ),

            TextButton(
              //padding: const EdgeInsets.symmetric(horizontal: 16),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 43, 9, 235),
                foregroundColor: const Color.fromARGB(255, 208, 217, 224), 
                disabledForegroundColor: Colors.red.withOpacity(0.38),
              ),
              onPressed: () { 
                // ignore: avoid_print
                print("Add account");
              },
              child: const Text('Create Account'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the button is pressed,
        // give focus to the text field using myFocusNode.
        onPressed: () => {
          myFocusNode.requestFocus()
        },
        tooltip: 'Focus Second Text Field',
        child: const Icon(Icons.edit),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}