import 'package:e_contrat/page/sample.dart' as legacy;

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
