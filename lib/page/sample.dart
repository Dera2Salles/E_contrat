
final List<Map<String, dynamic>> contractVente = [
  {
    'data': [
      {"insert": "         CONTRAT DE VENTE DE VÉHICULE D’OCCASION\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Vendeur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Vendeur], ci-après dénommé(e) 'le Vendeur',\n\nEt\n\n"},
    {"insert": "[Nom de l’Acheteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse de l’Acheteur], ci-après dénommé(e) 'l’Acheteur',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Vendeur vend à l’Acheteur le véhicule suivant : [Marque, Modèle, Année, Numéro d’immatriculation].\n\n"},
    {"insert": "Article 2 - Prix\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le prix de vente s’élève à [Montant] euros, payable le [Date de paiement].\n\n"},
    {"insert": "Article 3 - Transfert de propriété\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le transfert de propriété aura lieu le [Date de transfert] après paiement intégral.\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Vendeur : ____________________\nL’Acheteur : ____________________\n"}
      

    ],
    'placeholders': ['Nom du Vendeur', 'Adresse du Vendeur', 'Nom de l’Acheteur', 'Adresse de l’Acheteur', 'Marque, Modèle, Année, Numéro d’immatriculation', 'Montant', 'Date de paiement', 'Date de transfert', 'Lieu', 'Date'],
    'partie':['Vendeur', 'Acheteur']
  },
  {
   
    'data': [
    {"insert": "CONTRAT DE VENTE\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Vendeur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Vendeur], ci-après dénommé(e) 'le Vendeur',\n\nEt\n\n"},
    {"insert": "[Nom de l’Acheteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse de l’Acheteur], ci-après dénommé(e) 'l’Acheteur',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Vendeur s’engage à vendre à l’Acheteur le bien suivant : [Description du bien].\n\n"},
    {"insert": "Article 2 - Prix\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le prix de vente s’élève à [Montant] payable selon les modalités : [Modalités de paiement].\n\n"},
    {"insert": "Article 3 - Livraison\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le bien sera livré à [Lieu de livraison] le [Date de livraison].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Vendeur : ____________________\nL’Acheteur : ____________________\n"}
    ],
    'placeholders': ['Nom du Vendeur', 'Adresse du Vendeur', 'Nom de l’Acheteur', 'Adresse de l’Acheteur', 'Description du bien', 'Montant', 'Modalités de paiement', 'Lieu de livraison', 'Date de livraison', 'Lieu', 'Date'],
    'partie':['Vendeur', 'Acheteur']
  },

];




