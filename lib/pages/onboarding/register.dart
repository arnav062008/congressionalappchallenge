import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;
      print(userId);
      users.doc(userId).set({
        'name': name,
        'email': email,
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Register Failed'),
            content: Text("$error"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF22282C),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  left: width * -0.88,
                  bottom: height * 0.54,
                  child: Container(
                    width: 766,
                    height: 841,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color.fromRGBO(6, 156, 138, 1),
                          Color.fromRGBO(221, 246, 243, 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.1,
                  left: width * 0.04,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.9,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: height * 0.08,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome back!",
                                    style: TextStyle(
                                      color: const Color(0xfff7f7f7),
                                      fontSize: width * 0.06,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Enter your credentials to continue.",
                                    style: TextStyle(
                                      color: const Color(0xfff1f8ff),
                                      fontSize: width * 0.04,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextBox(
                                  obsc: false,
                                  width: width,
                                  height: height,
                                  nameController: _nameController,
                                  icon: Icons.account_circle_outlined,
                                  text: "Name: ",
                                ),
                                SizedBox(height: height * 0.01),
                                TextBox(
                                  obsc: false,
                                  width: width,
                                  height: height,
                                  nameController: _emailController,
                                  icon: Icons.email_outlined,
                                  text: "Email Address: ",
                                ),
                                SizedBox(height: height * 0.01),
                                TextBox(
                                  obsc: true,
                                  width: width,
                                  height: height,
                                  nameController: _passwordController,
                                  icon: Icons.lock_outline,
                                  text: "Password: ",
                                ),
                                SizedBox(height: height * 0.01),
                                TextBox(
                                  obsc: true,
                                  width: width,
                                  height: height,
                                  nameController: _confirm,
                                  icon: Icons.lock_outline,
                                  text: "Confirm Password: ",
                                ),
                                SizedBox(height: height * 0.01),
                                Container(
                                  width: width * 0.9,
                                  height: height * 0.02,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                GestureDetector(
                                  child: Container(
                                    width: width * 0.9,
                                    height: height * 0.07,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02),
                                      color: const Color(0xff169c89),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.04),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Register",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    final bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(_emailController.text);
                                    if (emailValid == true) {
                                      if (_passwordController.text ==
                                          _confirm.text) {
                                        if (_passwordController.text.length >
                                            5) {
                                          if (_nameController.text.isEmpty ==
                                              false) {
                                            addUser(
                                                _nameController.text,
                                                _emailController.text,
                                                _passwordController.text);
                                            Navigator.pop(context);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const BasicAlert(
                                                  text: "Name Field is Empty",
                                                  title:
                                                      "Error in User Creation",
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const BasicAlert(
                                                text:
                                                    "Password must be at least 6 characters long",
                                                title: "Error in User Creation",
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const BasicAlert(
                                              text:
                                                  "Password and Confirm Password Don't Match",
                                              title: "Error in User Creation",
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const BasicAlert(
                                            text: "Email is Invalid",
                                            title: "Error in User Creation",
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      SizedBox(
                        width: width * 0.9,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 0.92,
                              height: height * 0.02,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Or connect via",
                                    style: TextStyle(
                                      color: const Color(0xff999999),
                                      fontSize: width * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            SizedBox(
                              width: width * 0.9,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AlternateSignInMethods(
                                    width: width,
                                    height: height,
                                    image: "google.png",
                                  ),
                                  Container(
                                    width: width * 0.25,
                                    height: height * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02),
                                      border: Border.all(
                                          color: const Color(0xffdddddd),
                                          width: width * 0.01),
                                      color: const Color(0xfff7f7f7),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.04),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.04,
                                          height: height * 0.04,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.02),
                                          ),
                                          child:
                                              FlutterLogo(size: width * 0.04),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.25,
                                    height: height * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02),
                                      border: Border.all(
                                          color: const Color(0xffdddddd),
                                          width: width * 0.01),
                                      color: const Color(0xfff7f7f7),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.04),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.04,
                                          height: height * 0.06,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.02),
                                          ),
                                          child:
                                              FlutterLogo(size: width * 0.04),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xffe8f3f1),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff169C89),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BasicAlert extends StatelessWidget {
  const BasicAlert({Key? key, required this.text, required this.title})
      : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}

class AlternateSignInMethods extends StatelessWidget {
  const AlternateSignInMethods({
    super.key,
    required this.width,
    required this.height,
    required this.image,
  });

  final double width;
  final double height;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.25,
      height: height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.02),
        border: Border.all(color: const Color(0xffdddddd), width: width * 0.01),
        color: const Color(0xfff7f7f7),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0.04),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width * 0.04,
            height: height * 0.04,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width * 0.02),
            ),
            child: Image.asset(image),
          ),
        ],
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  const TextBox({
    super.key,
    required this.obsc,
    required this.width,
    required this.height,
    required this.icon,
    required TextEditingController nameController,
    required this.text,
  }) : _nameController = nameController;
  final String text;
  final bool obsc;
  final double width;
  final double height;
  final IconData icon;
  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.9,
      height: height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.02),
        border: Border.all(color: const Color(0xffdddddd), width: width * 0.01),
        color: const Color(0xfff7f7f7),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0.04),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
              child: Icon(
                icon,
                color: const Color(0xff858585),
                size: width * 0.06,
              ),
            ),
            SizedBox(width: width * 0.015),
            Expanded(
              child: TextField(
                obscureText: obsc,
                style: TextStyle(
                  color: const Color(0xff858585),
                  fontSize: width * 0.04,
                ),
                controller: _nameController,
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: text,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: const Color(0xff858585).withOpacity(0.5),
                    fontSize: width * 0.04,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
