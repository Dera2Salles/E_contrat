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
import 'dart:ui' as ui;

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
      padding: EdgeInsets.fromLTRB(context.rs(20), context.rs(8), context.rs(20), context.rs(100)),
      physics: const BouncingScrollPhysics(),
      itemCount: pdfs.length,
      itemBuilder: (context, index) {
        final pdf = pdfs[index];
        return Padding(
          padding: EdgeInsets.only(bottom: context.rs(16)),
          child: Dismissible(
            key: Key(pdf.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: context.rs(24)),
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(context.rs(24)),
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
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(context.rs(24)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.rs(24)),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfViewScreen(path: pdf.path, title: pdf.name),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(context.rs(16)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(context.rs(12)),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    scheme.primary.withValues(alpha: 0.8),
                                    scheme.tertiary.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(context.rs(16)),
                                boxShadow: [
                                  BoxShadow(
                                    color: scheme.primary.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.picture_as_pdf_rounded,
                                color: Colors.white,
                                size: context.rs(28),
                              ),
                            ),
                            SizedBox(width: context.rs(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pdf.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: context.rf(16),
                                      fontFamily: 'Outfit',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: context.rs(4)),
                                  Text(
                                    'Document PDF',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: context.rf(13),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(context.rs(8)),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white70,
                                size: context.rs(14),
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
