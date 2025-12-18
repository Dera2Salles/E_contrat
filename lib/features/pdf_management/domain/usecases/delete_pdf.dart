import 'package:e_contrat/features/pdf_management/domain/repositories/pdf_repository.dart';

class DeletePdf {
  final PdfRepository _repository;

  DeletePdf(this._repository);

  Future<void> call(int id) => _repository.deleteById(id);
}
