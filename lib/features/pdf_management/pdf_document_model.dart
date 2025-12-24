import 'package:e_contrat/features/pdf_management/pdf_document.dart';

class PdfDocumentModel extends PdfDocument {
  const PdfDocumentModel({
    required super.id,
    required super.name,
    required super.path,
  });

  factory PdfDocumentModel.fromMap(Map<String, dynamic> map) {
    return PdfDocumentModel(
      id: map['id'] as int,
      name: map['name'] as String,
      path: map['path'] as String,
    );
  }
}
