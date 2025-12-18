import 'package:e_contrat/features/contract/presentation/pages/contract_wizard_form.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
        width: 85.w,
        height: 65.h,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                color: const Color(0xFF3200d5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Modèle de contrat',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            getPreviewText(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade800,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                          backgroundColor: const Color(0xFF3200d5),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Utiliser ce modèle'),
                      ),
                      if (widget.index < widget.totalItems - 1) ...[
                        TextButton.icon(
                          onPressed: () {
                            final pageController = context.findAncestorWidgetOfExactType<PageView>()?.controller;
                            pageController?.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const FaIcon(FontAwesomeIcons.chevronDown, size: 14),
                          label: const Text('Suivant'),
                          style: TextButton.styleFrom(foregroundColor: const Color(0xFF3200d5)),
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
