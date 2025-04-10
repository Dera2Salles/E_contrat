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
  ui.Image? _signatureImage;
  bool _isGeneratingPdf = false;
  GlobalKey<SfSignaturePadState>? _localSignaturePadKey;

  @override
  void initState() {
    super.initState();
    _localSignaturePadKey = widget.signaturePadKey ?? GlobalKey<SfSignaturePadState>();
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

  double mmToPoints(double mm) {
    return mm * 2.83465;
  }

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

    final signatureBytes = _signatureImage != null
        ? (await _signatureImage!.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List()
        : null;

    final font = await loadPdfFont();

    pdfDoc.addPage(
      pw.Page(
        pageFormat: pdf.PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              ...formData.entries.map((entry) {
                return pw.Positioned(
                  left: mmToPoints(_elementPositions[entry.key]!.dx / _scaleFactor),
                  top: mmToPoints(_elementPositions[entry.key]!.dy / _scaleFactor),
                  child: pw.Text(
                    "${entry.key}: ${entry.value}",
                    style: pw.TextStyle(font: font, fontSize: 12),
                  ),
                );
              }),
              
              pw.Positioned(
                left: mmToPoints(_elementPositions["Motif"]!.dx / _scaleFactor),
                top: mmToPoints(_elementPositions["Motif"]!.dy / _scaleFactor),
                child: pw.Container(
                  width: mmToPoints(300 / _scaleFactor),
                  child: pw.Text(
                    motifText,
                    style: pw.TextStyle(font: font, fontSize: 12),
                  ),
                ),
              ),
              
              if (signatureBytes != null)
                pw.Positioned(
                  left: mmToPoints(_elementPositions["Signature"]!.dx / _scaleFactor),
                  top: mmToPoints(_elementPositions["Signature"]!.dy / _scaleFactor),
                  child: pw.Image(
                    pw.MemoryImage(signatureBytes),
                    width: mmToPoints(200 / _scaleFactor),
                    height: mmToPoints(100 / _scaleFactor),
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
      if (_localSignaturePadKey?.currentState != null) {
        await _captureSignature();
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
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: _a4WidthMm * _scaleFactor,
                  height: _a4HeightMm * _scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
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

                      ..._buildFormDataElements(formData),
                      _buildQuillEditorElement(motifText),
                      _buildSignatureElement(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isGeneratingPdf)
            const LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
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
        child: _buildDraggableElement(
          key: entry.key,
          child: _buildFormDataContainer(entry.key, entry.value),
        ),
      );
    }).toList();
  }
Widget _buildQuillEditorElement(  String motifText) {
  return Positioned(
    left: _elementPositions["Motif"]!.dx,
    top: _elementPositions["Motif"]!.dy,
    child: _buildDraggableElement(
      key: "Motif",
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
        " $motifText",
        style: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.bold,
        ),
      ),
      ),
    ),
  );
}

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

  Widget _buildSignatureElement() {
    return Positioned(
      left: _elementPositions["Signature"]!.dx,
      top: _elementPositions["Signature"]!.dy,
      child: _buildDraggableElement(
        key: "Signature",
        child: GestureDetector(
          onTap: _navigateToSignaturePage,
          child: Container(
            width: 200,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey),
            ),
            child: _signatureImage != null
                ? RawImage(
                    image: _signatureImage,
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
    );
  }

  Widget _buildDraggableElement({
    required String key,
    required Widget child,
  }) {
    return Draggable(
      feedback: Material(
        elevation: 4,
        child: SizedBox(
          width: key == "Motif" ? 300 : key == "Signature" ? 200 : null,
          height: key == "Signature" ? 100 : null,
          child: child,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: child,
      ),
      child: child,
      onDragEnd: (details) => _updateElementPosition(details, key),
    );
  }

  Widget _buildFormDataContainer(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _updateElementPosition(DraggableDetails details, String key) {
    final RenderBox stackBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
    final stackPosition = stackBox.localToGlobal(Offset.zero);

    setState(() {
      double newDx = details.offset.dx - stackPosition.dx;
      double newDy = details.offset.dy - stackPosition.dy;

      double maxWidth = _a4WidthMm * _scaleFactor;
      double maxHeight = _a4HeightMm * _scaleFactor;
      double elementWidth = key == "Motif" ? 300 : key == "Signature" ? 200 : 100;
      double elementHeight = key == "Signature" ? 100 : 50;

      _elementPositions[key] = Offset(
        newDx.clamp(0, maxWidth - elementWidth),
        newDy.clamp(0, maxHeight - elementHeight),
      );
    });
  }

  Future<void> _navigateToSignaturePage() async {
     void handleClearButtonPressed() {
    _localSignaturePadKey?.currentState!.clear();
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

         
          title: Text('Signature',
          
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
                          key:_localSignaturePadKey,
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




































         // Scaffold(
        //   appBar: AppBar(title: const Text('Signer le document')),
        //   body: Column(
        //     children: [
        //       Expanded(
        //         child: SfSignaturePad(
        //           key: _localSignaturePadKey,
        //           backgroundColor: Colors.white,
        //         ),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           Navigator.pop(context, true);
        //         },
        //         child: const Text('Valider la signature'),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );

    if (signature == true) {
      await _captureSignature();
    }
  }

  Future<void> _captureSignature() async {
    if (_localSignaturePadKey?.currentState != null) {
      final image = await _localSignaturePadKey!.currentState!
          .toImage(pixelRatio: 3.0);
      
      setState(() {
        _signatureImage = image;
      });
      
      _localSignaturePadKey!.currentState!.clear();
    }
  }

}