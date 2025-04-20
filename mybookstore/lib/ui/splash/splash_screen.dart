import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:mybookstore/ui/auth/bloc/auth_events.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _textAnimation;
  late Animation<Offset> _imageAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    _textAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 2.5), // Desce o texto
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _imageAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Sobe de fora da tela
      end: Offset(0, -0.5), // Fica um pouco acima do texto
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addListener(() {
      if (_controller.isCompleted) {
        BlocProvider.of<AuthBloc>(context).add(InitSessionEvent());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defaultColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SlideTransition(
                position: _textAnimation,
                child: Text(
                  "Bookstore",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
              SlideTransition(
                position: _imageAnimation,
                child: Image.asset(
                  'assets/logo_white.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
