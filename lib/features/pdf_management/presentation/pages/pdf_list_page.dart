import 'package:e_contrat/core/di/injection.dart';
import 'package:e_contrat/core/widgets/delete_confirm_dialog.dart';
import 'package:e_contrat/core/widgets/linear.dart';
import 'package:e_contrat/features/pdf_management/presentation/pages/pdf_view_screen.dart';
import 'package:e_contrat/features/pdf_management/presentation/bloc/pdf_list_bloc.dart';
import 'package:e_contrat/features/pdf_management/presentation/bloc/pdf_list_event.dart';
import 'package:e_contrat/features/pdf_management/presentation/bloc/pdf_list_state.dart';
import 'package:e_contrat/features/contract/presentation/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(context.rs(32), context.rs(24), context.rs(32), context.rs(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mes Contrats',
                              style: TextStyle(
                                fontSize: context.rf(36),
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                letterSpacing: -1,
                              ),
                            ),
                            Text(
                              'Gérez et visualisez vos documents signés',
                              style: TextStyle(
                                fontSize: context.rf(16),
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: state is PdfListLoading
                            ? const Center(child: CircularProgressIndicator(color: Colors.white))
                            : state is PdfListLoaded
                                ? state.pdfs.isEmpty
                                    ? _buildEmptyState(context, scheme)
                                    : _buildPdfList(context, state.pdfs, scheme)
                                : state is PdfListError
                                    ? _buildErrorState(context, state.message, scheme)
                                    : const SizedBox(),
                      ),
                    ],
                  ),
                ),
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
        padding: EdgeInsets.symmetric(horizontal: context.rs(48)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(context.rs(32)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_rounded,
                size: context.rs(80),
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: context.rs(24)),
            Text(
              'Aucun PDF enregistré',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.rf(22),
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: context.rs(12)),
            Text(
              'Générez un contrat et sauvegardez-le pour le retrouver ici.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.rf(16),
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfList(BuildContext context, List<dynamic> pdfs, ColorScheme scheme) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: context.rs(20), vertical: context.rs(8)),
      physics: const BouncingScrollPhysics(),
      itemCount: pdfs.length,
      itemBuilder: (context, index) {
        final pdf = pdfs[index];
        return Padding(
          padding: EdgeInsets.only(bottom: context.rs(12)),
          child: Dismissible(
            key: Key(pdf.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: context.rs(24)),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(context.rs(20)),
              ),
              child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: context.rs(28)),
            ),
            confirmDismiss: (direction) async {
              return ConfirmationDelete.show(
                context,
                title: 'Supprimer ?',
                message: 'Ce fichier sera supprimé définitivement.',
              );
            },
            onDismissed: (_) => context.read<PdfListBloc>().add(DeletePdfEvent(pdf.id)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(context.rs(20)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: context.rs(20), vertical: context.rs(8)),
                leading: Container(
                  padding: EdgeInsets.all(context.rs(10)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.rs(12)),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.white,
                    size: context.rs(30),
                  ),
                ),
                title: Text(
                  pdf.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: context.rf(16),
                    fontFamily: 'Inter',
                  ),
                ),
                subtitle: Text(
                  'PDF Document',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: context.rf(13),
                  ),
                ),
                trailing: Icon(Icons.chevron_right_rounded, color: Colors.white54, size: context.rs(24)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewScreen(path: pdf.path, title: pdf.name),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message, ColorScheme scheme) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: context.rs(32)),
        padding: EdgeInsets.all(context.rs(16)),
        decoration: BoxDecoration(
          color: scheme.errorContainer.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(context.rs(16)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: scheme.onErrorContainer),
            SizedBox(width: context.rs(12)),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: scheme.onErrorContainer, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
