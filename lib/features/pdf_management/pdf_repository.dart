import 'package:e_contrat/features/pdf_management/pdf_document.dart';

abstract class PdfRepository {
  Future<List<PdfDocument>> getAll();
  Future<void> deleteById(int id);
  Future<void> saveBytes(List<int> bytes, String fileName);
}
