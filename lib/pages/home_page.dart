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
  DatabaseEvent? event;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge AI'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                event = await widget.ref.once();
                setState(() {});
                print('${(event)!.snapshot.value}');
              },
              child: Text("press to read data")),
          event == null
              ? Text('Nothing\'s read yet')
              : Text('the value read is: ${(event)!.snapshot.value}'),
        ],
      ),
    );
  }
}
