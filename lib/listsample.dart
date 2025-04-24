import 'package:e_contrat/page/inputfield.dart';
import 'package:flutter/material.dart';

class Listsample extends StatelessWidget {
  const Listsample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContractListScreen(),
    );
  }
}

// Sample contract data (based on your kContratSample)
final List<Map<String, dynamic>> contractTemplates = [
  {
    'title': 'CONTRAT DE VENTE DE VÉHICULE D’OCCASION',
    'data': [
      {"insert": "CONTRAT DE VENTE DE VÉHICULE D’OCCASION\n", "attributes": {"header": 1}},
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
      
      // Add more Delta operations as needed
    ],
  },
  {
    'title': 'CONTRAT DE VENTE',
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
  },

];

class ContractListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contract Templates')),
      body: PageView.builder(
        scrollDirection: Axis.vertical, // Vertical scrolling
        itemCount: contractTemplates.length,
        itemBuilder: (context, index) {
          final contract = contractTemplates[index];
          return ContractItem(
            title: contract['title'],
            data: contract['data'],
          );
        },
      ),
    );
  }
}

class ContractItem extends StatelessWidget {
  final String title;
  final List<dynamic> data;

  const ContractItem({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Full screen height
      color: Colors.grey[200],
      child: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // Display a preview or placeholder for the Delta data
                Text(
                  'Preview: ${data.first['insert']}',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to a detailed view or editor
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormScreen(
                          template: data,
                        ),
                      ),
                    );
                  },
                  child: Text('Choisir'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
