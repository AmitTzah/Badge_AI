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
    widget.ref.child("/Building1/Door1/Open").onValue.listen((event) {
      setState(() {
        allowed = event.snapshot.value;
      });
    });

    widget.ref.child("/Building1/Door1/Locked").onValue.listen((event) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await widget.ref.child("/Building1/Door1/Open").set(1);
                },
                child: Text("Open: $allowed",
                    style: TextStyle(fontSize: 20.sp)),
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if(denied==0){
                    await widget.ref.child("/Building1/Door1/Locked").set(1);
                  }else{
                    await widget.ref.child("/Building1/Door1/Locked").set(0);
                  }
                },
                child: Text("Locked: $denied",
                    style: TextStyle(fontSize: 20.sp)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
