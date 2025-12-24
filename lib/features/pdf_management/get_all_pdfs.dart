import 'package:injectable/injectable.dart';
import 'pdf_document.dart';
import 'pdf_repository.dart';

@injectable
class GetAllPdfs {
  final PdfRepository _repository;

  GetAllPdfs(this._repository);

  Future<List<PdfDocument>> call() => _repository.getAll();
}
