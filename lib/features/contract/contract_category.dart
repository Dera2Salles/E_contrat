import 'package:equatable/equatable.dart';
import 'package:e_contrat/features/contract/contract_template.dart';
import 'package:flutter/widgets.dart';

class ContractCategory extends Equatable {
  final String id;
  final String label;
  final List<ContractTemplate> templates;
  final IconData iconData;
  final Color color;

  const ContractCategory({
    required this.id,
    required this.label,
    required this.templates,
    required this.iconData,
    required this.color,
  });

  @override
  List<Object?> get props => [id, label, templates, iconData, color];
}
