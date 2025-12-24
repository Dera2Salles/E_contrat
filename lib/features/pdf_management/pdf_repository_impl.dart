import 'dart:io';

import 'package:e_contrat/features/pdf_management/pdf_local_datasource.dart';
import 'package:e_contrat/features/pdf_management/pdf_document_model.dart';
import 'package:e_contrat/features/pdf_management/pdf_document.dart';
import 'package:e_contrat/features/pdf_management/pdf_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: PdfRepository)
class PdfRepositoryImpl implements PdfRepository {
  final PdfLocalDataSource _local;

  PdfRepositoryImpl(this._local);

  @override
  Future<List<PdfDocument>> getAll() async {
    final rows = await _local.getAllPdfs();
    return rows.map(PdfDocumentModel.fromMap).toList(growable: false);
  }

  @override
  Future<void> deleteById(int id) async {
    final all = await _local.getAllPdfs();
    final row = all.cast<Map<String, dynamic>>().firstWhere(
          (e) => e['id'] == id,
          orElse: () => <String, dynamic>{},
        );

    final path = row['path'];
    if (path is String) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await _local.deletePdf(id);
  }

  @override
  Future<void> saveBytes(List<int> bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes);
    await _local.insertPdf(fileName, file.path);
  }
}
