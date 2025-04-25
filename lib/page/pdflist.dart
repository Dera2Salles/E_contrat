import 'package:e_contrat/page/databasehelper.dart';
import 'package:e_contrat/page/pdfviewscreen.dart';
import 'package:flutter/material.dart';
// ton fichier DatabaseHelper
import 'package:open_file/open_file.dart'; // pour ouvrir les fichiers

class PdfListScreen extends StatelessWidget {
  const PdfListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des PDFs')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.getAllPdfs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun PDF trouvé.'));
          }

          final pdfs = snapshot.data!;
          return ListView.builder(
            itemCount: pdfs.length,
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              return ListTile(
                title: Text(pdf['name']),
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
          );
        },
      ),
    );
  }
}
