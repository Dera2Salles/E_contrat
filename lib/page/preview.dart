import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // Importation avec alias pw
import 'package:printing/printing.dart';

class PreviewScreen extends StatefulWidget {
  final Map<String, String>? formData;
  final dynamic quillContent;

  const PreviewScreen({super.key, this.formData, this.quillContent});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Map<String, Offset> positions = {};
  final GlobalKey _stackKey = GlobalKey(); // Clé pour accéder au Stack

  @override
  void initState() {
    super.initState();
    positions["Nom"] = const Offset(20, 20);
    positions["Date"] = const Offset(20, 60);
    positions["Montant"] = const Offset(20, 100);
    positions["Motif"] = const Offset(20, 140);
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

    return Scaffold(
      appBar: AppBar(title: const Text("Aperçu A4")),
      body: Stack(
        children: [
          Container(
            width: 210 * 3.78,
            height: 297 * 3.78,
            color: Colors.white,
            child: Stack(
              key: _stackKey, // Ajouter la clé au Stack
              children: [
                ...formData.entries.map((entry) {
                  return Positioned(
                    left: positions[entry.key]!.dx,
                    top: positions[entry.key]!.dy,
                    child: Draggable(
                      feedback: Material(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.blue.withOpacity(0.7),
                          child: Text(
                            "${entry.key}: ${entry.value}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.blue,
                        child: Text(
                          "${entry.key}: ${entry.value}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onDragEnd: (details) {
                        _updatePosition(details, entry.key);
                      },
                    ),
                  );
                }),
                Positioned(
                  left: positions["Motif"]!.dx,
                  top: positions["Motif"]!.dy,
                  child: Draggable(
                    feedback: Material(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey.withOpacity(0.7),
                        child: Text(
                          "Motif: $motifText",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[200],
                      child: Text(
                        "Motif: $motifText",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    onDragEnd: (details) {
                      _updatePosition(details, "Motif");
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () => _generatePdf(formData, quillContentRaw),
              child: const Text("Générer le PDF"),
            ),
          ),
        ],
      ),
    );
  }

  void _updatePosition(DraggableDetails details, String key) {
    // Obtenir la position du Stack par rapport à l'écran
    final RenderBox stackBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
    final stackPosition = stackBox.localToGlobal(Offset.zero);

    setState(() {
      // Convertir les coordonnées globales en coordonnées locales
      double newDx = details.offset.dx - stackPosition.dx;
      double newDy = details.offset.dy - stackPosition.dy;

      // Limiter les positions à l'intérieur du conteneur A4
      positions[key] = Offset(
        newDx.clamp(0, 210 * 3.78 - 100), // Ajuste selon la largeur du texte
        newDy.clamp(0, 297 * 3.78 - 50),  // Ajuste selon la hauteur du texte
      );
    });
  }

  Future<void> _generatePdf(Map<String, String> formData, dynamic quillContent) async {
    final pdf = pw.Document();

    // Extraire le texte du motif pour le PDF
    String motifText = 'Non défini';
    if (quillContent is Map<String, dynamic> && quillContent['ops'] is List) {
      final ops = quillContent['ops'] as List;
      if (ops.isNotEmpty && ops[0] is Map && ops[0]['insert'] is String) {
        motifText = ops[0]['insert'];
      }
    } else if (quillContent is String) {
      motifText = quillContent;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              ...formData.entries.map((entry) {
                return pw.Positioned(
                  left: positions[entry.key]!.dx / 3.78,
                  top: (297 - (positions[entry.key]!.dy / 3.78)) - 20,
                  child: pw.Text("${entry.key}: ${entry.value}"),
                );
              }),
              pw.Positioned(
                left: positions["Motif"]!.dx / 3.78,
                top: (297 - (positions["Motif"]!.dy / 3.78)) - 20,
                child: pw.Text("Motif: $motifText"),
              ),
            ],
          );
        },
      ),
    );
    final file = await pdf.save();
    await Printing.sharePdf(bytes: file, filename: 'contrat.pdf');
  }
}