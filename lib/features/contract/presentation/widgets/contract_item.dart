import 'package:e_contrat/features/contract/presentation/pages/contract_wizard_form.dart';
import 'package:flutter/material.dart';
import '../responsive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContractItem extends StatefulWidget {
  final String title;
  final int index;
  final List<dynamic> data;
  final List<String> placeholders;
  final List<String> partie;
  final int totalItems;

  const ContractItem({
    super.key,
    required this.data,
    required this.index,
    required this.placeholders,
    required this.partie,
    required this.title,
    required this.totalItems,
  });

  @override
  State<ContractItem> createState() => _ContractItemState();
}

class _ContractItemState extends State<ContractItem> {
  String getPreviewText() {
    return widget.data
        .asMap()
        .entries
        .where((entry) => entry.value['insert'] is String)
        .map((entry) => entry.value['insert'] as String)
        .join()
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: context.isExpanded ? context.rs(340) : context.rs(320),
        height: context.isExpanded ? context.rs(520) : context.rs(500),
        margin: EdgeInsets.symmetric(
          horizontal: context.rs(20),
          vertical: context.rs(24),
        ),
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(context.rs(32)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: context.rs(50),
              offset: Offset(0, context.rs(20)),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.rs(32)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [scheme.primary, scheme.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rs(12),
                        vertical: context.rs(6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(context.rs(100)),
                      ),
                      child: Text(
                        'MODÈLE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.rf(10),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: context.rs(16)),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.rf(24),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Outfit',
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(context.rs(32)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'APERÇU DU CONTENU',
                        style: TextStyle(
                          fontSize: context.rf(11),
                          fontWeight: FontWeight.w700,
                          color: scheme.primary.withValues(alpha: 0.5),
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: context.rs(16)),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Text(
                            getPreviewText(),
                            style: TextStyle(
                              fontSize: context.rf(14),
                              color: scheme.onSurfaceVariant,
                              height: 1.6,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.rs(32)),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return WizardForm(
                                placeholders: widget.placeholders,
                                data: widget.data,
                                partie: widget.partie,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: scheme.primary,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, context.rs(64)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.rs(20)),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_document, size: context.rs(20)),
                            SizedBox(width: context.rs(12)),
                            Text(
                              'Utiliser ce modèle',
                              style: TextStyle(
                                fontSize: context.rf(16),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.index < widget.totalItems - 1) ...[
                        SizedBox(height: context.rs(12)),
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              final pageController = context.findAncestorWidgetOfExactType<PageView>()?.controller;
                              pageController?.nextPage(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutQuart,
                              );
                            },
                            icon: Icon(Icons.keyboard_arrow_down_rounded, size: context.rs(20), color: scheme.primary),
                            label: Text(
                              'Voir le suivant',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: context.rf(14),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.rs(24),
                                vertical: context.rs(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
