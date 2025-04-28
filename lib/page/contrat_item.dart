import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'wizard.dart'; // Assuming WizardForm is here

class ContractItem extends StatefulWidget {
  final String title;
  final int index;
  final List<dynamic> data;
  final List<String> placeholders;
  final List<String> partie;
  final int totalItems; // Total number of contracts

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
  _ContractItemState createState() => _ContractItemState();
}

class _ContractItemState extends State<ContractItem> {
  final Map<String, TextEditingController> _controllers = {};

  String getPreviewText() {
    return widget.data
        .asMap()
        .entries
        .where((entry) => entry.value['insert'] is String)
        .map((entry) {
          final op = entry.value;
          final text = op['insert'] as String;
          return text;
        })
        .join()
        .trim();
  }

  @override
  void initState() {
    super.initState();
    for (var placeholder in widget.placeholders) {
      _controllers[placeholder] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return WizardForm(
                placeholders: widget.placeholders,
                data: widget.data,
                partie: widget.partie,
              );
            },
          );
        },
        child: Center(
          child: Stack(
            children: [
              Positioned(
                left: 2.w,
                top: -1.h,
                child: SvgPicture.asset(
                  'assets/svg/editor.svg',
                  width: 190.h,
                  height: 190.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'E-contrat ${widget.title}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3200d5),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      getPreviewText(),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 30,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.index < widget.totalItems - 1) ...[
                       SizedBox(height: 0.h),
                      TextButton.icon(
                        onPressed: () {
                          // Trigger swipe to next page
                          final pageController = context.findAncestorWidgetOfExactType<PageView>()?.controller;
                          if (pageController != null) {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.chevronDown,
                          size: 16,
                          color: Color(0xFF3200d5),
                        ),
                        label: Text(
                          'Contrat suivant',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF3200d5),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}