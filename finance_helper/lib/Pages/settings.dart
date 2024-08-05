import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
 
  void know() {
    // ignore: avoid_print
    print("Button Pressed");
  }
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GeeksforGeeks'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: know,
            child: const Text(
              ' Stateless Widget Tutorial ',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // RaisedButton class is deprecated and should not be used
          // Use ElevatedButton class instead
           
          // child: RaisedButton(
          //     padding: EdgeInsets.all(5),
          //     color: Colors.green,
          //     onPressed: know,
          //     child: const Text(
          //     ' Stateless Widget Tutorial ',
          //     style: TextStyle(color: Colors.white),
          //     ),
          // ),
        ),
      ),
    );
  }
}