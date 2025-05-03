import 'dart:io';
// dart:typed_data est déjà fourni par flutter/services.dart
import 'dart:ui' as ui;
import 'package:e_contrat/page/confirm.dart';
import 'package:e_contrat/page/grid.dart';
import 'package:e_contrat/page/loading.dart';
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
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_contrat/page/savepdf.dart';




final FontsLoader loader = FontsLoader();
class PdfQuill extends StatefulWidget {

   final Map<String, String> formData;
  final List<dynamic> documentModel;
  final List<String> placeholder;
   final List<String> partie; // Modèle de document à utiliser
  const PdfQuill({super.key, required this.documentModel, required this.formData, required this.partie, required this.placeholder});

  @override
  State<PdfQuill> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PdfQuill> {
  
  bool _isGeneratingPdf = false;
  bool firstEntry = false;
  final PDFPageFormat params = PDFPageFormat.a4;
  late final QuillController _quillController =QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0)
    );
  
  @override
  void initState() {
    super.initState();

    setState(() {
       final documentData = widget.documentModel.map((op) {
      if (op['insert'] is String){
        String text = op['insert'];
        // Replace placeholders with formData values
        widget.formData.forEach((key, value) {
          text = text.replaceAll('[$key]', value);
        });
        return {
          'insert': text,
          'attributes': op['attributes'],
        };
      }
      return op;
    }).toList();
  
      final newDocument = Document.fromJson(documentData);
      _quillController.document = newDocument;
    });
  
   
  }
  
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
  Uint8List? _signatureBytes1; // Bytes de la signature du créancier pour le PDF
  Uint8List? _signatureBytes2; // Bytes de la signature du débiteur pour le PDF
  
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
              Positioned(
            top:-1.1.h,
            left: -7.w,
         
           child: SvgPicture.asset(
            'assets/svg/editor.svg',
            width: 100.w,
            height:100.h,
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
      
      // Convertir l'image en Uint8List pour le PDF
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      setState(() {
        _signatureImage1 = image;
        _signatureBytes1 = pngBytes;
        _hasCapturedSignature1 = true;
      });

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
               Positioned(
            top:-1.1.h,
            left: -7.w,
         
           child: SvgPicture.asset(
            'assets/svg/editor.svg',
            width: 100.w,
            height:100.h,
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
      
      // Convertir l'image en Uint8List pour le PDF
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      setState(() {
        _signatureImage2 = image;
        _signatureBytes2 = pngBytes;
        _hasCapturedSignature2 = true;
      });
      // Vérification de null avant d'appeler clear
      if (_signaturePadKey2.currentState != null) {
        _signaturePadKey2.currentState!.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset:false ,
       extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('  E-contrat', style: TextStyle(
          color: Color(0xFF3200d5),
          fontSize: 25,
           fontWeight: FontWeight.bold

        ),
        ),
          automaticallyImplyLeading: false,
        backgroundColor:  Colors.transparent,
        actions: [
          // Bouton pour la signature du créancier // Bouton pour la signature du débiteur
          IconButton(
            icon: _hasCapturedSignature1 ?  const Icon(Icons.check_circle, color: Colors.green, size: 20) : const Icon(Icons.draw, color: Color(0xFF3200d5)),
            tooltip: 'Signature du ${widget.partie[0]}',
            onPressed: () {
              if (mounted) {
                _navigateToSignaturePage1();
              }
            },
          ),
           IconButton(
            icon: _hasCapturedSignature2 ?  const Icon(Icons.check_circle, color: Colors.green, size: 20) :   const Icon(Icons.gesture, color: Color(0xFF3200d5),),
            tooltip: 'Signature du ${widget.partie[1]}',
            onPressed: () {
              if (mounted) {
                _navigateToSignaturePage2();
              }
            },
          ),
          IconButton(
            tooltip: 'Générer PDF',
            onPressed:_isGeneratingPdf ? null : ()  {
              ConfirmationDialog.show(
                        context,
                        icon:Icons.print,
                        confirmColor:Color(0xFF3200d5) ,
                        title: 'Voulez-vous vraiment enregistrer ?',
                        message: 'Aucune modification n\'est possible apres cette action',
                      onConfirm: ()async{

              try {
              
               Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(),
      ),);
                // S'assurer que les polices sont chargées avant de générer le PDF
                await loader.loadFonts();

                final File file = File('/data/user/0/com.example.e_contrat/app_flutter/document_${DateTime.now().millisecondsSinceEpoch}.pdf') ;// Nom du Document
                    
                
                // Utiliser les bytes des signatures déjà stockés
                Uint8List? signatureBytes1 = _signatureBytes1;
                Uint8List? signatureBytes2 = _signatureBytes2;
                
                // Si les bytes ne sont pas disponibles mais que les images le sont, convertir les images
                if (signatureBytes1 == null && _signatureImage1 != null) {
                  final byteData1 = await _signatureImage1!.toByteData(format: ui.ImageByteFormat.png);
                  if (byteData1 != null) {
                    signatureBytes1 = byteData1.buffer.asUint8List();
                    // Stocker pour future utilisation
                    _signatureBytes1 = signatureBytes1;
                  }
                }
                
                if (signatureBytes2 == null && _signatureImage2 != null) {
                  final byteData2 = await _signatureImage2!.toByteData(format: ui.ImageByteFormat.png);
                  if (byteData2 != null) {
                    signatureBytes2 = byteData2.buffer.asUint8List();
                    // Stocker pour future utilisation
                    _signatureBytes2 = signatureBytes2;
                  }
                }
                 setState(() => _isGeneratingPdf = true);
                debugPrint('État des signatures: Signature1: ${signatureBytes1 != null}, Signature2: ${signatureBytes2 != null}');
                try {
                  // Créer un document PDF sécurisé en supprimant les formatages qui pourraient causer des erreurs
                  // D'abord, créons une copie simplifiée du Delta qui contient uniquement le texte
                  Delta safeDelta = Delta();
                  final originalDelta = _quillController.document.toDelta();

                  try {
                    // Parcourir les opérations de l'original et créer une version simplifiée
                    for (final op in originalDelta.operations) {
                      if (op.value is String) {
                        // Pour les insertions de texte, conserver uniquement le texte
                        safeDelta.insert(op.value);
                      } else if (op.value is Map) {
                        final Map valueMap = op.value as Map;
                        // Pour les autres types (images, etc.), les conserver mais simplifier les attributs
                        if (valueMap.containsKey('insert')) {
                          final Map<String, dynamic> attributes = {};
                          // Conserver uniquement certains attributs essentiels et sécurisés
                          if (op.attributes != null) {
                            if (op.attributes!.containsKey('align')) {
                              attributes['align'] = op.attributes!['align'];
                            }
                            if (op.attributes!.containsKey('header')) {
                              attributes['header'] = op.attributes!['header'];
                            }
                          }
                          safeDelta.insert(valueMap['insert'], attributes.isNotEmpty ? attributes : null);
                        }
                      }
                    }
                  } catch (e) {
                    debugPrint('Erreur lors de la simplification du document: $e');
                    // En cas d'échec, créer un Delta contenant uniquement le texte brut
                    final plainText = _quillController.document.toPlainText();
                    safeDelta = Delta()..insert(plainText);
                  }

                  // Utiliser la version sécurisée pour la conversion en PDF
                  final safeConverter = PDFConverter(
                    backMatterDelta: null,
                    frontMatterDelta: null,
                    isWeb: kIsWeb,
                    document: safeDelta,
                    fallbacks: [...loader.allFonts()],
                    onRequestFontFamily: (FontFamilyRequest familyRequest) {
                      // Utiliser une police de base pour tout
                      final normalFont = loader.getFontByName(fontFamily: familyRequest.family);
                      return FontFamilyResponse(
                        fontNormalV: normalFont,
                        boldFontV: normalFont,
                        italicFontV: normalFont,
                        boldItalicFontV: normalFont,
                        fallbacks: [normalFont],
                      );
                    },
                    pageFormat: params,
                  );
                  
                  // Générer le document PDF avec le contenu simplifié
                  final document = await safeConverter.createDocument();
                  if (document == null) {
                    _editorNode.unfocus();
                    _shouldShowToolbar.value = false;
                    if (mounted) {
                      // ignore: use_build_context_synchronously
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

                  // Générer les bytes du PDF en gérant les erreurs potentielles
                  Uint8List originalPdfBytes;
                  try {
                    originalPdfBytes = await document.save();
                    await file.writeAsBytes(originalPdfBytes);
                    
                  } catch(e) {
                    debugPrint('Erreur lors de la génération du PDF: $e');
                    // Créer un document PDF simplifié en cas d'échec
                    final pw.Document fallbackDoc = pw.Document();
                    final plainText = _quillController.document.toPlainText();
                    
                    fallbackDoc.addPage(
                      pw.Page(
                        build: (pw.Context context) {
                          return pw.Center(
                            child: pw.Text(
                              plainText,
                              style: pw.TextStyle(font:  loader.loraFont()),
                            ),
                          );
                        },
                      ),
                    );
                    
                    originalPdfBytes = await fallbackDoc.save();
                    await file.writeAsBytes(originalPdfBytes);
                  }

                  // Méthode simplifiée pour inclure les signatures directement dans le PDF existant
                  if (signatureBytes1 != null || signatureBytes2 != null) {
                    try {
                      debugPrint('Ajout des signatures au PDF...');
                      // Ouvrir le PDF existant et y ajouter directement les signatures
                      final existingPdfBytes = await file.readAsBytes();
                      final existingPdf = PdfDocument(inputBytes: existingPdfBytes);
                      
                      // Travailler sur la dernière page
                      if (existingPdf.pages.count > 0) {
                        PdfPage lastPage = existingPdf.pages[existingPdf.pages.count - 1];
                        PdfGraphics graphics = lastPage.graphics;
                        final pageHeight = lastPage.size.height;
                        final pageWidth = lastPage.size.width;
                        
                        // Définir une police pour les légendes
                        PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
                        
                        // Ajouter la signature du créancier (à droite)
                        if (signatureBytes2 != null) {
                          debugPrint('Ajout signature créancier');
                          PdfBitmap signature2 = PdfBitmap(signatureBytes2);
                          
                          // Ajouter la légende
                          graphics.drawString('        ${widget.partie[1]}', font, 
                              brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                              bounds: Rect.fromLTWH(pageWidth - 170, pageHeight - 150, 150, 20));
                          
                          // Ajouter l'image de la signature
                          graphics.drawImage(signature2, 
                              Rect.fromLTWH(pageWidth - 170, pageHeight - 140, 150, 80));
                        }
                        
                        // Ajouter la signature du débiteur (à gauche)
                        if (signatureBytes1 != null) {
                          debugPrint('Ajout signature débiteur $pageWidth');
                          PdfBitmap signature1 = PdfBitmap(signatureBytes1);
                          
                          // Ajouter la légende
                          graphics.drawString('      ${widget.partie[0]}', font, 
                              brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                              bounds: Rect.fromLTWH(655-pageWidth , pageHeight - 150, 150, 20));
                          
                          // Ajouter l'image de la signature
                          graphics.drawImage(signature1, 
                              Rect.fromLTWH(30, pageHeight - 140, 150, 80));
                        }
                      }
                      
                      // Sauvegarder le PDF modifié
                      final List<int> modifiedPdfBytes = await existingPdf.save();

                      await savePdf(modifiedPdfBytes, '${widget.documentModel.first['insert']} entre ${widget.formData[widget.placeholder[0]]} et ${widget.formData[widget.placeholder[2]]}');
                      
                      if ( await file.exists()){
                          file.delete();
                          debugPrint('PDF généré Temporaire supprime');

                      }
                    
      
                      existingPdf.dispose();
                       // Libérer les ressources
                      
                      debugPrint('PDF généré avec succès avec les signatures incluses');
                      debugPrint(' formData : ${widget.formData}');
                    } catch (e, stack) {
                      debugPrint('Erreur lors de l\'inclusion des signatures: $e');
                      debugPrint('Stack trace: $stack');
                    }
                  }

                  if (mounted) {
                     setState(() => _isGeneratingPdf = false);
                     // ignore: use_build_context_synchronously
                     Navigator.pop(context);
                    // ignore: use_build_context_synchronously
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('PDF généré avec succès',    textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,color: const ui.Color.fromARGB(255, 0, 233, 8)
                          
                        ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                       
                      ),
                      
                      
                    );
                     // ignore: use_build_context_synchronously
                     Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context)=>Grid()),
                      (route)=> false,
                      );
                       
                  }
                } catch (e, stackTrace) {
                  debugPrint("Erreur lors de la génération du PDF : $e");
                  debugPrint("Stack trace : $stackTrace");
                  if (mounted) {
                    // ignore: use_build_context_synchronously
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
                  // ignore: use_build_context_synchronously
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
            }
        );
},
              // Utilise seulement l'icône une fois
              icon: const Icon(Icons.print, color: Color(0xFF3200d5),),
            ),
            SizedBox(width: 3.w,)
        ],
        
      ),
      body: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
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
            height:35.h,
           ),
             ),
           ) ,
          Positioned(
            top:-1.1.h,
            left: -7.w,
         
           child: SvgPicture.asset(
            'assets/svg/editor.svg',
            width: 100.w,
            height:100.h,
           ),
             ),
              if (_isGeneratingPdf)
            Column(
              children: [
                const LinearProgressIndicator(
                  minHeight: 4,
                  backgroundColor: Color(0xFF3200d5),
                ),
              ],
            ),
          Positioned( // position du ndao e contrat
            top: 8.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(5),
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
                            defaultFontFamily: 'Arial', // Utilise une police fixe à la place de Constant.DEFAULT_FONT_FAMILY
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
                                color: Colors.transparent,
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