import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../button.dart';
import '../constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.1.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 40.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value.toString().trim();
                        },
                        validator: (value) =>
                            (value!.isEmpty) ? ' Please enter email' : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Email',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Password";
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Choose a Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(height: 15.h),
                      LoginSignupButton(
                        title: 'Register',
                        ontapp: () async {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            try {
                              final UserCredential user =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              setUser(user);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.blueGrey,
                                  content: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'Sucessfully Register.You Can Login Now'),
                                  ),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                              Navigator.of(context).pop();
                              setState(() {
                                isloading = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title:
                                      const Text(' Ops! Registration Failed'),
                                  content: Text('${e.message}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Okay'),
                                    )
                                  ],
                                ),
                              );
                            }
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

Future<void> setUser(UserCredential user) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(user.user!.uid) // <-- Document ID
      .set({
    'uid': user.user!.uid,
    'email': user.user!.email,
    '/Building1/Door1': 0,
    '/Building1/Door2': 0,
    '/Building2/Door1': 0
  }); // <-- Your data
}
