import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../../features/contract/presentation/responsive.dart';

class LoadingScreen extends StatelessWidget {
  final String text;
  final double verticalTextPadding;
  final double? heightWidget;
  final double? spaceBetween;
  final double strokeWidth;
  final TextStyle? style;
  final Duration duration;
  final Color? loadingColor;
  final bool infinite;

  const LoadingScreen({
    super.key,
    this.text = 'Génération du PDF...',
    this.loadingColor = Colors.white,
    this.strokeWidth = 7,
    this.spaceBetween,
    this.duration = const Duration(milliseconds: 260),
    this.infinite = false,
    this.style,
    this.heightWidget,
    this.verticalTextPadding = 30,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Size size = MediaQuery.sizeOf(context);
    
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          width: size.width * (context.isExpanded ? 0.4 : 0.8),
          padding: EdgeInsets.symmetric(
            vertical: context.rs(40),
            horizontal: context.rs(24),
          ),
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(context.rs(32)),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: context.rs(40),
                offset: Offset(0, context.rs(20)),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                   SizedBox(
                    width: context.rs(80),
                    height: context.rs(80),
                    child: CircularProgressIndicator(
                      strokeWidth: context.rs(3),
                      valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                      backgroundColor: scheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  Icon(
                    Icons.description_outlined,
                    color: scheme.primary,
                    size: context.rs(32),
                  ),
                ],
              ),
              SizedBox(height: context.rs(32)),
              AnimatedWavyText(
                infinite: infinite,
                duration: duration,
                text: text,
                style: style ?? TextStyle(
                  color: scheme.onSurface,
                  fontSize: context.rf(18),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                  letterSpacing: 0.5,
                ),
                verticalPadding: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedWavyText extends StatelessWidget {
  final double verticalPadding;
  final Key? animatedKey;
  final String text;
  final bool infinite;
  final int totalRepeatCount;
  final Duration duration;
  final TextStyle? style;

  const AnimatedWavyText({
    super.key,
    this.animatedKey,
    this.verticalPadding = 50,
    required this.text,
    this.infinite = false,
    this.totalRepeatCount = 4,
    this.duration = const Duration(milliseconds: 260),
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: AnimatedTextKit(
        key: animatedKey,
        repeatForever: infinite,
        animatedTexts: <AnimatedText>[
          WavyAnimatedText(
            text,
            speed: duration,
            textStyle: style ??
                TextStyle(
                  color: Colors.white,
                  fontSize: context.rf(18),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
        displayFullTextOnTap: true,
        totalRepeatCount: totalRepeatCount < 1 ? 1 : totalRepeatCount,
      ),
    );
  }
}
