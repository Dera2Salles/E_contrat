import 'dart:io';
import 'dart:ui' as ui;

import 'package:e_contrat/core/di/injection.dart';
import 'package:e_contrat/core/widgets/confirm.dart';
import 'package:e_contrat/core/widgets/linear.dart';
import 'package:e_contrat/core/widgets/loading.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_pdf_bloc.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_pdf_event.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_pdf_state.dart';
import 'package:e_contrat/features/contract/presentation/quill/constants.dart';
import 'package:e_contrat/features/contract/presentation/quill/custom_quill_editor.dart';
import 'package:e_contrat/features/contract/presentation/quill/fonts_loader.dart';
import 'package:e_contrat/features/contract/presentation/responsive.dart';
import 'package:e_contrat/page/grid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

final FontsLoader loader = FontsLoader();

class ContractPdfQuillPage extends StatelessWidget {
  final Map<String, String> formData;
  final List<dynamic> documentModel;
  final List<String> placeholder;
  final List<String> partie; // Modèle de document à utiliser

  const ContractPdfQuillPage({
    super.key,
    required this.documentModel,
    required this.formData,
    required this.partie,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ContractPdfBloc>()
            ..add(InitContractPdf(documentModel, formData)),
      child: PdfQuill(
        documentModel: documentModel,
        formData: formData,
        partie: partie,
        placeholder: placeholder,
      ),
    );
  }
}

class PdfQuill extends StatefulWidget {
  final Map<String, String> formData;
  final List<dynamic> documentModel;
  final List<String> placeholder;
  final List<String> partie; // Modèle de document à utiliser
  const PdfQuill({
    super.key,
    required this.documentModel,
    required this.formData,
    required this.partie,
    required this.placeholder,
  });

  @override
  State<PdfQuill> createState() => _PdfQuillState();
}

