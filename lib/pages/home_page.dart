import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  DatabaseReference ref = FirebaseDatabase.instance.ref("/Is_allowed");

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge AI'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              print("pressed!");
            },
            child: Text("press to change data")),
      ),
    );
  }
}
