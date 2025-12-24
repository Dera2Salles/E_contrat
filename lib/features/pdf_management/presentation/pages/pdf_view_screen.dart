import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final String path, title;
  const PdfViewScreen({super.key, required this.path , required this.title});

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    return Scaffold(
      appBar: AppBar(title:  Text(title)),
      body: file.existsSync()
          ? SfPdfViewer.file(file)
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Fichier introuvable',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      path,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
