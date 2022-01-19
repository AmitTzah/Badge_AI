import 'package:badge_ai/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final String fullname;
  final String doors;
  HomeScreen({Key? key, required this.fullname, required this.doors})
      : super(key: key);
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
_signOut() async {
  await _firebaseAuth.signOut();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  String uid = '';
  String _scanBarcode = 'Unknown';
  int scannedRes = 0;
  bool needLocalAuth = false;
  bool locked = false;
  bool isAuth = false;
  bool doorExist = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => true);
  }

  Future<void> checkUserAuth() async {
    int res = 0;
    uid = _firebaseAuth.currentUser!.uid;
    bool needAuth = false;
    bool isLocked = false;
    bool exist = false;
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data?[_scanBarcode] == true) {
        res = 1;
      }
    }
    var doors = FirebaseFirestore.instance.collection('doors');
    var door = await doors.doc('doors').get();
    if (door.exists) {
      Map<String, dynamic>? doorData = door.data();
      if (doorData?[_scanBarcode] == true) {
        exist = true;
      }
      if (doorData?['$_scanBarcode/local_auth'] == true) {
        needAuth = true;
      }
      if (doorData?['$_scanBarcode/locked'] == true) {
        isLocked = true;
      }
    }

    setState(() {
      scannedRes = res;
      locked = isLocked;
      needLocalAuth = needAuth;
      doorExist = exist;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> bioLocalAuth() async {
    var localAuth = LocalAuthentication();
    bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to open door',
        biometricOnly: true);
    setState(() {
      isAuth = didAuthenticate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello ${widget.fullname}'),
            const SizedBox(height: 50),
            const Text('Authorized:'),
            const SizedBox(height: 20),
            Text(widget.doors),
            const SizedBox(height: 70),
            SizedBox(
              height: 60,
              width: 150,
              child: ElevatedButton(
                  clipBehavior: Clip.hardEdge,
                  child: const Center(
                    child: Text('Scan Door'),
                  ),
                  onPressed: () async {
                    await scanQR();
                    await checkUserAuth();
                    final open = _scanBarcode + "/Open";
                    if (scannedRes == 1 &&
                        locked == false &&
                        doorExist == true) {
                      if (needLocalAuth == true) {
                        await bioLocalAuth();
                        if (isAuth == true) {
                          await widget.db.child(open).set(1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Access Granted  $_scanBarcode"),
                              ),
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      } else {
                        //No need for local_auth bio
                        await widget.db.child(open).set(1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Access Granted:  $_scanBarcode"),
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      }
                    } else {
                      //User cant access door
                      if (doorExist == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blueGrey,
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Door Not Exist:  $_scanBarcode'),
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      } else if (scannedRes == 0) {
                        await widget.db.child(open).set(2);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Access Denied:  $_scanBarcode'),
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                        //Door is locked
                      } else if (locked == true) {
                        await widget.db.child(open).set(2);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.orange,
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Door Locked:  $_scanBarcode'),
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      }
                    }
                  }),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 60,
              width: 150,
              child: ElevatedButton(
                  clipBehavior: Clip.hardEdge,
                  child: const Center(
                    child: Text('Log out'),
                  ),
                  onPressed: () async {
                    await _signOut();
                    if (_firebaseAuth.currentUser == null) {
                      Navigator.of(context).pushNamed(RouteManager.login);
                    }
                  }),
            ),
            const SizedBox(height: 50),
            const Text('BadgeAI by Lior & Amit')
          ],
        ),
      ),
    );
  }
}
