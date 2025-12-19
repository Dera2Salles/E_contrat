import 'package:flutter/material.dart';
import '../../features/contract/presentation/responsive.dart';

class ConfirmationDelete {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Confirmation',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink(); // on utilise `transitionBuilder` uniquement
      },
      transitionBuilder: (context, animation, _, __) {
        final scheme = Theme.of(context).colorScheme;
        final curvedValue = Curves.easeInOut.transform(animation.value);
        
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: curvedValue,
            child: Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width * (context.isExpanded ? 0.45 : 0.85),
                padding: EdgeInsets.all(context.rs(32)),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(context.rs(32)),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.1)),
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
                          color: scheme.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.delete_outline_rounded, size: context.rs(40), color: scheme.error),
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
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.rf(16),
                          height: 1.5,
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: context.rs(32)),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: context.rs(16)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rs(16))),
                              ),
                              child: Text(
                                'Annuler',
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
                                backgroundColor: scheme.error,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: context.rs(16)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.rs(16)),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                'Confirmer',
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
      },
    ).then((value) => value ?? false);
  }
}
