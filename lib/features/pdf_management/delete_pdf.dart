import 'package:injectable/injectable.dart';
import 'package:e_contrat/features/pdf_management/pdf_repository.dart';

@injectable
class DeletePdf {
  final PdfRepository _repository;

  DeletePdf(this._repository);

  Future<void> call(int id) => _repository.deleteById(id);
}
