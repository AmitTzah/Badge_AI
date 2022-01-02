import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  final String door;
  HomePage({Key? key,required this.door}) : super(key: key);
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> { 
  dynamic allowed = '';
  dynamic denied = '';
  @override
  void initState() {
    final open = widget.door+"/Open";
    final locked = widget.door+"/Locked";
    super.initState();
    widget.ref.child(open).onValue.listen((event) {
      setState(() {
        allowed = event.snapshot.value;
      });
    });

    widget.ref.child(locked).onValue.listen((event) {
      setState(() {
        denied = event.snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final open = widget.door+"/Open";
    final locked = widget.door+"/Locked";
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
                  await widget.ref.child(open).set(1);
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
                    await widget.ref.child(locked).set(1);
                  }else{
                    await widget.ref.child(locked).set(0);
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
