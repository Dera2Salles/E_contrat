import 'package:e_contrat/features/contract/contract_category.dart';

abstract class ContractTemplatesRepository {
  Future<List<ContractCategory>> getCategories();
}
