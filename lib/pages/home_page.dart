import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic allowed = '';
  dynamic denied = '';
  @override
  void initState() {
    super.initState();
    widget.ref.child("/allowed").onValue.listen((event) {
      setState(() {
        allowed = event.snapshot.value;
      });
    });

    widget.ref.child("/denied").onValue.listen((event) {
      setState(() {
        denied = event.snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge AI'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await widget.ref.child("/allowed").set(true);
                  },
                  child: Text("Set allowed to true: $allowed")),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await widget.ref.child("/denied").set(true);
                  },
                  child: Text("Set allowed to true: $denied")),
            ],
          )
        ],
      ),
    );
  }
}
