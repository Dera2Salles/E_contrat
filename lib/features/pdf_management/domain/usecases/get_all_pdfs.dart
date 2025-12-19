import 'package:injectable/injectable.dart';
import '../../domain/entities/pdf_document.dart';
import '../../domain/repositories/pdf_repository.dart';

@injectable
class GetAllPdfs {
  final PdfRepository _repository;

  GetAllPdfs(this._repository);

  Future<List<PdfDocument>> call() => _repository.getAll();
}
