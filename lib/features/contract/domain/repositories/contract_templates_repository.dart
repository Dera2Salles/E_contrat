import 'package:e_contrat/features/contract/domain/entities/contract_category.dart';

abstract class ContractTemplatesRepository {
  Future<List<ContractCategory>> getCategories();
}
