import 'package:e_contrat/features/pdf_management/domain/repositories/pdf_repository.dart';

class SavePdfBytes {
  final PdfRepository _repository;

  SavePdfBytes(this._repository);

  Future<void> call(List<int> bytes, String fileName) {
    return _repository.saveBytes(bytes, fileName);
  }
}
