import 'package:congressionalappchallenge/pages/summary.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward().then((_) {
      // Automatically navigate to Summary after animation completes
      slideUpWidget(newPage: Summary(), context: context);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF22282C),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0.0,
                    MediaQuery.of(context).size.height *
                        (1.0 - _animationController.value),
                  ),
                  child: child,
                );
              },
              child: AnimatedContainer(
                width: MediaQuery.of(context).size.width * 0.866,
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: const ShapeDecoration(
                  color: Color(0xFF2E343B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 500),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
                // Your main content here
                ),
          ),
        ],
      ),
    );
  }
}

void slideUpWidget({required Widget newPage, required BuildContext context}) {
  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        const duration = Duration(milliseconds: 800); // Slower duration

        var offsetAnimation = animation.drive(
          Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          ),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration:
          Duration(milliseconds: 800), // Match the duration here
    ),
    (route) => false,
  );
}
