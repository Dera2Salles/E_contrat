import 'package:equatable/equatable.dart';
import 'package:e_contrat/features/contract/domain/value_objects/quill_delta_document.dart';

class ContractTemplate extends Equatable {
  final String id;
  final String title;
  final QuillDeltaDocument document;
  final List<String> placeholders;
  final List<String> parties;

  const ContractTemplate({
    required this.id,
    required this.title,
    required this.document,
    required this.placeholders,
    required this.parties,
  });

  @override
  List<Object?> get props => [id, title, document, placeholders, parties];
}
