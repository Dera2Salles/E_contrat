import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../features/contract/presentation/pages/contract_categories_page.dart';
import '../../features/pdf_management/presentation/pages/pdf_list_page.dart';
import '../../features/assistant/presentation/pages/assistant_screen.dart';
import '../../features/contract/presentation/responsive.dart';

class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    const ContractCategoriesPage(),
    const PdfListPage(),
    const AssistantScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.white,
        color: scheme.primary,
        height: context.rs(75),
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(Icons.layers_rounded, color: Colors.white, size: context.rs(30)),
          Icon(Icons.check_circle, color: Colors.white, size: context.rs(30)),
          Icon(Icons.assistant, color: Colors.white, size: context.rs(30)),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
