import 'dart:ui' as ui;
import 'package:e_contrat/page/linear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class PreviewScreen extends StatefulWidget {
  final Map<String, String>? formData;
  final dynamic quillContent;
  final GlobalKey<SfSignaturePadState>? signaturePadKey;

  const PreviewScreen({
    super.key,
    this.formData,
    this.quillContent,
    this.signaturePadKey,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  static const double _scaleFactor = 3.78;
  static const double _a4WidthMm = 210;
  static const double _a4HeightMm = 297;

  final Map<String, Offset> _elementPositions = {
    "Nom": const Offset(20, 20),
    "Date": const Offset(20, 60),
    "Montant": const Offset(20, 100),
    "Motif": const Offset(20, 140),
    "Signature": const Offset(20, 200),
  };

  late final QuillController _quillController;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  final GlobalKey _stackKey = GlobalKey();
  ui.Image? _signatureImage1;
  ui.Image? _signatureImage2;
  Uint8List? _signatureBytes1; // Pour stocker la signature en format Uint8List
  Uint8List? _signatureBytes2; // Pour stocker la signature en format Uint8List
  bool _isGeneratingPdf = false;
  GlobalKey<SfSignaturePadState>? _localSignaturePadKey1;
  GlobalKey<SfSignaturePadState>? _localSignaturePadKey2;

  @override
  void initState() {
    super.initState();
    _localSignaturePadKey1 = widget.signaturePadKey ?? GlobalKey<SfSignaturePadState>();
    _localSignaturePadKey2 = widget.signaturePadKey ?? GlobalKey<SfSignaturePadState>();
    _initializeQuillController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _quillController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final formData = args?['formData'] as Map<String, String>? ?? widget.formData ?? {};
     final quillContentRaw = args?['quillContent'] ?? widget.quillContent;
    String motifText = 'Non défini';
    if (quillContentRaw is Map<String, dynamic> && quillContentRaw['ops'] is List) {
      final ops = quillContentRaw['ops'] as List;
      if (ops.isNotEmpty && ops[0] is Map && ops[0]['insert'] is String) {
        motifText = ops[0]['insert'];
      }
    } else if (quillContentRaw is String) {
      motifText = quillContentRaw;
    }



 


  Future<pw.Font> loadPdfFont() async {
    try {
      final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
      return pw.Font.ttf(fontData);
    } catch (e) {
      // Fallback to default font if custom font fails
      final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
      return pw.Font.ttf(fontData);
    }
  }

  // double mmToPoints(double mm) {
  //   return mm * 2.83465;
  // }

  Future<void> sharePdf(Uint8List pdfBytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/document.pdf').writeAsBytes(pdfBytes);
    
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Document PDF',
      text: 'Voici le document généré',
    );
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }


  Future<Uint8List> generatePdfBytes() async {
  final pdfDoc = pw.Document();
  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  final formData = args?['formData'] as Map<String, String>? ?? widget.formData ?? {};

  // Utilise directement les bytes stockés s'ils existent, sinon convertit l'image
  final signatureBytes1 = _signatureBytes1 ?? (_signatureImage1 != null
      ? (await _signatureImage1!.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List()
      : null);

  final signatureBytes2 = _signatureBytes2 ?? (_signatureImage2 != null
      ? (await _signatureImage2!.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List()
      : null);

  final font = await loadPdfFont();

  // Facteur de conversion complet (écran -> PDF)
  // _scaleFactor est utilisé pour l'affichage à l'écran (mm -> pixels)
  // 2.83465 est le facteur mm -> points
  // On combine les deux pour obtenir le facteur pixels écran -> points PDF
  final double screenToPdfFactor = 0.9;

  pdfDoc.addPage(
    pw.Page(
      pageFormat: pdf.PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Stack(
          children: [
            ...formData.entries.map((entry) {
              final position = _elementPositions[entry.key] ?? const Offset(20, 20);
              return pw.Positioned(
                left: position.dx * screenToPdfFactor,
                top: position.dy * screenToPdfFactor,
                child: pw.Text(
                  "${entry.key}: ${entry.value}",
                  style: pw.TextStyle(font: font, fontSize: 14), // Taille de police augmentée
                ),
              );
            }),
            
            pw.Positioned(
              left: _elementPositions["Motif"]!.dx * screenToPdfFactor,
              top: _elementPositions["Motif"]!.dy * screenToPdfFactor,
              child: pw.Container(
                width: 500 * screenToPdfFactor,
                child: pw.Text(
                  motifText,
                  style: pw.TextStyle(font: font, fontSize: 14),
                ),
              ),
            ),
            
            // Signature du créancier avec légende
            if (signatureBytes1 != null)
              pw.Positioned(
                right: 10* screenToPdfFactor,
                bottom: 10 * screenToPdfFactor,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "Signature du créancier",
                        style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.SizedBox(height: 5 * screenToPdfFactor),
                    pw.Image(
                      pw.MemoryImage(signatureBytes1),
                      width: 300 * screenToPdfFactor,
                      height: 200 * screenToPdfFactor,
                    ),
                  ],
                ),
              ),
            // Signature du débiteur avec légende
            if (signatureBytes2 != null)
              pw.Positioned(
                left: 10* screenToPdfFactor,
                bottom: 10 * screenToPdfFactor,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "Signature du débiteur",
                        style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.SizedBox(height: 5 * screenToPdfFactor),
                    pw.Image(
                      pw.MemoryImage(signatureBytes2),
                      width: 300 * screenToPdfFactor,
                      height: 200 * screenToPdfFactor,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    ),
  );

  return pdfDoc.save();
}



 Future<void> generateAndSharePdf() async {
    setState(() => _isGeneratingPdf = true);

    try {
      if ( (_localSignaturePadKey1?.currentState != null) && (_localSignaturePadKey2?.currentState != null)) {
        await _captureSignature1();
        await _captureSignature2();
      }

      final pdfBytes = await generatePdfBytes();
      await sharePdf(pdfBytes);
    } catch (e) {
      showErrorSnackbar("Erreur lors de la génération du PDF: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  } 
    return Scaffold(
      appBar:AppBar(
           automaticallyImplyLeading: false,
           elevation: 0,
           backgroundColor: Color.fromARGB(255, 83, 19, 194),
           actions: [
          IconButton(
             icon: const Icon(Icons.save_alt),
             onPressed: _isGeneratingPdf ? null : generateAndSharePdf,
          tooltip: "Générer le PDF",
          color: Colors.white,
          ),
        ],
         
          title: Text('Aperçu du Document',
          
          style: TextStyle(
             fontWeight: FontWeight.bold,
             color: Colors.white
          ),
          ),
        ),
      
      //  AppBar(
      //   title: const Text("Aperçu du Document"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.save_alt),
      //       onPressed: _isGeneratingPdf ? null : _generateAndSharePdf,
      //       tooltip: "Générer le PDF",
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            child: Center(
                child: Container(
                  width: _a4WidthMm * _scaleFactor,
                  height: _a4HeightMm * _scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const ui.Color.fromARGB(255, 197, 164, 164)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(
                    key: _stackKey,
                    children: [
                       Align(
         alignment: Alignment(-1,-10),
           child: SvgPicture.asset(
            'assets/svg/Consent2.svg',
            width: 370.h,
            height:370.w,
           ),
             ),

                      ..._buildFormDataElements(formData),
                     Positioned(
                      top: 200,
                       child: Container(
                               width: 400,
                               padding: const EdgeInsets.all(6),
                               child: Text(
                               " $motifText",
                               style: TextStyle(
                                 color: Colors.black
                               ),
                             ),
                             ),
                     ),
                       Positioned(
                        right: 10,
                        bottom: 10,
                         child: GestureDetector(
                                   onTap: _navigateToSignaturePage1,
                                   child: SizedBox(
                                     width: 200,
                                     height: 100,
                                     child: _signatureImage1 != null
                                         ? RawImage(
                                             image: _signatureImage1,
                                             fit: BoxFit.contain,
                                           )
                                         : const Center(
                                             child: Column(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                          Icon(Icons.edit, size: 30),
                          Text("Ajouter une signature"),
                                               ],
                                             ),
                                           ),
                                   ),
                                 ),
                       ),
                       Positioned(
                        left: 10,
                        bottom: 10,
                         child: GestureDetector(
                                   onTap: _navigateToSignaturePage2,
                                   child: SizedBox(
                                     width: 200,
                                     height: 100,
                                     child: _signatureImage2 != null
                                         ? RawImage(
                                             image: _signatureImage2,
                                             fit: BoxFit.contain,
                                           )
                                         : const Center(
                                             child: Column(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                          Icon(Icons.edit, size: 30),
                          Text("Ajouter une signature"),
                                               ],
                                             ),
                                           ),
                                   ),
                                 ),
                       ),
                    ],
                  ),
                ),
              ),
            ),
          
          if (_isGeneratingPdf)
            const LinearProgressIndicator(
              minHeight: 4,
              backgroundColor:  Color(0xFF3200d5),
            ),
        ],
      ),
    );

  }

  List<Widget> _buildFormDataElements(Map<String, String> formData) {
    return formData.entries.map((entry) {
      return Positioned(
        left: _elementPositions[entry.key]!.dx,
        top: _elementPositions[entry.key]!.dy,
        child: _buildFormDataContainer(entry.key, entry.value),
      );
    }).toList();
  }

// Widget _buildQuillEditorElement(  String motifText) {
//   return Positioned(
//     left: _elementPositions["Motif"]!.dx,
//     top: _elementPositions["Motif"]!.dy,
//     child: _buildDraggableElement(
//       key: "Motif",
//       child: 
//     ),
//   );
// }

void _initializeQuillController() {
  try {
    final content = widget.quillContent ?? {'ops': [{'insert': '\n'}]};
    debugPrint("Contenu Quill reçu: ${content.toString()}");
    
    _quillController = QuillController(
      document: Document.fromJson(content['ops']),
      selection: const TextSelection.collapsed(offset: 0),
    );

    // Force le refresh après initialisation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  } catch (e) {
    debugPrint("Erreur initialisation Quill: $e");
    _quillController = QuillController.basic();
  }
}

  // Widget _buildSignatureElement() {
  //   return Positioned(
  //     left: _elementPositions["Signature"]!.dx,
  //     top: _elementPositions["Signature"]!.dy,
  //     child: _buildDraggableElement(
  //       key: "Signature",
  //       child:
  //     ),
  //   );
  // }

  // Widget _buildDraggableElement({
  //   required String key,
  //   required Widget child,
  // }) {
  //   return Draggable(
  //     feedback: Material(
  //       elevation: 4,
  //       child: SizedBox(
  //         width: key == "Signature" ? 200 : null,
  //         height: key == "Signature" ? 100 : null,
  //         child: child,
  //       ),
  //     ),
  //     childWhenDragging: Opacity(
  //       opacity: 0.5,
  //       child: child,
  //     ),
  //     child: child,
  //     onDragEnd: (details) => _updateElementPosition(details, key),
  //   );
  // }

  Widget _buildFormDataContainer(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        "$label: $value",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  //  void _updateElementPosition(DraggableDetails details, String key) {
  //   final RenderBox stackBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
  //   final stackPosition = stackBox.localToGlobal(Offset.zero);

  //   setState(() {
  //     double newDx = details.offset.dx - stackPosition.dx;
  //     double newDy = details.offset.dy - stackPosition.dy;

  //     double maxWidth = _a4WidthMm * _scaleFactor;
  //     double maxHeight = _a4HeightMm * _scaleFactor;
  //     double elementWidth = key == "Motif" ? 300 : key == "Signature" ? 200 : 100;
  //     double elementHeight = key == "Signature" ? 100 : 50;

  //     _elementPositions[key] = Offset(
  //       newDx.clamp(0, maxWidth - elementWidth),
  //       newDy.clamp(0, maxHeight - elementHeight),
  //     );
  //   });
  // }

  Future<void> _navigateToSignaturePage1() async {
     void handleClearButtonPressed() {
    _localSignaturePadKey1?.currentState!.clear();
  }

    
    final signature = await Navigator.push(
      context,
      MaterialPageRoute(
         builder: (context) =>Scaffold(
    extendBodyBehindAppBar: true,
        appBar: AppBar(
           automaticallyImplyLeading: false,
            centerTitle: true,
           elevation: 0,
           backgroundColor: Colors.transparent,

         
          title: Text('Signature du creancier',
          
          style: TextStyle(
             fontWeight: FontWeight.bold
          ),
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
            height:35.h,
           ),
             ),
           ) ,

          Align(
         alignment: Alignment(-1,-10),
           child: SvgPicture.asset(
            'assets/svg/editor.svg',
            width: 370.h,
            height:370.w,
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
                          key:_localSignaturePadKey1,
                          backgroundColor: Colors.transparent,
                          strokeColor: Color(0xFF0D47A1),
                          minimumStrokeWidth: 1.0,
                          maximumStrokeWidth: 4.0)
                          )
                          )  
            ]
            ),
          ],
        ),
        floatingActionButton:  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        
        children: <Widget>[
                FloatingActionButton(
                  heroTag: "clear",
              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ) ,
                    onPressed: handleClearButtonPressed,
                    child: Icon(Icons.clear_outlined,
                    size: 30,),
                    ),
               FloatingActionButton(
                heroTag: "save",
              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ) ,
                     onPressed:(){Navigator.pop(context, true);}  ,
                    child: Icon(Icons.save_as_rounded,
                    size: 30),
                    ),
              ])
        )
      ),
    );

    if (signature == true) {
      await _captureSignature1();
    }
  }

  Future<void> _captureSignature1() async {
    if (_localSignaturePadKey1?.currentState != null) {
      final image = await _localSignaturePadKey1!.currentState!
          .toImage(pixelRatio: 3.0);
      
      // Convertir l'image en Uint8List pour le PDF
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      
      setState(() {
        _signatureImage1 = image;
        _signatureBytes1 = pngBytes;
      });
      
      // Message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signature du créancier capturée avec succès')),
      );
      
      _localSignaturePadKey1!.currentState!.clear();
    }
  }




  Future<void> _navigateToSignaturePage2() async {
     void handleClearButtonPressed() {
    _localSignaturePadKey2?.currentState!.clear();
  }

    
    final signature = await Navigator.push(
      context,
      MaterialPageRoute(
         builder: (context) =>Scaffold(
    extendBodyBehindAppBar: true,
        appBar: AppBar(
           automaticallyImplyLeading: false,
            centerTitle: true,
           elevation: 0,
           backgroundColor: Colors.transparent,

         
          title: Text('Signature du Debiteur',
          
          style: TextStyle(
             fontWeight: FontWeight.bold
          ),
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
            height:35.h,
           ),
             ),
           ) ,

          Align(
         alignment: Alignment(-1,-10),
           child: SvgPicture.asset(
            'assets/svg/editor.svg',
            width: 370.h,
            height:370.w,
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
                          key:_localSignaturePadKey2,
                          backgroundColor: Colors.transparent,
                          strokeColor: Color(0xFF0D47A1),
                          minimumStrokeWidth: 1.0,
                          maximumStrokeWidth: 4.0)
                          )
                          )  
            ]
            ),
          ],
        ),
        floatingActionButton:  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        
        children: <Widget>[
                FloatingActionButton(
                  heroTag: "clear",
              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ) ,
                    onPressed: handleClearButtonPressed,
                    child: Icon(Icons.clear_outlined,
                    size: 30,),
                    ),
               FloatingActionButton(
                heroTag: "save",
              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ) ,
                     onPressed:(){Navigator.pop(context, true);}  ,
                    child: Icon(Icons.save_as_rounded,
                    size: 30),
                    ),
              ])
        )
      ),
    );

    if (signature == true) {
      await _captureSignature2();
    }
  }

  Future<void> _captureSignature2() async {
    if (_localSignaturePadKey2?.currentState != null) {
      final image = await _localSignaturePadKey2!.currentState!
          .toImage(pixelRatio: 3.0);
      
      // Convertir l'image en Uint8List pour le PDF
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      
      setState(() {
        _signatureImage2 = image;
        _signatureBytes2 = pngBytes;
      });
      
      // Message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signature du débiteur capturée avec succès')),
      );
      
      _localSignaturePadKey2!.currentState!.clear();
    }
  }

}














