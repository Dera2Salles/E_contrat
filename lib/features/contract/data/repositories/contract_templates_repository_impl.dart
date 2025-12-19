import 'package:e_contrat/features/contract/data/datasources/contract_templates_static_datasource.dart';
import 'package:e_contrat/features/contract/domain/entities/contract_category.dart';
import 'package:e_contrat/features/contract/domain/entities/contract_template.dart';
import 'package:e_contrat/features/contract/domain/repositories/contract_templates_repository.dart';
import 'package:e_contrat/features/contract/domain/value_objects/quill_delta_document.dart';

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
      );
    }).toList(growable: false);
  }
}
