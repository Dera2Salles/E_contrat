import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'responsive.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.icon,
    this.onCancel,
    this.confirmText = 'Confirmer',
    this.cancelText = 'Annuler',
    this.confirmColor = Colors.red,
    
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
    Color confirmColor = Colors.red,
    IconData icon = Icons.warning_amber_rounded
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirmation',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        final curvedValue = Curves.easeOutBack.transform(animation.value);
        final opacityValue = Curves.easeInOut.transform(animation.value);
        return Opacity(
          opacity: opacityValue,
          child: Transform.scale(
            scale: 0.9 + (0.1 * curvedValue),
            child: ConfirmationDialog(
              title: title,
              message: message,
              onConfirm: onConfirm,
              onCancel: onCancel,
              confirmText: confirmText,
              cancelText: cancelText,
              confirmColor: confirmColor,
              icon: icon,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.rs(32)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: MediaQuery.sizeOf(context).width * (context.isExpanded ? 0.45 : 0.85),
            padding: EdgeInsets.all(context.rs(32)),
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(context.rs(32)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: context.rs(40),
                  offset: Offset(0, context.rs(20)),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(context.rs(20)),
                    decoration: BoxDecoration(
                      color: confirmColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: confirmColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: context.rs(40), color: confirmColor),
                  ),
                  SizedBox(height: context.rs(24)),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.rf(22),
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Outfit',
                      color: scheme.onSurface,
                    ),
                  ),
                  SizedBox(height: context.rs(12)),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.rf(16),
                      height: 1.5,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: context.rs(32)),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (onCancel != null) onCancel!();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: context.rs(16)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rs(16))),
                          ),
                          child: Text(
                            cancelText,
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: context.rf(16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.rs(16)),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: confirmColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: context.rs(16)),
                            minimumSize: Size(0, context.rs(56)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.rs(16)),
                            ),
                            elevation: 0,
                            shadowColor: confirmColor.withValues(alpha: 0.4),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            onConfirm();
                          },
                          child: Text(
                            confirmText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: context.rf(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
