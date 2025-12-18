final List<Map<String, dynamic>> contractVente = [
  {
    'title': 'Contrat de Vente ',
    'data': [
      {'insert': 'CONTRAT DE VENTE \n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Vendeur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Vendeur], ci-après dénommé(e) \'le Vendeur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Acheteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Acheteur], ci-après dénommé(e) \'l’Acheteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Vendeur vend à l’Acheteur l’article suivant : [Description de l’article].\n\n'},
      {'insert': 'Article 2 - Prix\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le prix de vente s’élève à [Montant] Ariary, payable le [Date de paiement].\n\n'},
      {'insert': 'Article 3 - Transfert de propriété\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le transfert de propriété aura lieu le [Date de transfert] après paiement intégral.\n\n'},
      {'insert': 'Article 4 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Vendeur',
      'Adresse du Vendeur',
      'Nom de l’Acheteur',
      'Adresse de l’Acheteur',
      'Description de l’article',
      'Montant',
      'Date de paiement',
      'Date de transfert',
      'Lieu',
      'Date'
    ],
    'partie': ['Vendeur', 'Acheteur']
  },
  {
    'title': 'Contrat de Vente de Véhicule d’Occasion',
    'data': [
      {'insert': 'CONTRAT DE VENTE DE VÉHICULE D’OCCASION\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Vendeur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Vendeur], ci-après dénommé(e) \'le Vendeur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Acheteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Acheteur], ci-après dénommé(e) \'l’Acheteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Vendeur vend à l’Acheteur le véhicule suivant : [Marque, Modèle, Année, Numéro d’immatriculation].\n\n'},
      {'insert': 'Article 2 - Prix\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le prix de vente s’élève à [Montant] Ariary, payable le [Date de paiement].\n\n'},
      {'insert': 'Article 3 - Transfert de propriété\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le transfert de propriété aura lieu le [Date de livraison] après paiement intégral.\n\n'},
      {'insert': 'Article 4 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Vendeur',
      'Adresse du Vendeur',
      'Nom de l’Acheteur',
      'Adresse de l’Acheteur',
      'Marque, Modèle, Année, Numéro d’immatriculation',
      'Montant',
      'Date de paiement',
      'Date de livraison',
      'Lieu',
      'Date'
    ],
    'partie': ['Vendeur', 'Acheteur']
  },
  
  {
    'title': 'Contrat de Vente de Bien Immobilier',
    'data': [
      {'insert': 'CONTRAT DE VENTE DE BIEN IMMOBILIER\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Vendeur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Vendeur], ci-après dénommé(e) \'le Vendeur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Acheteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Acheteur], ci-après dénommé(e) \'l’Acheteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Vendeur vend à l’Acheteur le bien immobilier situé à [Adresse du Bien].\n\n'},
      {'insert': 'Article 2 - Prix\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le prix de vente s’élève à [Montant] Ariary, payable le [Date de paiement].\n\n'},
      {'insert': 'Article 3 - Transfert de propriété\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le transfert de propriété aura lieu le [Date de transfert].\n\n'},
      {'insert': 'Article 4 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Vendeur',
      'Adresse du Vendeur',
      'Nom de l’Acheteur',
      'Adresse de l’Acheteur',
      'Adresse du Bien',
      'Montant',
      'Date de paiement',
      'Date de transfert',
      'Lieu',
      'Date'
    ],
    'partie': ['Vendeur', 'Acheteur']
  },
  {
    'title': 'Contrat de Vente d’Équipement Électronique',
    'data': [
      {'insert': 'CONTRAT DE VENTE D’ÉQUIPEMENT ÉLECTRONIQUE\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Vendeur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Vendeur], ci-après dénommé(e) \'le Vendeur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Acheteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Acheteur], ci-après dénommé(e) \'l’Acheteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Vendeur vend à l’Acheteur l’équipement suivant : [Description de l’équipement].\n\n'},
      {'insert': 'Article 2 - Prix\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le prix de vente s’élève à [Montant] Ariary, payable le [Date de paiement].\n\n'},
      {'insert': 'Article 3 - Livraison\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’équipement sera livré le [Date de livraison].\n\n'},
      {'insert': 'Article 4 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Vendeur',
      'Adresse du Vendeur',
      'Nom de l’Acheteur',
      'Adresse de l’Acheteur',
      'Description de l’équipement',
      'Montant',
      'Date de paiement',
      'Date de livraison',
      'Lieu',
      'Date'
    ],
    'partie': ['Vendeur', 'Acheteur']
  },
  {
    'title': 'Contrat de Vente de Meubles',
    'data': [
      {'insert': 'CONTRAT DE VENTE DE MEUBLES\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Vendeur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Vendeur], ci-après dénommé(e) \'le Vendeur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Acheteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Acheteur], ci-après dénommé(e) \'l’Acheteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Vendeur vend à l’Acheteur les meubles suivants : [Description des meubles].\n\n'},
      {'insert': 'Article 2 - Prix\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le prix de vente s’élève à [Montant] Ariary, payable le [Date de paiement].\n\n'},
      {'insert': 'Article 3 - Livraison\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Les meubles seront livrés le [Date de livraison].\n\n'},
      {'insert': 'Article 4 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Vendeur',
      'Adresse du Vendeur',
      'Nom de l’Acheteur',
      'Adresse de l’Acheteur',
      'Description des meubles',
      'Montant',
      'Date de paiement',
      'Date de livraison',
      'Lieu',
      'Date'
    ],
    'partie': ['Vendeur', 'Acheteur']
  },
];

final List<Map<String, dynamic>> contractPret = [
  {
    'title': 'Contrat de Prêt Personnel',
    'data': [
      {'insert': 'CONTRAT DE PRÊT PERSONNEL\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Créancier]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Créancier], ci-après dénommé(e) \'le Créancier\',\n\nEt\n\n'},
      {'insert': '[Nom du Débiteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Débiteur], ci-après dénommé(e) \'le Débiteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Créancier consent un prêt d’une somme de [Montant] Ariary au Débiteur.\n\n'},
      {'insert': 'Article 2 - Remboursement\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le prêt sera remboursé d’ici le [Date de remboursement].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Créancier',
      'Adresse du Créancier',
      'Nom du Débiteur',
      'Adresse du Débiteur',
      'Montant',
      'Date de remboursement',
      'Lieu',
      'Date'
    ],
    'partie': ['Créancier', 'Débiteur']
  },
  {
    'title': 'Contrat de Prêt Familial',
    'data': [
      {'insert': 'CONTRAT DE PRÊT FAMILIAL\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Prêteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Prêteur], ci-après dénommé(e) \'le Prêteur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Emprunteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Emprunteur], ci-après dénommé(e) \'l’Emprunteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Prêteur consent un prêt de [Montant] Ariary à l’Emprunteur.\n\n'},
      {'insert': 'Article 2 - Remboursement\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’Emprunteur remboursera d’ici le [Date de remboursement].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Prêteur',
      'Adresse du Prêteur',
      'Nom de l’Emprunteur',
      'Adresse de l’Emprunteur',
      'Montant',
      'Date de remboursement',
      'Lieu',
      'Date'
    ],
    'partie': ['Prêteur', 'Emprunteur']
  },
  {
    'title': 'Contrat de Prêt avec Intérêt',
    'data': [
      {'insert': 'CONTRAT DE PRÊT AVEC INTÉRÊT\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Créancier]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Créancier], ci-après dénommé(e) \'le Créancier\',\n\nEt\n\n'},
      {'insert': '[Nom du Débiteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Débiteur], ci-après dénommé(e) \'le Débiteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Créancier consent un prêt de [Montant] Ariary au Débiteur avec un taux d’intérêt de [Taux d’intérêt] %.\n\n'},
      {'insert': 'Article 2 - Remboursement\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le prêt sera remboursé d’ici le [Date de remboursement].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Créancier',
      'Adresse du Créancier',
      'Nom du Débiteur',
      'Adresse du Débiteur',
      'Montant',
      'Taux d’intérêt',
      'Date de remboursement',
      'Lieu',
      'Date'
    ],
    'partie': ['Créancier', 'Débiteur']
  },
  {
    'title': 'Contrat de Prêt sans Intérêt',
    'data': [
      {'insert': 'CONTRAT DE PRÊT SANS INTÉRÊT\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Créancier]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Créancier], ci-après dénommé(e) \'le Créancier\',\n\nEt\n\n'},
      {'insert': '[Nom du Débiteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Débiteur], ci-après dénommé(e) \'le Débiteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Créancier consent un prêt de [Montant] Ariary au Débiteur sans intérêt.\n\n'},
      {'insert': 'Article 2 - Remboursement\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le prêt sera remboursé d’ici le [Date de remboursement].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Créancier',
      'Adresse du Créancier',
      'Nom du Débiteur',
      'Adresse du Débiteur',
      'Montant',
      'Date de remboursement',
      'Lieu',
      'Date'
    ],
    'partie': ['Créancier', 'Débiteur']
  },
];

final List<Map<String, dynamic>> contractLocation = [
  {
    'title': 'Contrat de Bail d’Appartement',
    'data': [
      {'insert': 'CONTRAT DE BAIL D’APPARTEMENT\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Bailleur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Bailleur], ci-après dénommé(e) \'le Bailleur\',\n\nEt\n\n'},
      {'insert': '[Nom du Locataire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Locataire], ci-après dénommé(e) \'le Locataire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Bailleur loue l’appartement situé à [Adresse de l’appartement] pour [Montant] Ariary par mois.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le bail commence le [Date de début] et se termine le [Date de fin].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Bailleur',
      'Adresse du Bailleur',
      'Nom du Locataire',
      'Adresse du Locataire',
      'Adresse de l’appartement',
      'Montant',
      'Date de début',
      'Date de fin',
      'Lieu',
      'Date'
    ],
    'partie': ['Bailleur', 'Locataire']
  },
  {
    'title': 'Contrat de Location de Maison',
    'data': [
      {'insert': 'CONTRAT DE LOCATION DE MAISON\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Bailleur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Bailleur], ci-après dénommé(e) \'le Bailleur\',\n\nEt\n\n'},
      {'insert': '[Nom du Locataire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Locataire], ci-après dénommé(e) \'le Locataire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Bailleur loue la maison située à [Adresse de la maison] pour [Montant] Ariary par mois.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le bail commence le [Date de début] et se termine le [Date de fin].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Bailleur',
      'Adresse du Bailleur',
      'Nom du Locataire',
      'Adresse du Locataire',
      'Adresse de la maison',
      'Montant',
      'Date de début',
      'Date de fin',
      'Lieu',
      'Date'
    ],
    'partie': ['Bailleur', 'Locataire']
  },
  {
    'title': 'Contrat de Location de Véhicule',
    'data': [
      {'insert': 'CONTRAT DE LOCATION DE VÉHICULE\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Loueur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Loueur], ci-après dénommé(e) \'le Loueur\',\n\nEt\n\n'},
      {'insert': '[Nom du Locataire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Locataire], ci-après dénommé(e) \'le Locataire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Loueur loue le véhicule suivant : [Marque, Modèle, Numéro d’immatriculation] pour [Montant] Ariary par jour.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'La location commence le [Date de début] et se termine le [Date de fin].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Loueur',
      'Adresse du Loueur',
      'Nom du Locataire',
      'Adresse du Locataire',
      'Marque, Modèle, Numéro d’immatriculation',
      'Montant',
      'Date de début',
      'Date de fin',
      'Lieu',
      'Date'
    ],
    'partie': ['Loueur', 'Locataire']
  },
];

final List<Map<String, dynamic>> contractService = [
  {
    'title': 'Contrat de Promenade de Chien',
    'data': [
      {'insert': 'CONTRAT DE PROMENADE DE CHIEN\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Propriétaire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Propriétaire], ci-après dénommé(e) \'le Propriétaire\',\n\nEt\n\n'},
      {'insert': '[Nom du Promeneur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Promeneur], ci-après dénommé(e) \'le Promeneur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Promeneur s’engage à promener le chien [Nom du Chien] pour [Montant] Ariary par promenade.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le service commence le [Date de début].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Propriétaire',
      'Adresse du Propriétaire',
      'Nom du Promeneur',
      'Adresse du Promeneur',
      'Nom du Chien',
      'Montant',
      'Date de début',
      'Lieu',
      'Date'
    ],
    'partie': ['Propriétaire', 'Promeneur']
  },
  {
    'title': 'Contrat de Nettoyage Résidentiel',
    'data': [
      {'insert': 'CONTRAT DE NETTOYAGE RÉSIDENTIEL\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Client]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Client], ci-après dénommé(e) \'le Client\',\n\nEt\n\n'},
      {'insert': '[Nom du Prestataire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Prestataire], ci-après dénommé(e) \'le Prestataire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Prestataire s’engage à nettoyer la résidence située à [Adresse de la résidence] pour [Montant] Ariary par session.\n\n'},
      {'insert': 'Article 2 - Fréquence\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le service sera effectué [Fréquence] à partir du [Date de début].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Client',
      'Adresse du Client',
      'Nom du Prestataire',
      'Adresse du Prestataire',
      'Adresse de la résidence',
      'Montant',
      'Fréquence',
      'Date de début',
      'Lieu',
      'Date'
    ],
    'partie': ['Client', 'Prestataire']
  },
  {
    'title': 'Contrat de Tutorat Privé',
    'data': [
      {'insert': 'CONTRAT DE TUTORAT PRIVÉ\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Client]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Client], ci-après dénommé(e) \'le Client\',\n\nEt\n\n'},
      {'insert': '[Nom du Tuteur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Tuteur], ci-après dénommé(e) \'le Tuteur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Tuteur s’engage à fournir des cours de [Matière] pour [Montant] Ariary par heure.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le tutorat commence le [Date de début].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Client',
      'Adresse du Client',
      'Nom du Tuteur',
      'Adresse du Tuteur',
      'Matière',
      'Montant',
      'Date de début',
      'Lieu',
      'Date'
    ],
    'partie': ['Client', 'Tuteur']
  },
];

final List<Map<String, dynamic>> contractTravail = [
  {
    'title': 'Contrat d’Emploi Temporaire',
    'data': [
      {'insert': 'CONTRAT D’EMPLOI TEMPORAIRE\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom de l’Employeur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Employeur], ci-après dénommé(e) \'l’Employeur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Employé]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Employé], ci-après dénommé(e) \'l’Employé\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’Employeur engage l’Employé pour le poste de [Poste] à [Montant] Ariary par mois.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’emploi commence le [Date de début] et se termine le [Date de fin].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom de l’Employeur',
      'Adresse de l’Employeur',
      'Nom de l’Employé',
      'Adresse de l’Employé',
      'Poste',
      'Montant',
      'Date de début',
      'Date de fin',
      'Lieu',
      'Date'
    ],
    'partie': ['Employeur', 'Employé']
  },
  {
    'title': 'Contrat d’Emploi Permanent',
    'data': [
      {'insert': 'CONTRAT D’EMPLOI PERMANENT\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom de l’Employeur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Employeur], ci-après dénommé(e) \'l’Employeur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Employé]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Employé], ci-après dénommé(e) \'l’Employé\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’Employeur engage l’Employé pour le poste de [Poste] à [Montant] Ariary par mois.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’emploi commence le [Date de début] pour une durée indéterminée.\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom de l’Employeur',
      'Adresse de l’Employeur',
      'Nom de l’Employé',
      'Adresse de l’Employé',
      'Poste',
      'Montant',
      'Date de début',
      'Lieu',
      'Date'
    ],
    'partie': ['Employeur', 'Employé']
  },
  {
    'title': 'Contrat de Stage',
    'data': [
      {'insert': 'CONTRAT DE STAGE\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom de l’Entreprise]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Entreprise], ci-après dénommé(e) \'l’Entreprise\',\n\nEt\n\n'},
      {'insert': '[Nom du Stagiaire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Stagiaire], ci-après dénommé(e) \'le Stagiaire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’Entreprise accueille le Stagiaire pour un stage dans le domaine de [Domaine] avec une indemnité de [Montant] Ariary par mois.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le stage commence le [Date de début] et se termine le [Date de fin].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom de l’Entreprise',
      'Adresse de l’Entreprise',
      'Nom du Stagiaire',
      'Adresse du Stagiaire',
      'Domaine',
      'Montant',
      'Date de début',
      'Date de fin',
      'Lieu',
      'Date'
    ],
    'partie': ['Entreprise', 'Stagiaire']
  },
];

final List<Map<String, dynamic>> contractPartenariat = [
  {
    'title': 'Contrat de Partenariat Commercial',
    'data': [
      {'insert': 'CONTRAT DE PARTENARIAT COMMERCIAL\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Partenaire 1]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Partenaire 1], ci-après dénommé(e) \'le Partenaire 1\',\n\nEt\n\n'},
      {'insert': '[Nom du Partenaire 2]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Partenaire 2], ci-après dénommé(e) \'le Partenaire 2\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Les partenaires collaborent pour le projet [Description du projet] avec un investissement de [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le partenariat commence le [Date de début].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Partenaire 1',
      'Adresse du Partenaire 1',
      'Nom du Partenaire 2',
      'Adresse du Partenaire 2',
      'Description du projet',
      'Montant',
      'Date de début',
      'Lieu',
      'Date'
    ],
    'partie': ['Partenaire 1', 'Partenaire 2']
  },
  {
    'title': 'Contrat de Collaboration Artistique',
    'data': [
      {'insert': 'CONTRAT DE COLLABORATION ARTISTIQUE\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom de l’Artiste 1]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Artiste 1], ci-après dénommé(e) \'l’Artiste 1\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Artiste 2]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Artiste 2], ci-après dénommé(e) \'l’Artiste 2\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Les artistes collaborent pour créer [Description de l’œuvre] avec un budget de [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'La collaboration commence le [Date de début].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom de l’Artiste 1',
      'Adresse de l’Artiste 1',
      'Nom de l’Artiste 2',
      'Adresse de l’Artiste 2',
      'Description de l’œuvre',
      'Montant',
      'Date de début',
      'Lieu',
      'Date'
    ],
    'partie': ['Artiste 1', 'Artiste 2']
  },
  {
    'title': 'Contrat de Projet Communautaire',
    'data': [
      {'insert': 'CONTRAT DE PROJET COMMUNAUTAIRE\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom de l’Organisation 1]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Organisation 1], ci-après dénommé(e) \'l’Organisation 1\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Organisation 2]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Organisation 2], ci-après dénommé(e) \'l’Organisation 2\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Les organisations collaborent pour le projet [Description du projet] avec un budget de [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le projet commence le [Date de début].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom de l’Organisation 1',
      'Adresse de l’Organisation 1',
      'Nom de l’Organisation 2',
      'Adresse de l’Organisation 2',
      'Description du projet',
      'Montant',
      'Date de début',
      'Lieu',
      'Date'
    ],
    'partie': ['Organisation 1', 'Organisation 2']
  },
];

final List<Map<String, dynamic>> contractPrestation = [
  {
    'title': 'Contrat de Consultation',
    'data': [
      {'insert': 'CONTRAT DE CONSULTATION\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Client]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Client], ci-après dénommé(e) \'le Client\',\n\nEt\n\n'},
      {'insert': '[Nom du Consultant]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Consultant], ci-après dénommé(e) \'le Consultant\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Consultant fournit des services de [Type de consultation] pour [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Durée\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'La consultation commence le [Date de début].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Client',
      'Adresse du Client',
      'Nom du Consultant',
      'Adresse du Consultant',
      'Type de consultation',
      'Montant',
      'Date de début',
      'Lieu',
      'Date'
    ],
    'partie': ['Client', 'Consultant']
  },
  {
    'title': 'Contrat de Photographie',
    'data': [
      {'insert': 'CONTRAT DE PHOTOGRAPHIE\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Client]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Client], ci-après dénommé(e) \'le Client\',\n\nEt\n\n'},
      {'insert': '[Nom du Photographe]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Photographe], ci-après dénommé(e) \'le Photographe\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Photographe réalise une séance photo pour [Événement] pour [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'La séance aura lieu le [Date de la séance].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Client',
      'Adresse du Client',
      'Nom du Photographe',
      'Adresse du Photographe',
      'Événement',
      'Montant',
      'Date de la séance',
      'Lieu',
      'Date'
    ],
    'partie': ['Client', 'Photographe']
  },
  {
    'title': 'Contrat d’Organisation d’Événement',
    'data': [
      {'insert': 'CONTRAT D’ORGANISATION D’ÉVÉNEMENT\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Client]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Client], ci-après dénommé(e) \'le Client\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Organisateur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Organisateur], ci-après dénommé(e) \'l’Organisateur\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’Organisateur organise l’événement [Type d’événement] pour [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'L’événement aura lieu le [Date de l’événement].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Client',
      'Adresse du Client',
      'Nom de l’Organisateur',
      'Adresse de l’Organisateur',
      'Type d’événement',
      'Montant',
      'Date de l’événement',
      'Lieu',
      'Date'
    ],
    'partie': ['Client', 'Organisateur']
  },
];

final List<Map<String, dynamic>> contractDon = [
  {
    'title': 'Contrat de Don d’Argent',
    'data': [
      {'insert': 'CONTRAT DE DON D’ARGENT\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Donateur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Donateur], ci-après dénommé(e) \'le Donateur\',\n\nEt\n\n'},
      {'insert': '[Nom du Bénéficiaire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Bénéficiaire], ci-après dénommé(e) \'le Bénéficiaire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Donateur donne une somme de [Montant] Ariary au Bénéficiaire.\n\n'},
      {'insert': 'Article 2 - Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le don est effectué le [Date du don].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Donateur',
      'Adresse du Donateur',
      'Nom du Bénéficiaire',
      'Adresse du Bénéficiaire',
      'Montant',
      'Date du don',
      'Lieu',
      'Date'
    ],
    'partie': ['Donateur', 'Bénéficiaire']
  },
  {
    'title': 'Contrat de Don de Biens',
    'data': [
      {'insert': 'CONTRAT DE DON DE BIENS\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Donateur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Donateur], ci-après dénommé(e) \'le Donateur\',\n\nEt\n\n'},
      {'insert': '[Nom du Bénéficiaire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Bénéficiaire], ci-après dénommé(e) \'le Bénéficiaire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Donateur donne les biens suivants : [Description des biens] au Bénéficiaire.\n\n'},
      {'insert': 'Article 2 - Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le don est effectué le [Date du don].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Donateur',
      'Adresse du Donateur',
      'Nom du Bénéficiaire',
      'Adresse du Bénéficiaire',
      'Description des biens',
      'Date du don',
      'Lieu',
      'Date'
    ],
    'partie': ['Donateur', 'Bénéficiaire']
  },
  {
    'title': 'Contrat de Don Caritatif',
    'data': [
      {'insert': 'CONTRAT DE DON CARITATIF\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Donateur]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Donateur], ci-après dénommé(e) \'le Donateur\',\n\nEt\n\n'},
      {'insert': '[Nom de l’Organisation]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse de l’Organisation], ci-après dénommé(e) \'l’Organisation\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Donateur donne une somme de [Montant] Ariary à l’Organisation pour [Cause].\n\n'},
      {'insert': 'Article 2 - Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le don est effectué le [Date du don].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Donateur',
      'Adresse du Donateur',
      'Nom de l’Organisation',
      'Adresse de l’Organisation',
      'Montant',
      'Cause',
      'Date du don',
      'Lieu',
      'Date'
    ],
    'partie': ['Donateur', 'Organisation']
  },
];

final List<Map<String, dynamic>> contractCession = [
  {
    'title': 'Contrat de Cession de Droits d’Auteur',
    'data': [
      {'insert': 'CONTRAT DE CESSION DE DROITS D’AUTEUR\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Cédant]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Cédant], ci-après dénommé(e) \'le Cédant\',\n\nEt\n\n'},
      {'insert': '[Nom du Cessionnaire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Cessionnaire], ci-après dénommé(e) \'le Cessionnaire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Cédant cède les droits d’auteur de l’œuvre [Description de l’œuvre] pour [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'La cession prend effet le [Date de cession].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Cédant',
      'Adresse du Cédant',
      'Nom du Cessionnaire',
      'Adresse du Cessionnaire',
      'Description de l’œuvre',
      'Montant',
      'Date de cession',
      'Lieu',
      'Date'
    ],
    'partie': ['Cédant', 'Cessionnaire']
  },
  {
    'title': 'Contrat de Cession de Brevet',
    'data': [
      {'insert': 'CONTRAT DE CESSION DE BREVET\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Cédant]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Cédant], ci-après dénommé(e) \'le Cédant\',\n\nEt\n\n'},
      {'insert': '[Nom du Cessionnaire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Cessionnaire], ci-après dénommé(e) \'le Cessionnaire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Cédant cède le brevet [Numéro du brevet] pour [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'La cession prend effet le [Date de cession].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Cédant',
      'Adresse du Cédant',
      'Nom du Cessionnaire',
      'Adresse du Cessionnaire',
      'Numéro du brevet',
      'Montant',
      'Date de cession',
      'Lieu',
      'Date'
    ],
    'partie': ['Cédant', 'Cessionnaire']
  },
  {
    'title': 'Contrat de Cession de Marque',
    'data': [
      {'insert': 'CONTRAT DE CESSION DE MARQUE\n', 'attributes': {'header': 3}},
      {'insert': '\nEntre les soussignés :\n'},
      {'insert': '[Nom du Cédant]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Cédant], ci-après dénommé(e) \'le Cédant\',\n\nEt\n\n'},
      {'insert': '[Nom du Cessionnaire]', 'attributes': {'bold': true}},
      {'insert': ', domicilié(e) à [Adresse du Cessionnaire], ci-après dénommé(e) \'le Cessionnaire\',\n\nIl a été convenu ce qui suit :\n\n'},
      {'insert': 'Article 1 - Objet du contrat\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Le Cédant cède la marque [Nom de la marque] pour [Montant] Ariary.\n\n'},
      {'insert': 'Article 2 - Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'La cession prend effet le [Date de cession].\n\n'},
      {'insert': 'Article 3 - Lieu et Date\n', 'attributes': {'bold': true, 'header': 3}},
      {'insert': 'Fait à [Lieu], le [Date].\n'}
    ],
    'placeholders': [
      'Nom du Cédant',
      'Adresse du Cédant',
      'Nom du Cessionnaire',
      'Adresse du Cessionnaire',
      'Nom de la marque',
      'Montant',
      'Date de cession',
      'Lieu',
      'Date'
    ],
    'partie': ['Cédant', 'Cessionnaire']
  },
];