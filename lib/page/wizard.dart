import 'dart:math';

import 'package:e_contrat/page/pdfquill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class WizardForm extends StatefulWidget {
  final List<String> placeholders;
  final List<dynamic> data;
   final List<String> partie;

  const WizardForm({super.key, required this.placeholders,  required this.data, required this.partie});

  @override
  State<WizardForm> createState() => _WizardFormState();
}

class _WizardFormState extends State<WizardForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  int _currentStep = 0;

  int get fieldsPerStep => 3;
  int get totalSteps =>
      (widget.placeholders.length / fieldsPerStep).ceil();

  @override
  void initState() {
    super.initState();
    for (var placeholder in widget.placeholders) {
      _controllers[placeholder] = TextEditingController();
    }
  }

  List<String> get currentFields {
    final start = _currentStep * fieldsPerStep;
    final end = min(start + fieldsPerStep, widget.placeholders.length);
    return widget.placeholders.sublist(start, end);
  }

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < totalSteps - 1) {
        setState(() => _currentStep++);
      } else {
        final data = {
          for (var key in widget.placeholders)
            key: _controllers[key]?.text ?? ''
        };
        Navigator.pop(context, data);
      }
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Widget buildField(String placeholder) {
    final lower = placeholder.toLowerCase();
    final controller = _controllers[placeholder]!;

    if (lower.contains('date')) {
      return TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: placeholder,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            controller.text = date.toIso8601String().split('T').first;
          }
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Champ requis' : null,
      );
    } else if (lower.contains('montant')) {
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: placeholder),
        validator: (value) =>
            value == null || value.isEmpty ? 'Champ requis' : null,
      );
    } else {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: placeholder),
        validator: (value) =>
            value == null || value.isEmpty ? 'Champ requis' : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text( 'Veuillez remplir',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color :Color(0xFF3200d5),),
                                                         ),
                                                         SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / totalSteps,
                    color:Color(0xFF3200d5) ,
                  ),
                  const SizedBox(height: 20),
                  ...currentFields.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: buildField(p),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        SizedBox(
                          width: 30.w,
                        height: 7.h,
                          child: FloatingActionButton(
                            shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(30)
                                                          ) ,
                            elevation: 2,
                            onPressed: previousStep,
                            child: const Text('Précédent',
                            style:TextStyle(
                                                             color:  Color(0xFF3200d5),
                                                        
                                                             fontWeight: FontWeight.bold
                                                          )),
                          ),
                        ),
                      SizedBox(
                        width: 30.w,
                        height: 7.h,
                        child: FloatingActionButton(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(30)
                                                          ) ,
                        
                          onPressed: _currentStep == totalSteps - 1 ? (){
                            if (_formKey.currentState!.validate()) {
                                                Map<String, String> formData = {};
                                                _controllers.forEach((key, controller) {
                                                  formData[key] = controller.text;
                                                });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => PdfQuill(formData: formData, documentModel: widget.data, partie: widget.partie , placeholder:widget.placeholders),
                                                  ),
                                                );
                                              }
                          }: nextStep,
                          child: Text(
                              _currentStep == totalSteps - 1 ? 'Rédiger le motif' : 'Suivant',
                              style:TextStyle(
                                                             color:  Color(0xFF3200d5),
                                                        
                                                             fontWeight: FontWeight.bold
                                                          ) 
                              ,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
