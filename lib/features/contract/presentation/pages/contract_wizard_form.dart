import 'dart:math';
import 'package:e_contrat/features/contract/presentation/pages/contract_pdf_quill_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class WizardForm extends StatefulWidget {
  final List<String> placeholders;
  final List<dynamic> data;
  final List<String> partie;

  const WizardForm({
    super.key,
    required this.placeholders,
    required this.data,
    required this.partie,
  });

  @override
  State<WizardForm> createState() => _WizardFormState();
}

class _WizardFormState extends State<WizardForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  int _currentStep = 0;

  int get fieldsPerStep => 3;
  int get totalSteps => (widget.placeholders.length / fieldsPerStep).ceil();

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
      }
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Informations requises',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF3200d5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Étape ${_currentStep + 1} sur $totalSteps',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / totalSteps,
              backgroundColor: const Color(0xFF3200d5).withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3200d5)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                ...currentFields.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildField(p),
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: previousStep,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Color(0xFF3200d5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Précédent', style: TextStyle(color: Color(0xFF3200d5), fontWeight: FontWeight.bold)),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _currentStep == totalSteps - 1
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            final formData = _controllers.map((key, value) => MapEntry(key, value.text));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PdfQuill(
                                  formData: formData,
                                  documentModel: widget.data,
                                  partie: widget.partie,
                                  placeholder: widget.placeholders,
                                ),
                              ),
                            );
                          }
                        }
                      : nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3200d5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentStep == totalSteps - 1 ? 'Générer le contrat' : 'Suivant',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String placeholder) {
    final lower = placeholder.toLowerCase();
    final controller = _controllers[placeholder]!;

    return TextFormField(
      controller: controller,
      readOnly: lower.contains('date'),
      keyboardType: lower.contains('montant') ? TextInputType.number : TextInputType.text,
      inputFormatters: lower.contains('montant') ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        labelText: placeholder,
        hintText: 'Saisissez ici...',
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF3200d5), width: 1.5),
        ),
        prefixIcon: Icon(
          lower.contains('date') ? Icons.calendar_today_rounded : 
          lower.contains('montant') ? Icons.attach_money_rounded : 
          Icons.edit_note_rounded,
          color: const Color(0xFF3200d5).withValues(alpha: 0.7),
        ),
      ),
      onTap: lower.contains('date') ? () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          controller.text = DateFormat('dd-MM-yyyy').format(date);
        }
      } : null,
      validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
    );
  }

  @override
  void dispose() {
    _controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }
}