final List<Map<String, dynamic>> contractEvent = [
  {

    'data': [
      {"insert": "CONTRAT DE PRESTATION EN RÉDACTION\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Rédacteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Rédacteur], ci-après dénommé(e) 'le Rédacteur',\n\nEt\n\n"},
    {"insert": "[Nom du Client]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Client], ci-après dénommé(e) 'le Client',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Rédacteur produira [Description, ex. articles, contenu web].\n\n"},
    {"insert": "Article 2 - Délai\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le contenu sera livré d’ici le [Date de livraison].\n\n"},
    {"insert": "Article 3 - Rémunération\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Client paiera [Montant] Ariary par [mot/projet].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\n\n"}
      // Add more Delta operations as needed
    ],
    'placeholders':[
      'Nom du Rédacteur',
      'Adresse du Rédacteur',
      'Nom du Client',
      'Adresse du Client',
      'Description, ex. articles, contenu web',
      'Date de livraison',
      'Montant',
      'mot/projet',
      'Lieu',
      'Date'

    ],
    'partie':[' Rédacteur', 'Client']
  },
  {
 
    'data': [
   {"insert": "CONTRAT DE PHOTOGRAPHIE DE MARIAGE\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Photographe]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Photographe], ci-après dénommé(e) 'le Photographe',\n\nEt\n\n"},
    {"insert": "[Nom du Client]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Client], ci-après dénommé(e) 'le Client',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Photographe couvrira le mariage du [Date du Mariage] à [Lieu du Mariage].\n\n"},
    {"insert": "Article 2 - Services\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les services incluent [Nombre] heures de couverture et [Nombre] photos éditées.\n\n"},
    {"insert": "Article 3 - Rémunération\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Client paiera [Montant] euros selon [Modalités].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\n\n"}

    ],
    'placeholders':[
      'Nom du Photographe',
      'Nom du Photographe',
      'Nom du Client',
      'Nom du Client',
      'Date du Mariage',
      'Lieu du Mariage',
      'Nombre',
      'Montant',
      'Modalités',
      'Lieu',
      'Date'





    ],
    'partie':['Photographe', 'Client']
  },
   {
    
    'data': [
    {"insert": "CONTRAT D’ORGANISATION D’ÉVÉNEMENT\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom de l’Organisateur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse de l’Organisateur], ci-après dénommé(e) 'l’Organisateur',\n\nEt\n\n"},
    {"insert": "[Nom du Client]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Client], ci-après dénommé(e) 'le Client',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "L’Organisateur s’engage à organiser l’événement suivant : [Description de l’événement].\n\n"},
    {"insert": "Article 2 - Budget\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le coût total de l’organisation s’élève à [Montant] payable selon [Modalités].\n\n"},
    {"insert": "Article 3 - Date\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "L’événement aura lieu le [Date] à [Lieu].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nL’Organisateur : ____________________\nLe Client : ____________________\n"}

    ],
     'partie':['Vendeur', 'Acheteur']
  }, {
  
    'data': [
  {"insert": "CONTRAT DE PHOTOGRAPHIE D’ÉVÉNEMENT\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Photographe]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Photographe], ci-après dénommé(e) 'le Photographe',\n\nEt\n\n"},
    {"insert": "[Nom du Client]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Client], ci-après dénommé(e) 'le Client',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Photographe couvrira l’événement suivant : [Description de l’événement].\n\n"},
    {"insert": "Article 2 - Date et lieu\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "L’événement aura lieu le [Date] à [Lieu].\n\n"},
    {"insert": "Article 3 - Rémunération\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Client paiera [Montant] euros selon [Modalités de paiement].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Photographe : ____________________\nLe Client : ____________________\n"}

    ],
    'partie':['Vendeur', 'Acheteur']
  },

];




final List<Map<String, dynamic>> contractService = [
  {
   
    'data': [
     {"insert": "CONTRAT DE PRESTATION DE RÉPARATIONS DOMESTIQUES\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Prestataire]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Prestataire], ci-après dénommé(e) 'le Prestataire',\n\nEt\n\n"},
    {"insert": "[Nom du Client]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Client], ci-après dénommé(e) 'le Client',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Prestataire s’engage à effectuer les réparations suivantes : [Description des travaux].\n\n"},
    {"insert": "Article 2 - Durée\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les travaux commenceront le [Date de début] et seront terminés au plus tard le [Date de fin].\n\n"},
    {"insert": "Article 3 - Rémunération\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Client paiera [Montant] euros selon les modalités suivantes : [Modalités de paiement].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Prestataire : ____________________\nLe Client : ____________________\n"}
      
      // Add more Delta operations as needed
    ],
    'partie':['Vendeur', 'Acheteur']
  },
  {
 
    'data': [
     {"insert": "CONTRAT DE SERVICE DE PLOMBERIE\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Plombier]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Plombier], ci-après dénommé(e) 'le Plombier',\n\nEt\n\n"},
    {"insert": "[Nom du Client]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Client], ci-après dénommé(e) 'le Client',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Plombier s’engage à effectuer les travaux de plomberie suivants : [Description des travaux].\n\n"},
    {"insert": "Article 2 - Durée\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les travaux débuteront le [Date de début] et seront terminés le [Date de fin].\n\n"},
    {"insert": "Article 3 - Rémunération\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Client paiera [Montant] euros selon les modalités : [Modalités de paiement].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Plombier : ____________________\nLe Client : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },

];




final List<Map<String, dynamic>> contractPret = [
  {
    
    'data': [
    {"insert": "CONTRAT DE PRÊT FAMILIAL\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Prêteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Prêteur], ci-après dénommé(e) 'le Prêteur',\n\nEt\n\n"},
    {"insert": "[Nom de l’Emprunteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse de l’Emprunteur], ci-après dénommé(e) 'l’Emprunteur',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Prêteur consent un prêt de [Montant] euros à l’Emprunteur pour [Raison].\n\n"},
    {"insert": "Article 2 - Durée\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le prêt devra être remboursé d’ici le [Date de fin].\n\n"},
    {"insert": "Article 3 - Modalités\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "L’Emprunteur remboursera [Modalités, ex. mensualités ou somme unique].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Prêteur : ____________________\nL’Emprunteur : ____________________\n"}
      
      // Add more Delta operations as needed
    ],
    'partie':['Vendeur', 'Acheteur']
  },
  {
   
    'data': [
     {"insert": "CONTRAT DE PRÊT ENTRE AMIS\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Prêteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Prêteur], ci-après dénommé(e) 'le Prêteur',\n\nEt\n\n"},
    {"insert": "[Nom de l’Emprunteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse de l’Emprunteur], ci-après dénommé(e) 'l’Emprunteur',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Prêteur prête [Montant] euros à l’Emprunteur pour [Raison].\n\n"},
    {"insert": "Article 2 - Remboursement\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "L’Emprunteur s’engage à rembourser le [Date] en une seule fois.\n\n"},
    {"insert": "Article 3 - Intérêts\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le prêt est assorti d’un taux d’intérêt de [Taux, ou 0% si sans intérêt].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Prêteur : ____________________\nL’Emprunteur : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },
    {
   
    'data': [
     {"insert": "CONTRAT DE PRÊT ENTRE AMIS\n", "attributes": {"header": 1}},
   {"insert": "CONTRAT DE PRÊT SANS INTÉRÊT\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Prêteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Prêteur], ci-après dénommé(e) 'le Prêteur',\n\nEt\n\n"},
    {"insert": "[Nom de l’Emprunteur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse de l’Emprunteur], ci-après dénommé(e) 'l’Emprunteur',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Prêteur consent un prêt sans intérêt de [Montant] euros à l’Emprunteur.\n\n"},
    {"insert": "Article 2 - Remboursement\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "L’Emprunteur remboursera selon [Modalités, ex. mensualités] d’ici le [Date].\n\n"},
    {"insert": "Article 3 - Garanties\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Aucune garantie n’est exigée sauf accord contraire.\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Prêteur : ____________________\nL’Emprunteur : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },

];


final List<Map<String, dynamic>> contractMaison = [
  {

    'data': [
    {"insert": "CONTRAT DE LOCATION DE MAISON\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Bailleur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Bailleur], ci-après dénommé(e) 'le Bailleur',\n\nEt\n\n"},
    {"insert": "[Nom du Locataire]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Locataire], ci-après dénommé(e) 'le Locataire',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Bailleur loue au Locataire la maison située à [Adresse de la maison] pour une durée de [Durée].\n\n"},
    {"insert": "Article 2 - Loyer\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le loyer mensuel s’élève à [Montant] euros, payable le [Jour] de chaque mois.\n\n"},
    {"insert": "Article 3 - Entretien\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Locataire est responsable de l’entretien du jardin et des réparations mineures.\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Bailleur : ____________________\nLe Locataire : ____________________\n"}
      
      // Add more Delta operations as needed
    ],
    'partie':['Vendeur', 'Acheteur']
  },
  {
   
    'data': [
      {"insert": "CONTRAT DE COLOCATION DE MAISON\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Colocataire 1]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Colocataire 1], ci-après dénommé(e) 'le Colocataire 1',\n\nEt\n\n"},
    {"insert": "[Nom du Colocataire 2]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Colocataire 2], ci-après dénommé(e) 'le Colocataire 2',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les Colocataires partagent la maison située à [Adresse de la maison].\n\n"},
    {"insert": "Article 2 - Frais\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les frais (loyer, charges) de [Montant] euros sont répartis selon [Répartition].\n\n"},
    {"insert": "Article 3 - Entretien\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les Colocataires partagent l’entretien du jardin et des espaces communs.\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nColocataire 1 : ____________________\nColocataire 2 : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },
    {

    'data': [
     {"insert": "CONTRAT DE BAIL RÉSIDENTIEL\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Bailleur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Bailleur], ci-après dénommé(e) 'le Bailleur',\n\nEt\n\n"},
    {"insert": "[Nom du Locataire]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Locataire], ci-après dénommé(e) 'le Locataire',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Bailleur loue au Locataire le logement situé à [Adresse du logement] pour une durée de [Durée].\n\n"},
    {"insert": "Article 2 - Loyer\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le loyer mensuel s’élève à [Montant] euros, payable le [Jour] de chaque mois.\n\n"},
    {"insert": "Article 3 - Dépôt de garantie\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Locataire verse un dépôt de garantie de [Montant] euros, remboursable à la fin du bail.\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Bailleur : ____________________\nLe Locataire : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },

  {

    'data': [
      {"insert": "CONTRAT DE COLOCATION\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Colocataire 1]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Colocataire 1], ci-après dénommé(e) 'le Colocataire 1',\n\nEt\n\n"},
    {"insert": "[Nom du Colocataire 2]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Colocataire 2], ci-après dénommé(e) 'le Colocataire 2',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}  },
    {"insert": "Les Colocataires partagent le logement situé à [Adresse du logement].\n\n"},
    {"insert": "Article 2 - Répartition des frais\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le loyer et les charges sont répartis comme suit : [Répartition].\n\n"},
    {"insert": "Article 3 - Règles de vie\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les Colocataires s’engagent à respecter les règles suivantes : [Règles].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nColocataire 1 : ____________________\nColocataire 2 : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },


  {

    'data': [
       {"insert": "CONTRAT DE COLOCATION ÉTUDIANTE\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Colocataire 1]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Colocataire 1], ci-après dénommé(e) 'le Colocataire 1',\n\nEt\n\n"},
    {"insert": "[Nom du Colocataire 2]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Colocataire 2], ci-après dénommé(e) 'le Colocataire 2',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les Colocataires partagent le logement étudiant à [Adresse du logement].\n\n"},
    {"insert": "Article 2 - Loyer\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Chaque Colocataire paie [Montant] euros par mois pour le loyer et les charges.\n\n"},
    {"insert": "Article 3 - Règles\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les Colocataires s’engagent à respecter [Règles, ex. horaires d’étude, bruit].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nColocataire 1 : ____________________\nColocataire 2 : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },

  {

    'data': [
      {"insert": "CONTRAT DE BAIL D’APPARTEMENT\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Bailleur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Bailleur], ci-après dénommé(e) 'le Bailleur',\n\nEt\n\n"},
    {"insert": "[Nom du Locataire]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Locataire], ci-après dénommé(e) 'le Locataire',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Bailleur loue au Locataire l’appartement situé à [Adresse de l’appartement] pour une durée de [Durée].\n\n"},
    {"insert": "Article 2 - Loyer\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le loyer mensuel s’élève à [Montant] euros, payable le [Jour] de chaque mois.\n\n"},
    {"insert": "Article 3 - Charges\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Les charges mensuelles s’élèvent à [Montant] euros pour [eau, électricité, etc.].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Bailleur : ____________________\nLe Locataire : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },


  {

    'data': [
       {"insert": "CONTRAT DE LOCATION SAISONNIÈRE\n", "attributes": {"header": 1}},
    {"insert": "\nEntre les soussignés :\n"},
    {"insert": "[Nom du Bailleur]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Bailleur], ci-après dénommé(e) 'le Bailleur',\n\nEt\n\n"},
    {"insert": "[Nom du Locataire]", "attributes": {"bold": true}},
    {"insert": ", domicilié(e) à [Adresse du Locataire], ci-après dénommé(e) 'le Locataire',\n\nIl a été convenu ce qui suit :\n\n"},
    {"insert": "Article 1 - Objet du contrat\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Bailleur loue au Locataire le logement situé à [Adresse du logement] du [Date de début] au [Date de fin].\n\n"},
    {"insert": "Article 2 - Prix\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le prix total de la location s’élève à [Montant] euros, payable à la signature.\n\n"},
    {"insert": "Article 3 - Conditions\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Le Locataire s’engage à respecter les règles de la propriété, notamment [Règles spécifiques].\n\n"},
    {"insert": "Article 4 - Signatures\n", "attributes": {"bold": true, "header": 2}},
    {"insert": "Fait à [Lieu], le [Date].\n\nLe Bailleur : ____________________\nLe Locataire : ____________________\n"}
    ],
    'partie':['Vendeur', 'Acheteur']
  },
];