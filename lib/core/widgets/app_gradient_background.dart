import 'package:flutter/material.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget? child;

  const AppGradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.surface,
            scheme.primary.withValues(alpha: 0.05),
            scheme.secondary.withValues(alpha: 0.05),
            scheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: child,
    );
  }
}
