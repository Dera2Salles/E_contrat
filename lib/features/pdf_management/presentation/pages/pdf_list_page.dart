import 'package:e_contrat/core/di/injection.dart';
import 'package:e_contrat/core/widgets/delete_confirm_dialog.dart';
import 'package:e_contrat/core/widgets/linear.dart';
import 'package:e_contrat/features/pdf_management/presentation/pages/pdf_view_screen.dart';
import 'package:e_contrat/features/pdf_management/presentation/bloc/pdf_list_bloc.dart';
import 'package:e_contrat/features/pdf_management/presentation/bloc/pdf_list_event.dart';
import 'package:e_contrat/features/pdf_management/presentation/bloc/pdf_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class PdfListPage extends StatelessWidget {
  const PdfListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => getIt<PdfListBloc>()..add(LoadPdfList()),
      child: BlocBuilder<PdfListBloc, PdfListState>(
        builder: (context, state) {
          return Scaffold(
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
                if (state is PdfListLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state is PdfListLoaded)
                  state.pdfs.isEmpty
                      ? _buildEmptyState(context, scheme)
                      : _buildPdfList(context, state.pdfs, scheme)
                else if (state is PdfListError)
                  _buildErrorState(state.message, scheme)
                else
                  const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme scheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open_rounded,
              size: 64,
              color: scheme.onSurface.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 12),
            Text(
              'Aucun PDF enregistré',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Générez un contrat et sauvegardez-le pour le retrouver ici.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfList(BuildContext context, List<dynamic> pdfs, ColorScheme scheme) {
    return ListView.builder(
      itemCount: pdfs.length,
      itemBuilder: (context, index) {
        final pdf = pdfs[index];
        return Dismissible(
          key: Key(pdf.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return ConfirmationDelete.show(
              context,
              title: 'Supprimer ?',
              message: 'Ce fichier sera supprime definitevement',
            );
          },
          onDismissed: (_) => context.read<PdfListBloc>().add(DeletePdfEvent(pdf.id)),
          child: ListTile(
            leading: Icon(
              Icons.picture_as_pdf_rounded,
              color: scheme.primary,
              size: 35,
            ),
            title: Text(
              pdf.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfViewScreen(path: pdf.path, title: pdf.name),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message, ColorScheme scheme) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: Material(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            message,
            style: TextStyle(color: scheme.onErrorContainer),
          ),
        ),
      ),
    );
  }
}
