import 'package:injectable/injectable.dart';
import 'package:e_contrat/features/contract/contract_category.dart';
import 'package:e_contrat/features/contract/contract_templates_repository.dart';

@injectable
class GetContractCategories {
  final ContractTemplatesRepository _repo;

  GetContractCategories(this._repo);

  Future<List<ContractCategory>> call() => _repo.getCategories();
}
