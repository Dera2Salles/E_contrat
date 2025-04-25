import 'dart:io';
import 'package:e_contrat/page/databasehelper.dart';
import 'package:e_contrat/page/pdfviewscreen.dart';
import 'package:flutter/material.dart';

class PdfListScreen extends StatefulWidget {
  const PdfListScreen({super.key});

  @override
  State<PdfListScreen> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<Map<String, dynamic>> _pdfs = [];

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  Future<void> _loadPdfs() async {
    final pdfs = await DatabaseHelper.getAllPdfs();
    setState(() {
      _pdfs = pdfs;
    });
  }

  Future<void> _deletePdf(int id, String path) async {
    await DatabaseHelper.deletePdf(id); // suppression base
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
       debugPrint('PDF DB supprime'); // suppression fichier physique
    }
    await _loadPdfs(); // recharge la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des PDFs')),
      body: _pdfs.isEmpty
          ? const Center(child: Text('Aucun PDF trouvé.'))
          : ListView.builder(
              itemCount: _pdfs.length,
              itemBuilder: (context, index) {
                final pdf = _pdfs[index];
                return ListTile(
                  title: Text(pdf['name']),
                  subtitle: Text(pdf['path']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _deletePdf(pdf['id'], pdf['path']);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewScreen(path: pdf['path']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
