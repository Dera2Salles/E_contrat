import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:e_contrat/page/custom_quill_editor.dart';
import 'package:e_contrat/page/constants.dart';
import 'package:e_contrat/page/fonts_loader.dart';
import 'package:e_contrat/page/linear.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:pdf/pdf.dart' as dartpdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:animated_text_kit/animated_text_kit.dart';



final FontsLoader loader = FontsLoader();

final kQuillDefaultSample = [
  {'insert': '\n'}
];
// Mandeha ny POST


class PdfQuill extends StatefulWidget {
  const PdfQuill({super.key});

  @override
  State<PdfQuill> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PdfQuill> {
  bool firstEntry = false;
  final PDFPageFormat params = PDFPageFormat.a4;
  final QuillController _quillController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0));
  final FocusNode _editorNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _shouldShowToolbar = ValueNotifier<bool>(false);
  Delta? oldDelta;
  
  // Propriétés pour la gestion des signatures
  ui.Image? _signatureImage1; // Signature du créancier
  ui.Image? _signatureImage2; // Signature du débiteur
  final GlobalKey<SfSignaturePadState> _signaturePadKey1 = GlobalKey<SfSignaturePadState>();
  final GlobalKey<SfSignaturePadState> _signaturePadKey2 = GlobalKey<SfSignaturePadState>();
  bool _hasCapturedSignature1 = false;
  bool _hasCapturedSignature2 = false;

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
      _signaturePadKey1.currentState!.clear();
    }

    final signature = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Signature du créancier',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              Linear(),
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
                alignment: Alignment(-1, -10),
                child: SvgPicture.asset(
                  'assets/svg/editor.svg',
                  width: 370.h,
                  height: 370.w,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      height: 80.h,
                      width: 91.w,
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
      final image = await _signaturePadKey1.currentState!.toImage(pixelRatio: 3.0);

      setState(() {
        _signatureImage1 = image;
        _hasCapturedSignature1 = true;
      });

      _signaturePadKey1.currentState!.clear();
    }
  }

  // Méthode pour naviguer vers la page de signature du débiteur
  Future<void> _navigateToSignaturePage2() async {
    void handleClearButtonPressed() {
      _signaturePadKey2.currentState!.clear();
    }

    final signature = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Signature du débiteur',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              Linear(),
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
                alignment: Alignment(-1, -10),
                child: SvgPicture.asset(
                  'assets/svg/editor.svg',
                  width: 370.h,
                  height: 370.w,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      height: 80.h,
                      width: 91.w,
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
      final image = await _signaturePadKey2.currentState!.toImage(pixelRatio: 3.0);

      setState(() {
        _signatureImage2 = image;
        _hasCapturedSignature2 = true;
      });

      _signaturePadKey2.currentState!.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 188, 255),
        title: const Text('Éditeur de document'),
        actions: [
          // Bouton pour la signature du créancier
          IconButton(
            icon: const Icon(Icons.gesture, color: Colors.white),
            tooltip: 'Signature du créancier',
            onPressed: () {
              if (mounted) {
                _navigateToSignaturePage1();
              }
            },
          ),
          // Bouton pour la signature du débiteur
          IconButton(
            icon: const Icon(Icons.draw, color: Colors.white),
            tooltip: 'Signature du débiteur',
            onPressed: () {
              if (mounted) {
                _navigateToSignaturePage2();
              }
            },
          ),
          // Indicateurs de statut des signatures
          if (_hasCapturedSignature1)
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
          if (_hasCapturedSignature2)
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Générer PDF',
            onPressed: () async {
              try {
                // S'assurer que les polices sont chargées avant de générer le PDF
                await loader.loadFonts();

                final bool isAndroid = Platform.isAndroid;
                // on android devices is not available getSaveLocation
                final Object? result = isAndroid
                    ? await getDirectoryPath(
                        confirmButtonText: 'Select directory')
                    : await getSaveLocation(
                        suggestedName: 'document_pdf',
                        acceptedTypeGroups: [
                          XTypeGroup(
                            label: 'Pdf',
                            extensions: ['pdf'],
                            mimeTypes: ['application/pdf'],
                            uniformTypeIdentifiers: ['com.adobe.pdf'],
                          ),
                        ],
                      );
                if (result == null) {
                  return;
                }
                final File file = isAndroid
                    ? File('${result as String}/document_${DateTime.now().millisecondsSinceEpoch}.pdf')
                    : File((result as FileSaveLocation).path);
                
                // Préparer les données des signatures pour les inclure dans le PDF
                ui.Image? signature1 = _signatureImage1;
                ui.Image? signature2 = _signatureImage2;
                
                Uint8List? signatureBytes1;
                Uint8List? signatureBytes2;
                
                // Convertir les images de signature en bytes pour le PDF
                if (signature1 != null) {
                  final byteData1 = await signature1.toByteData(format: ui.ImageByteFormat.png);
                  if (byteData1 != null) {
                    signatureBytes1 = byteData1.buffer.asUint8List();
                  }
                }
                
                if (signature2 != null) {
                  final byteData2 = await signature2.toByteData(format: ui.ImageByteFormat.png);
                  if (byteData2 != null) {
                    signatureBytes2 = byteData2.buffer.asUint8List();
                  }
                }
                
                PDFConverter pdfConverter = PDFConverter(
                  backMatterDelta: null,
                  frontMatterDelta: null,
                  isWeb: kIsWeb,
                  document: _quillController.document.toDelta(),
                  fallbacks: [...loader.allFonts()],
                  onRequestFontFamily: (FontFamilyRequest familyRequest) {
                    final normalFont =
                        loader.getFontByName(fontFamily: familyRequest.family);
                    final boldFont = loader.getFontByName(
                      fontFamily: familyRequest.family,
                      bold: familyRequest.isBold,
                    );
                    final italicFont = loader.getFontByName(
                      fontFamily: familyRequest.family,
                      italic: familyRequest.isItalic,
                    );
                    final boldItalicFont = loader.getFontByName(
                      fontFamily: familyRequest.family,
                      bold: familyRequest.isBold,
                      italic: familyRequest.isItalic,
                    );
                    return FontFamilyResponse(
                      fontNormalV: normalFont,
                      boldFontV: boldFont,
                      italicFontV: italicFont,
                      boldItalicFontV: boldItalicFont,
                      fallbacks: [
                        normalFont,
                        italicFont,
                        boldItalicFont,
                      ],
                    );
                  },
                  pageFormat: params,
                );
                try {
                  // Créer le document PDF avec le contenu de l'éditeur
                  final document = await pdfConverter.createDocument();
                  if (document == null) {
                    _editorNode.unfocus();
                    _shouldShowToolbar.value = false;
                    if (mounted) {
                      final messenger = ScaffoldMessenger.of(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Le fichier ne peut pas être généré en raison d\'une erreur'),
                            ),
                          );
                        }
                      });
                    }
                    return;
                  }

                  // Générer les bytes du PDF
                  final Uint8List originalPdfBytes = await document.save();
                  await file.writeAsBytes(originalPdfBytes);

                  // Si nous avons des signatures, modifier le PDF pour les inclure
                  if (signatureBytes1 != null || signatureBytes2 != null) {
                    try {
                      final existingPdfBytes = await file.readAsBytes();
                      final existingPdf = PdfDocument(inputBytes: existingPdfBytes);
                      final pageCount = existingPdf.pages.count;
                      final List<Uint8List> pageImages = [];
                      for (int i = 0; i < pageCount; i++) {
                        final page = existingPdf.pages[i];
                        final pageImage = await page.render(width: page.size.width.toInt(), height: page.size.height.toInt());
                        if (pageImage != null) {
                          pageImages.add(pageImage.buffer.asUint8List());
                        }
                      }
                      final pdfDoc = pw.Document();
                      final pageFormat = dartpdf.PdfPageFormat.a4;
                      for (int i = 0; i < pageImages.length; i++) {
                        pdfDoc.addPage(
                          pw.Page(
                            pageFormat: pageFormat,
                            build: (pw.Context context) {
                              return pw.Stack(
                                children: [
                                  pw.Image(pw.MemoryImage(pageImages[i]), fit: pw.BoxFit.contain),
                                  if (signatureBytes1 != null && i == pageCount - 1)
                                    pw.Positioned(
                                      left: 50,
                                      bottom: 100,
                                      child: pw.Column(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text('Signature du créancier:', style: pw.TextStyle(fontSize: 10)),
                                          pw.SizedBox(height: 5),
                                          pw.Image(
                                            pw.MemoryImage(signatureBytes1),
                                            height: 60,
                                            width: 120,
                                            fit: pw.BoxFit.contain,
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (signatureBytes2 != null && i == pageCount - 1)
                                    pw.Positioned(
                                      right: 50,
                                      bottom: 100,
                                      child: pw.Column(
                                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                                        children: [
                                          pw.Text('Signature du débiteur:', style: pw.TextStyle(fontSize: 10)),
                                          pw.SizedBox(height: 5),
                                          pw.Image(
                                            pw.MemoryImage(signatureBytes2),
                                            height: 60,
                                            width: 120,
                                            fit: pw.BoxFit.contain,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      final Uint8List finalPdfBytes = await pdfDoc.save();
                      await file.writeAsBytes(finalPdfBytes);
                      debugPrint('PDF généré avec succès avec les signatures incluses');
                    } catch (e) {
                      debugPrint('Erreur lors de l\'inclusion des signatures: $e');
                    }
                  }

                  if (mounted) {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('PDF généré avec succès'),
                        action: SnackBarAction(
                          label: 'Ouvrir',
                          onPressed: () {
                            if (file.existsSync()) {
                              OpenFile.open(file.path);
                            }
                          },
                        ),
                      ),
                    );
                  }
                } catch (e, stackTrace) {
                  debugPrint("Erreur lors de la génération du PDF : $e");
                  debugPrint("Stack trace : $stackTrace");
                  if (mounted) {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text('Erreur lors de l\'enregistrement du PDF: $e'),
                        ));
                      }
                    });
                  }
                }
              } catch (e, stackTrace) {
                debugPrint("Erreur lors de la génération du PDF : $e");
                debugPrint("Stack trace : $stackTrace");
                if (mounted) {
                  final messenger = ScaffoldMessenger.of(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('Erreur : $e')),
                      );
                    }
                  });
                }
              }
              },
              icon: const Icon(
                Icons.print,
                color: Colors.white,
              ),
            ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Scrollbar(
                controller: _scrollController,
                notificationPredicate: (ScrollNotification notification) {
                  if (mounted && firstEntry) {
                    firstEntry =
                        false; //avoid issue with column (Ln225,Col49) that mnakes false scroll
                    setState(() {});
                  }
                  return notification.depth == 0;
                },
                interactive: true,
                radius: const Radius.circular(10),
                child: Column(
                  children: <Widget>[
                    if (Platform.isMacOS ||
                        Platform.isWindows ||
                        Platform.isLinux)
                      QuillSimpleToolbar(
                        controller: _quillController,
                        config: QuillSimpleToolbarConfig(
                          toolbarSize: 55,
                          linkStyleType: LinkStyleType.original,
                          headerStyleType: HeaderStyleType.buttons,
                          showAlignmentButtons: true,
                          multiRowsDisplay: true,
                          showLineHeightButton: true,
                          showDirection: true,
                          buttonOptions: const QuillSimpleToolbarButtonOptions(
                            selectLineHeightStyleDropdownButton:
                                QuillToolbarSelectLineHeightStyleDropdownButtonOptions(),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: CustomQuillEditor(
                          node: _editorNode,
                          controller: _quillController,
                          defaultFontFamily: Constant.DEFAULT_FONT_FAMILY,
                          scrollController: _scrollController,
                          onChange: (Document document) {
                            if (oldDelta == document.toDelta()) return;
                            oldDelta = document.toDelta();
                            if (mounted) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!_shouldShowToolbar.value) {
                                  _shouldShowToolbar.value = true;
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    if (Platform.isIOS ||
                        Platform.isAndroid ||
                        Platform.isFuchsia)
                      ValueListenableBuilder<bool>(
                        valueListenable: _shouldShowToolbar,
                        builder: (BuildContext _, bool value, __) => Visibility(
                          visible: value,
                          child: QuillSimpleToolbar(
                            controller: _quillController,
                            config: QuillSimpleToolbarConfig(
                              multiRowsDisplay: false,
                              toolbarSize: 55,
                              linkStyleType: LinkStyleType.original,
                              headerStyleType: HeaderStyleType.buttons,
                              buttonOptions:
                                  const QuillSimpleToolbarButtonOptions(
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
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingWithAnimtedWidget extends StatelessWidget {
  final String text;
  final double verticalTextPadding;
  final double? heightWidget;
  final double? spaceBetween;
  final double strokeWidth;
  final TextStyle? style;
  final Duration duration;
  final Color? loadingColor;
  final bool infinite;
  const LoadingWithAnimtedWidget({
    super.key,
    required this.text,
    this.loadingColor,
    this.strokeWidth = 7,
    this.spaceBetween,
    this.duration = const Duration(milliseconds: 260),
    this.infinite = false,
    this.style,
    this.heightWidget,
    this.verticalTextPadding = 30,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      child: Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: heightWidget ?? size.height * 0.45,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  color: loadingColor,
                ),
                SizedBox(height: spaceBetween ?? 10),
                AnimatedWavyText(
                  infinite: infinite,
                  duration: duration,
                  text: text,
                  style: style ??
                      const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                  verticalPadding: verticalTextPadding,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedWavyText extends StatelessWidget {
  final double verticalPadding;
  final Key? animatedKey;
  final String text;
  final bool infinite;
  final int totalRepeatCount;
  final Duration duration;
  final TextStyle? style;
  const AnimatedWavyText({
    super.key,
    this.animatedKey,
    this.verticalPadding = 50,
    required this.text,
    this.infinite = false,
    this.totalRepeatCount = 4,
    this.duration = const Duration(milliseconds: 260),
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: AnimatedTextKit(
        key: animatedKey,
        repeatForever: infinite,
        animatedTexts: <AnimatedText>[
          WavyAnimatedText(
            text,
            speed: duration,
            textStyle: style ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
        displayFullTextOnTap: true,
        totalRepeatCount: totalRepeatCount < 1 ? 1 : totalRepeatCount,
      ),
    );
  }
}