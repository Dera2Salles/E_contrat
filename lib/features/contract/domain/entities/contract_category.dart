import 'package:equatable/equatable.dart';
import 'package:e_contrat/features/contract/domain/entities/contract_template.dart';

class ContractCategory extends Equatable {
  final String id;
  final String label;
  final List<ContractTemplate> templates;

  const ContractCategory({
    required this.id,
    required this.label,
    required this.templates,
  });

  @override
  List<Object?> get props => [id, label, templates];
}
