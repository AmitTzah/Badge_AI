import 'package:badge_ai/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import '../button.dart';
import '../constants.dart';
import 'home.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 40.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Email";
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Email',
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
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(height: 15.h),
                      LoginSignupButton(
                        title: 'Login',
                        ontapp: () async {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            try {
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                              await Navigator.of(context)
                                  .pushNamed(RouteManager.homePage);
                              setState(() {
                                isloading = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Ops! Login Failed"),
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
                              // ignore: avoid_print
                              print(e);
                            }
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteManager.register);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Don't have an Account ?",
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.black87),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Sign up',
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
