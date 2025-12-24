import 'package:e_contrat/core/di/injection.dart';
import 'package:e_contrat/core/widgets/linear.dart';
import 'package:e_contrat/features/contract/contract_category.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_categories_bloc.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_categories_event.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_categories_state.dart';
import 'package:e_contrat/features/contract/presentation/pages/contract_list_screen.dart';
import 'package:e_contrat/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

class ContractCategoriesPage extends StatelessWidget {
  const ContractCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContractCategoriesBloc>()..add(LoadContractCategories()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const Linear(),
            // Decorative subtle light sources instead of heavy SVGs
            Positioned(
              top: -context.rs(100),
              right: -context.rs(100),
              child: _CircularGlow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)),
            ),
            Positioned(
              bottom: -context.rs(150),
              left: -context.rs(100),
              child: _CircularGlow(color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1)),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(context.rs(32), context.rs(24), context.rs(32), context.rs(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catégories',
                          style: TextStyle(
                            fontSize: context.rf(36),
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Outfit',
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          'Choisissez un modèle pour commencer',
                          style: TextStyle(
                            fontSize: context.rf(16),
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<ContractCategoriesBloc, ContractCategoriesState>(
                      builder: (context, state) {
                        if (state is ContractCategoriesLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ContractCategoriesLoaded) {
                          return _CategoriesGrid(items: state.items);
                        } else if (state is ContractCategoriesError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularGlow extends StatelessWidget {
  final Color color;
  const _CircularGlow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.rs(400),
      height: context.rs(400),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  final List<ContractCategory> items;
  const _CategoriesGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(context.rs(24)),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isExpanded ? 3 : 2,
        crossAxisSpacing: context.rs(20),
        mainAxisSpacing: context.rs(20),
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final category = items[index];
        return _CategoryCard(category: category, index: index);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ContractCategory category;
  final int index;

  const _CategoryCard({required this.category, required this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'category_${category.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final raw = category.templates
                .map((t) => {
                      'title': t.title,
                      'data': t.document.toJson(),
                      'placeholders': t.placeholders,
                      'partie': t.parties,
                    })
                .toList(growable: false);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ContractListScreen(
                  data: raw,
                  title: category.label,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(context.rs(28)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(context.rs(28)),
              border: Border.all(
                color: category.color.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: category.color.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.rs(28)),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: EdgeInsets.all(context.rs(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(context.rs(16)),
                        decoration: BoxDecoration(
                          color: category.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category.iconData,
                          size: context.rs(32),
                          color: category.color,
                        ),
                      ),
                      SizedBox(height: context.rs(16)),
                      Text(
                        category.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.rf(18),
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: context.rs(4)),
                      Text(
                        '${category.templates.length} modèles',
                        style: TextStyle(
                          fontSize: context.rf(12),
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
