import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badge AI'),),
      body: Center(
        child: Container(color: Colors.brown,
        width:55.w,
        height: 25.h,
        ),
      ),
    );
  }
}