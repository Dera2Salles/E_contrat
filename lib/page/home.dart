import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../core/widgets/linear.dart';
import '../features/contract/presentation/responsive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'E-contrat',
          style: TextStyle(
            color: Colors.white,
            fontSize: context.rf(32),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(children: [const Linear(), _buildMainContent(context)]),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        _buildHeroImage(context),
        const SizedBox(height: 40),
        _buildWelcomeText(),
        const Spacer(flex: 1),
        _buildStartButton(context),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Center(
          child: Image.asset(
            'assets/img/img.png',
            width: context.rs(280),
            height: context.rs(280),
            fit: BoxFit.contain,
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut);
  }

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        "Créez, signez, sécurisez en un clic",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: context.rf(18),
          color: Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      width: context.isExpanded ? context.rs(400) : context.rs(300),
      height: context.rs(64),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3200d5).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/grid'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF3200d5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          "Ndao e-contrat",
          style: TextStyle(
            fontSize: context.rf(20),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.5, 0.5));
  }
}
