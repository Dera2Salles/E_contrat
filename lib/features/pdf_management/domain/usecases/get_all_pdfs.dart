import 'package:e_contrat/features/pdf_management/domain/entities/pdf_document.dart';
import 'package:e_contrat/features/pdf_management/domain/repositories/pdf_repository.dart';

class GetAllPdfs {
  final PdfRepository _repository;

  GetAllPdfs(this._repository);

  Future<List<PdfDocument>> call() => _repository.getAll();
}
