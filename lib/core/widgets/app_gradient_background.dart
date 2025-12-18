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
            Color.alphaBlend(scheme.primary.withValues(alpha: 0.10), scheme.surface),
            Color.alphaBlend(scheme.primary.withValues(alpha: 0.18), scheme.surface),
            Color.alphaBlend(scheme.primary.withValues(alpha: 0.34), scheme.surface),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
