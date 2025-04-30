import 'dart:async';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  bool showIcon = true;
  bool showLogo = false;
  bool showButtons = false;
  double iconLeft = -150;
  double logoOffsetY = 0;

  late final AnimationController _buttonAnimController;
  late final Animation<Offset> _buttonOffsetAnimation;

  @override
  void initState() {
    super.initState();

    _buttonAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _buttonOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonAnimController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        final screenWidth = MediaQuery.of(context).size.width;
        setState(() {
          iconLeft = screenWidth / 2 - 100;
        });
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showIcon = false;
        showLogo = true;
      });

      Future.delayed(const Duration(milliseconds: 700), () {
        setState(() {
          logoOffsetY = -50;
          showButtons = true;
        });
        _buttonAnimController.forward();
      });
    });
  }

  @override
  void dispose() {
    _buttonAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF9),
      body: Stack(
        children: [
          // ✅ Animated Intro Icon
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            left: iconLeft,
            top: media.size.height / 2 - 100,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: showIcon ? 1 : 0,
              child: Image.asset(
                'assets/intro.png',
                width: 200,
                height: 200,
              ),
            ),
          ),

          // ✅ Logo and Buttons
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 700),
              opacity: showLogo ? 1 : 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                transform: Matrix4.translationValues(0, logoOffsetY, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/dish_dash.png',
                      width: 400,
                    ),
                    const SizedBox(height: 25),

                    if (showButtons)
                      AnimatedBuilder(
                        animation: _buttonAnimController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _buttonOffsetAnimation,
                            child: FadeTransition(
                              opacity: _buttonAnimController,
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            // 🔹 Sign In Button
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                              child: Container(
                                width: 353,
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 🔹 Create Account Button
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/register');
                              },
                              child: Container(
                                width: 353,
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFF737373), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Create account',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
