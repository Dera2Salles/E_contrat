import 'package:injectable/injectable.dart';
import 'package:e_contrat/features/pdf_management/domain/repositories/pdf_repository.dart';

@injectable
class SavePdfBytes {
  final PdfRepository _repository;

  SavePdfBytes(this._repository);

  Future<void> call(List<int> bytes, String fileName) {
    return _repository.saveBytes(bytes, fileName);
  }
}
