import 'package:congressionalappchallenge/constants.dart';
import 'package:congressionalappchallenge/pages/summary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../firebase_options.dart';
import 'register.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    Future<User?> signInWithGoogle({required BuildContext context}) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user;

      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn(
              clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
          .signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
          } else if (e.code == 'invalid-credential') {
            // handle the error here
          }
        } catch (e) {
          // handle the error here
        }
      }

      return user;
    }

    Future<void> signIn(String email, String password) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Summary()),
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicAlert(
              text: error.toString(),
              title: "Failed To Login",
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: height * 0.25,
                  width: width,
                  child: CustomPaint(
                    child: Container(),
                    painter: PainterDetails(), // CustomPainterClass
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
                                Container(
                                  width: width * 0.9,
                                  height: height * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    border: Border.all(
                                        color: Colors.transparent,
                                        width: width * 0.01),
                                    color: AppColors.textBoxColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.04),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              width * 0.05, 0, 0, 0),
                                          child: Icon(
                                            Icons.email_outlined,
                                            color: Colors.white,
                                            size: width * 0.06,
                                          ),
                                        ),
                                        SizedBox(width: width * 0.015),
                                        Expanded(
                                          child: TextField(
                                            style: TextStyle(
                                              color: AppColors.accentColor2,
                                              fontSize: width * 0.04,
                                            ),
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              disabledBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              hintText: 'Email Address',
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: width * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                Container(
                                  width: width * 0.9,
                                  height: height * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    border: Border.all(
                                        color: Colors.transparent,
                                        width: width * 0.01),
                                    color: AppColors.textBoxColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.04),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              width * 0.05, 0, 0, 0),
                                          child: Icon(
                                            Icons.lock_outline,
                                            color: Colors.white,
                                            size: width * 0.06,
                                          ),
                                        ),
                                        SizedBox(width: width * 0.015),
                                        Expanded(
                                          child: TextField(
                                            style: TextStyle(
                                              color: const Color(0xff858585),
                                              fontSize: width * 0.04,
                                            ),
                                            obscureText: true,
                                            controller: passwordController,
                                            decoration: InputDecoration(
                                              disabledBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              hintText: 'Password',
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: width * 0.04,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                                      color: AppColors.accentColor,
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
                                          "Log in",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    signIn(emailController.text,
                                        passwordController.text);
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
                              width: width * 0.6,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                          child: GestureDetector(
                                            onTap: () {
                                              signInWithGoogle(
                                                  context: context);
                                            },
                                            child: Image.asset(
                                              'assets/google.png',
                                              width: width * 0.04,
                                              height: height * 0.04,
                                            ),
                                          ),
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
                                          child: Image.asset(
                                            'assets/apple.png',
                                            width: width * 0.04,
                                            height: height * 0.04,
                                          ),
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
                      SizedBox(
                        width: width * 0.9,
                      ),
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
                  "Don’t have an account? ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: const Text(
                    "Register",
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

const double _kCurveHeight = 35;

class PainterDetails extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(
        size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = AppColors.accentColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