class _PdfQuillState extends State<PdfQuill> {
  bool firstEntry = false;
  late final QuillController _quillController = QuillController(
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  @override
  void initState() {
    super.initState();
    // Initial document loading is now handled by the Bloc's processedDocument state
  }

  final FocusNode _editorNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _shouldShowToolbar = ValueNotifier<bool>(false);
  Delta? oldDelta;

  // Signature images are now managed by the BLoC
  final GlobalKey<SfSignaturePadState> _signaturePadKey1 =
      GlobalKey<SfSignaturePadState>();
  final GlobalKey<SfSignaturePadState> _signaturePadKey2 =
      GlobalKey<SfSignaturePadState>();

  @override
  void dispose() {
    _quillController.dispose();
    _editorNode.dispose();
    _scrollController.dispose();
    _shouldShowToolbar.dispose();
    super.dispose();
  }

  // Common method for signature page navigation to reduce duplication
  Future<void> _navigateToSignaturePage({
    required GlobalKey<SfSignaturePadState> key,
    required String title,
    required String heroTagClear,
    required String heroTagSave,
    required Future<void> Function() onSave,
  }) async {
    void handleClearButtonPressed() {
      if (key.currentState != null) {
        key.currentState!.clear();
      }
    }

    final signature = await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) {
          return Scaffold(
            backgroundColor: Colors.black.withValues(alpha: 0.6),
            body: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Container(
                  width: context.rs(380),
                  padding: EdgeInsets.all(context.rs(24)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.rs(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: context.rf(24),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: context.rs(20)),
                      Container(
                        height: context.rs(400),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(context.rs(20)),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(context.rs(20)),
                          child: SfSignaturePad(
                            key: key,
                            backgroundColor: Colors.transparent,
                            strokeColor: Theme.of(context).colorScheme.primary,
                            minimumStrokeWidth: 2.0,
                            maximumStrokeWidth: 5.0,
                          ),
                        ),
                      ),
                      SizedBox(height: context.rs(24)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildModalButton(
                            context,
                            icon: Icons.refresh_rounded,
                            label: 'Effacer',
                            color: Theme.of(context).colorScheme.error,
                            onPressed: handleClearButtonPressed,
                            heroTag: heroTagClear,
                          ),
                          _buildModalButton(
                            context,
                            icon: Icons.check_rounded,
                            label: 'Valider',
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: () => Navigator.pop(context, true),
                            heroTag: heroTagSave,
                            isPrimary: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    if (signature == true) {
      await onSave();
    }
  }

  Widget _buildModalButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required String heroTag,
    bool isPrimary = false,
  }) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: isPrimary ? color : color.withValues(alpha: 0.1),
        foregroundColor: isPrimary ? Colors.white : color,
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(24),
          vertical: context.rs(12),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: context.rs(20)),
      label: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.rf(16)),
      ),
    );
  }

  Future<void> _captureSignature(
    GlobalKey<SfSignaturePadState> key,
    int partyIndex,
  ) async {
    if (key.currentState != null) {
      final image = await key.currentState!.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      if (mounted) {
        context.read<ContractPdfBloc>().add(
          CaptureSignature(partyIndex, pngBytes, image),
        );
      }
      key.currentState!.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<ContractPdfBloc, ContractPdfState>(
      listener: (context, state) {
        if (state.status == ContractPdfStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  const Text(
                    'PDF généré avec succès',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Grid()),
            (route) => false,
          );
        } else if (state.status == ContractPdfStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${state.errorMessage}'),
              backgroundColor: scheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (state.processedDocument != null &&
            _quillController.document.isEmpty()) {
          _quillController.document = Document.fromJson(
            state.processedDocument!,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: _buildGlassAppBar(context, state, scheme),
          body: Stack(
            fit: StackFit.expand,
            children: [
              const Linear(),
              if (state.status == ContractPdfStatus.loading)
                const LoadingScreen(),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + context.rs(80),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(context.rs(16)),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(context.rs(24)),
                        border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.1),
                            blurRadius: context.rs(30),
                            offset: Offset(0, context.rs(10)),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(context.rs(24)),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Column(
                            children: [
                              if (Platform.isMacOS ||
                                  Platform.isWindows ||
                                  Platform.isLinux)
                                _buildToolbar(context),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.rs(24),
                                    vertical: context.rs(16),
                                  ),
                                  child: CustomQuillEditor(
                                    node: _editorNode,
                                    controller: _quillController,
                                    defaultFontFamily: 'Arial',
                                    scrollController: _scrollController,
                                    onChange: (Document document) {
                                      if (oldDelta == document.toDelta()) {
                                        return;
                                      }
                                      oldDelta = document.toDelta();
                                      if (mounted &&
                                          !_shouldShowToolbar.value) {
                                        _shouldShowToolbar.value = true;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (Platform.isIOS ||
                      Platform.isAndroid ||
                      Platform.isFuchsia)
                    ValueListenableBuilder<bool>(
                      valueListenable: _shouldShowToolbar,
                      builder: (_, value, __) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: value ? context.rs(60) : 0,
                        child: value
                            ? _buildToolbar(context, isMobile: true)
                            : const SizedBox(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildGlassAppBar(
    BuildContext context,
    ContractPdfState state,
    ColorScheme scheme,
  ) {
    return PreferredSize(
      preferredSize: Size.fromHeight(context.rs(80)),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.7),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: scheme.primary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: context.rs(16)),
                  Expanded(
                    child: Text(
                      'Édition du contrat',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: context.rf(22),
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  _buildSignatureAction(
                    context,
                    hasSignature: state.hasSignature1,
                    label: widget.partie[0],
                    icon: Icons.draw_rounded,
                    onPressed: () => _navigateToSignaturePage(
                      key: _signaturePadKey1,
                      title: 'Signature ${widget.partie[0]}',
                      heroTagClear: 'clear1',
                      heroTagSave: 'save1',
                      onSave: () => _captureSignature(_signaturePadKey1, 0),
                    ),
                  ),
                  _buildSignatureAction(
                    context,
                    hasSignature: state.hasSignature2,
                    label: widget.partie[1],
                    icon: Icons.gesture_rounded,
                    onPressed: () => _navigateToSignaturePage(
                      key: _signaturePadKey2,
                      title: 'Signature ${widget.partie[1]}',
                      heroTagClear: 'clear2',
                      heroTagSave: 'save2',
                      onSave: () => _captureSignature(_signaturePadKey2, 1),
                    ),
                  ),
                  SizedBox(width: context.rs(8)),
                  FloatingActionButton.small(
                    onPressed: state.status == ContractPdfStatus.loading
                        ? null
                        : () {
                            ConfirmationDialog.show(
                              context,
                              icon: Icons.save_rounded,
                              confirmColor: scheme.primary,
                              title: 'Finaliser le contrat ?',
                              message:
                                  'Voulez-vous générer et sauvegarder le document PDF signé ?',
                              onConfirm: () {
                                context.read<ContractPdfBloc>().add(
                                  GeneratePdfRequested(
                                    content: _quillController.document
                                        .toDelta(),
                                    parties: widget.partie,
                                    placeholders: widget.placeholder,
                                    formData: widget.formData,
                                  ),
                                );
                              },
                            );
                          },
                    elevation: 0,
                    backgroundColor: scheme.primary,
                    child: const Icon(Icons.save_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureAction(
    BuildContext context, {
    required bool hasSignature,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: 'Signature de $label',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: context.rs(4)),
            padding: EdgeInsets.all(context.rs(8)),
            decoration: BoxDecoration(
              color: hasSignature
                  ? Colors.green.withValues(alpha: 0.1)
                  : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: hasSignature ? Colors.green : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Icon(
                  icon,
                  color: hasSignature ? Colors.green : scheme.primary,
                  size: context.rs(20),
                ),
                if (hasSignature)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 10,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, {bool isMobile = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
        color: Colors.grey.withValues(alpha: 0.05),
      ),
      child: QuillSimpleToolbar(
        controller: _quillController,
        config: QuillSimpleToolbarConfig(
          toolbarSize: context.rs(50),
          color: Colors.transparent,
          sectionDividerColor: Theme.of(
            context,
          ).dividerColor.withValues(alpha: 0.2),
          multiRowsDisplay: !isMobile,
          showAlignmentButtons: true,
          showLineHeightButton: true,
          buttonOptions: const QuillSimpleToolbarButtonOptions(
            fontSize: QuillToolbarFontSizeButtonOptions(
              items: fontSizes,
              initialValue: 'Normal',
              defaultDisplayText: 'Normal',
            ),
            fontFamily: QuillToolbarFontFamilyButtonOptions(
              items: fontFamilies,
              defaultDisplayText: 'Arial',
              initialValue: 'Arial',
            ),
          ),
          embedButtons: FlutterQuillEmbeds.toolbarButtons(),
        ),
      ),
    );
  }
}
