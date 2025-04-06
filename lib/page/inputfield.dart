import 'package:flutter/material.dart';
import 'package:e_contrat/page/quill.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    "Nom": TextEditingController(),
    "Date": TextEditingController(),
    "Montant": TextEditingController(),
  };

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Remplir les données")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controllers["Nom"],
                decoration: InputDecoration(labelText: "Nom"),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              TextFormField(
                controller: _controllers["Date"],
                decoration: InputDecoration(labelText: "Date"),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              TextFormField(
                controller: _controllers["Montant"],
                decoration: InputDecoration(labelText: "Montant"),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, String> formData = {};
                    _controllers.forEach((key, controller) {
                      formData[key] = controller.text;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Editor(formData: formData),
                      ),
                    );
                  }
                },
                child: Text("Suivant : Rédiger le motif"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}