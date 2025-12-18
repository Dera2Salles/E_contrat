import 'package:e_contrat/features/contract/domain/entities/contract_category.dart';
import 'package:e_contrat/features/contract/domain/repositories/contract_templates_repository.dart';

class GetContractCategories {
  final ContractTemplatesRepository _repo;

  GetContractCategories(this._repo);

  Future<List<ContractCategory>> call() => _repo.getCategories();
}
