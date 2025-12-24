import 'package:e_contrat/features/contract/contract_templates_static_datasource.dart';
import 'package:e_contrat/features/contract/contract_category.dart';
import 'package:e_contrat/features/contract/contract_template.dart';
import 'package:e_contrat/features/contract/contract_templates_repository.dart';
import 'package:e_contrat/features/contract/quill_delta_document.dart';
import 'package:flutter/material.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: ContractTemplatesRepository)
class ContractTemplatesRepositoryImpl implements ContractTemplatesRepository {
  final ContractTemplatesStaticDataSource _ds;

  ContractTemplatesRepositoryImpl(this._ds);

  @override
  Future<List<ContractCategory>> getCategories() async {
    final maps = _ds.getCategoryMaps();

    final labels = <String, String>{
      'vente': 'Vente',
      'pret': 'Prêt',
      'location': 'Location',
      'service': 'Service',
      'travail': 'Travail',
      'partenariat': 'Partenariat',
      'prestation': 'Prestation',
      'don': 'Don',
      'cession': 'Cession',
    };

    final icons = <String, IconData>{
      'vente': Icons.shopping_bag_outlined,
      'pret': Icons.account_balance_wallet_outlined,
      'location': Icons.home_work_outlined,
      'service': Icons.handshake_outlined,
      'travail': Icons.badge_outlined,
      'partenariat': Icons.groups_outlined,
      'prestation': Icons.design_services_outlined,
      'don': Icons.volunteer_activism_outlined,
      'cession': Icons.swap_horiz_outlined,
    };

    final colors = <String, Color>{
      'vente': const Color(0xFF6366F1),
      'pret': const Color(0xFF10B981),
      'location': const Color(0xFF3B82F6),
      'service': const Color(0xFFF59E0B),
      'travail': const Color(0xFF64748B),
      'partenariat': const Color(0xFFEF4444),
      'prestation': const Color(0xFFEC4899),
      'don': const Color(0xFF84CC16),
      'cession': const Color(0xFF8B5CF6),
    };

    return maps.entries.map((entry) {
      final categoryId = entry.key;
      final list = entry.value;

      final templates = list.asMap().entries.map((e) {
        final idx = e.key;
        final raw = e.value;
        return ContractTemplate(
          id: '${categoryId}_$idx',
          title: (raw['title'] as String?) ?? labels[categoryId] ?? categoryId,
          document: QuillDeltaDocument.fromJson(raw['data'] as List),
          placeholders: (raw['placeholders'] as List).cast<String>(),
          parties: (raw['partie'] as List).cast<String>(),
        );
      }).toList(growable: false);

      return ContractCategory(
        id: categoryId,
        label: labels[categoryId] ?? categoryId,
        templates: templates,
        iconData: icons[categoryId] ?? Icons.insert_drive_file_outlined,
        color: colors[categoryId] ?? Colors.grey,
      );
    }).toList(growable: false);
  }
}
