import 'package:e_contrat/core/di/injection.dart';
import 'package:e_contrat/core/widgets/linear.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_categories_bloc.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_categories_event.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_categories_state.dart';
import 'package:e_contrat/features/contract/presentation/pages/contract_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';


class ContractCategoriesPage extends StatelessWidget {
  const ContractCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContractCategoriesBloc>()..add(LoadContractCategories()),
      child: Scaffold(
        body: Stack(
          children: [
            const Linear(),
            Positioned(
              top: 35.h,
              right: 55.w,
              child: Transform.scale(
                scale: 3.0,
                child: SvgPicture.asset(
                  'assets/svg/background.svg',
                  width: 35.w,
                  height: 35.h,
                ),
              ),
            ),
            Align(
              alignment: Alignment(-0.03.w, -0.04.h),
              child: SvgPicture.asset(
                'assets/svg/Consent.svg',
                width: 75.w,
                height: 75.h,
              ),
            ),
            BlocBuilder<ContractCategoriesBloc, ContractCategoriesState>(
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
          ],
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
    final scheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment(-0.05.w, 0.04.h),
      child: SizedBox(
        width: 70.w,
        height: 70.h,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 30,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final category = items[index];
            return Column(
              children: [
                SizedBox(
                  width: 17.w,
                  height: 7.h,
                  child: FloatingActionButton(
                    heroTag: 'contract_category_$index',
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    onPressed: () {
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
                    child: Icon(Icons.description_rounded, color: scheme.onPrimary),
                  ),
                ),
                Text(
                  category.label,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
