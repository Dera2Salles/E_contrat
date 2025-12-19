import 'package:injectable/injectable.dart';
import 'package:e_contrat/features/contract/data/static/contract_templates_legacy.dart' as legacy;

@injectable
class ContractTemplatesStaticDataSource {
  const ContractTemplatesStaticDataSource();

  Map<String, List<Map<String, dynamic>>> getCategoryMaps() {
    return {
      'vente': legacy.contractVente,
      'pret': legacy.contractPret,
      'location': legacy.contractLocation,
      'service': legacy.contractService,
      'travail': legacy.contractTravail,
      'partenariat': legacy.contractPartenariat,
      'prestation': legacy.contractPrestation,
      'don': legacy.contractDon,
      'cession': legacy.contractCession,
    };
  }
}
