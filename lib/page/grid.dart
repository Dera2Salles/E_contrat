import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:e_contrat/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/assistant/presentation/bloc/assistant_bloc.dart';
import '../../features/contract/presentation/pages/contract_categories_page.dart';
import '../../features/pdf_management/presentation/pages/pdf_list_page.dart';
import '../../features/assistant/presentation/pages/assistant_screen.dart';
import '../core/widgets/responsive.dart';

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
    BlocProvider(
      create: (_) => getIt<AssistantBloc>(),
      child: const AssistantScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _pages[_pageIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: scheme.primary,
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.9),
          height: context.rs(75),
          animationDuration: const Duration(milliseconds: 300),
          index: _pageIndex,
          items: [
            Icon(Icons.dashboard_rounded, size: context.rs(30), color: _pageIndex == 0 ? Colors.white : scheme.primary),
            Icon(Icons.folder_copy_rounded, size: context.rs(30), color: _pageIndex == 1 ? Colors.white : scheme.primary),
            Icon(Icons.auto_awesome_rounded, size: context.rs(30), color: _pageIndex == 2 ? Colors.white : scheme.primary),
          ],
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
