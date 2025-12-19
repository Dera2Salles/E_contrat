import 'dart:io';
import 'dart:ui' as ui;
import 'package:e_contrat/core/di/injection.dart';
import 'package:e_contrat/core/widgets/confirm.dart';
import 'package:e_contrat/core/widgets/linear.dart';
import 'package:e_contrat/core/widgets/loading.dart';
import 'package:e_contrat/features/contract/presentation/quill/constants.dart';
import 'package:e_contrat/features/contract/presentation/quill/custom_quill_editor.dart';
import 'package:e_contrat/features/contract/presentation/quill/fonts_loader.dart';
import 'package:e_contrat/features/pdf_management/domain/usecases/save_pdf_bytes.dart';
import 'package:e_contrat/page/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_svg/svg.dart';
import 'package:e_contrat/features/contract/presentation/responsive.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'bloc/contract_pdf_bloc.dart';
import 'bloc/contract_pdf_event.dart';
import 'bloc/contract_pdf_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      create: (context) => getIt<ContractPdfBloc>()
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
      selection: const TextSelection.collapsed(offset: 0));
  
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
  
  // Méthode pour naviguer vers la page de signature du créancier
  Future<void> _navigateToSignaturePage1() async {
    void handleClearButtonPressed() {
      // Vérification de null avant d'appeler clear
      if (_signaturePadKey1.currentState != null) {
        _signaturePadKey1.currentState!.clear();
      }
    }

    final signature = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
           resizeToAvoidBottomInset:false ,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Signature du ${widget.partie[0]}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3200d5)),
            ),
          ),
          body: Stack(
            children: [
              Linear(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(context.rs(12)),
                    child: SizedBox(
                      height: context.rs(600), // 80.h roughly
                      width: context.rs(355), // 91.w roughly
                      child: SfSignaturePad(
                        key: _signaturePadKey1,
                        backgroundColor: Colors.transparent,
                        strokeColor: Color(0xFF0D47A1),
                        minimumStrokeWidth: 1.0,
                        maximumStrokeWidth: 4.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "clear1",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                onPressed: handleClearButtonPressed,
                child: Icon(
                  Icons.clear_outlined,
                  size: 30,
                ),
              ),
              FloatingActionButton(
                heroTag: "save1",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Icon(
                  Icons.save_as_rounded,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (signature == true) {
      await _captureSignature1();
    }
  }

  // Méthode pour capturer la signature du créancier
  Future<void> _captureSignature1() async {
    if (_signaturePadKey1.currentState != null) {
      final image =
          await _signaturePadKey1.currentState!.toImage(pixelRatio: 3.0);

      // Convertir l'image en Uint8List pour le PDF
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      if (mounted) {
        context
            .read<ContractPdfBloc>()
            .add(CaptureSignature(0, pngBytes, image));
      }

      // Vérification de null avant d'appeler clear
      if (_signaturePadKey1.currentState != null) {
        _signaturePadKey1.currentState!.clear();
      }
    }
  }

  // Méthode pour naviguer vers la page de signature du débiteur
  Future<void> _navigateToSignaturePage2() async {
    void handleClearButtonPressed() {
      // Vérification de null avant d'appeler clear
      if (_signaturePadKey2.currentState != null) {
        _signaturePadKey2.currentState!.clear();
      }
    }

    final signature = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
           resizeToAvoidBottomInset:false ,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Signature du ${widget.partie[1]}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3200d5)),
            ),
          ),
          body: Stack(
            children: [
              Linear(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(context.rs(12)),
                    child: SizedBox(
                      height: context.rs(600),
                      width: context.rs(355),
                      child: SfSignaturePad(
                        key: _signaturePadKey2,
                        backgroundColor: Colors.transparent,
                        strokeColor: Color(0xFF0D47A1),
                        minimumStrokeWidth: 1.0,
                        maximumStrokeWidth: 4.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "clear2",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                onPressed: handleClearButtonPressed,
                child: Icon(
                  Icons.clear_outlined,
                  size: 30,
                ),
              ),
              FloatingActionButton(
                heroTag: "save2",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Icon(
                  Icons.save_as_rounded,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (signature == true) {
      await _captureSignature2();
    }
  }

  // Méthode pour capturer la signature du débiteur
  Future<void> _captureSignature2() async {
    if (_signaturePadKey2.currentState != null) {
      final image =
          await _signaturePadKey2.currentState!.toImage(pixelRatio: 3.0);

      // Convertir l'image en Uint8List pour le PDF
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      if (mounted) {
        context
            .read<ContractPdfBloc>()
            .add(CaptureSignature(1, pngBytes, image));
      }
      // Vérification de null avant d'appeler clear
      if (_signaturePadKey2.currentState != null) {
        _signaturePadKey2.currentState!.clear();
      }
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
                  const Text('PDF généré avec succès',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              backgroundColor: Colors.green.shade600,
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
            ),
          );
        }

        if (state.processedDocument != null &&
            _quillController.document.isEmpty()) {
          _quillController.document = Document.fromJson(state.processedDocument!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: context.rs(80),
            title: Text(
              'E-contrat',
              style: TextStyle(
                  color: scheme.primary,
                  fontFamily: 'Outfit',
                  fontSize: context.rf(28),
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5),
            ),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: scheme.primary),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.white.withValues(alpha: 0.7),
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
            ),
            actions: [
              _buildSignatureAction(
                context,
                hasSignature: state.hasSignature1,
                label: widget.partie[0],
                icon: Icons.draw_rounded,
                onPressed: _navigateToSignaturePage1,
              ),
              _buildSignatureAction(
                context,
                hasSignature: state.hasSignature2,
                label: widget.partie[1],
                icon: Icons.gesture_rounded,
                onPressed: _navigateToSignaturePage2,
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: FloatingActionButton.small(
                  onPressed: state.status == ContractPdfStatus.loading
                      ? null
                      : () {
                          ConfirmationDialog.show(
                            context,
                            icon: Icons.print_rounded,
                            confirmColor: scheme.primary,
                            title: 'Enregistrer le contrat ?',
                            message: 'Voulez-vous finaliser et sauvegarder ce document PDF ?',
                            onConfirm: () {
                              context.read<ContractPdfBloc>().add(
                                    GeneratePdfRequested(
                                      content: _quillController.document.toDelta(),
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
                  child: const Icon(Icons.print_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              const Linear(),
              if (state.status == ContractPdfStatus.loading)
                const LoadingScreen(),
              Column(
                children: [
                   SizedBox(height: MediaQuery.of(context).padding.top + context.rs(80)),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(context.rs(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.rs(24)),
                        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: context.rs(20),
                            offset: Offset(0, context.rs(10)),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (Platform.isMacOS || Platform.isWindows || Platform.isLinux)
                            _buildToolbar(context),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CustomQuillEditor(
                                node: _editorNode,
                                controller: _quillController,
                                defaultFontFamily: 'Arial',
                                scrollController: _scrollController,
                                onChange: (Document document) {
                                  if (oldDelta == document.toDelta()) return;
                                  oldDelta = document.toDelta();
                                  if (mounted && !_shouldShowToolbar.value) {
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
                  if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia)
                    ValueListenableBuilder<bool>(
                      valueListenable: _shouldShowToolbar,
                      builder: (_, value, __) => Visibility(
                        visible: value,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildToolbar(context, isMobile: true),
                        ),
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

  Widget _buildSignatureAction(BuildContext context,
      {required bool hasSignature, required String label, required IconData icon, required VoidCallback onPressed}) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Stack(
          children: [
            Icon(icon, color: hasSignature ? Colors.green : scheme.primary),
            if (hasSignature)
              const Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.check, size: 8, color: Colors.green),
                ),
              ),
          ],
        ),
        tooltip: 'Signature de $label',
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, {bool isMobile = false}) {
    return QuillSimpleToolbar(
      controller: _quillController,
      config: QuillSimpleToolbarConfig(
        toolbarSize: 55,
        color: Colors.transparent,
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
    );
  }
}
}
