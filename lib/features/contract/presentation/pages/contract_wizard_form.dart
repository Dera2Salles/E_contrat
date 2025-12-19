import 'dart:math';
import 'dart:ui' as ui;
import 'package:e_contrat/features/contract/presentation/pages/contract_pdf_quill_page.dart';
import 'package:e_contrat/features/contract/presentation/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(context.rs(32)),
        topRight: Radius.circular(context.rs(32)),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.rs(32)),
              topRight: Radius.circular(context.rs(32)),
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          padding: EdgeInsets.only(
            top: context.rs(20),
            left: context.rs(24),
            right: context.rs(24),
            bottom: MediaQuery.of(context).viewInsets.bottom + context.rs(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: context.rs(48),
                  height: context.rs(5),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(context.rs(10)),
                  ),
                ),
              ),
              SizedBox(height: context.rs(28)),
              Text(
                'Informations requises',
                style: TextStyle(
                  fontSize: context.rf(24),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Outfit',
                  color: scheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: context.rs(6)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Étape ${_currentStep + 1} sur $totalSteps',
                    style: TextStyle(
                      fontSize: context.rf(14),
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${((_currentStep + 1) / totalSteps * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: context.rf(14),
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.rs(12)),
              ClipRRect(
                borderRadius: BorderRadius.circular(context.rs(10)),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / totalSteps,
                  backgroundColor: scheme.primary.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                  minHeight: context.rs(8),
                ),
              ),
              SizedBox(height: context.rs(32)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ...currentFields.map((p) => Padding(
                      padding: EdgeInsets.only(bottom: context.rs(20)),
                      child: _buildField(p),
                    )),
                  ],
                ),
              ),
              SizedBox(height: context.rs(16)),
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: TextButton(
                        onPressed: previousStep,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: context.rs(18)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.rs(18)),
                            side: BorderSide(color: scheme.primary.withValues(alpha: 0.2)),
                          ),
                        ),
                        child: Text(
                          'Précédent',
                          style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.rf(16),
                          ),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: context.rs(16)),
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
                        backgroundColor: scheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: context.rs(18)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.rs(18)),
                        ),
                        elevation: 8,
                        shadowColor: scheme.primary.withValues(alpha: 0.3),
                      ),
                      child: Text(
                        _currentStep == totalSteps - 1 ? 'Générer le contrat' : 'Suivant',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: context.rf(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String placeholder) {
    final lower = placeholder.toLowerCase();
    final controller = _controllers[placeholder]!;
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      readOnly: lower.contains('date'),
      keyboardType: lower.contains('montant') ? TextInputType.number : TextInputType.text,
      inputFormatters: lower.contains('montant') ? [FilteringTextInputFormatter.digitsOnly] : null,
      style: TextStyle(
        fontSize: context.rf(16),
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: placeholder,
        labelStyle: TextStyle(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
          fontSize: context.rf(14),
          fontWeight: FontWeight.w500,
        ),
        hintText: 'Saisissez ici...',
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
          fontSize: context.rf(14),
        ),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rs(20),
          vertical: context.rs(18),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.rs(12)),
          child: Icon(
            lower.contains('date') ? Icons.calendar_today_rounded : 
            lower.contains('montant') ? Icons.attach_money_rounded : 
            Icons.edit_note_rounded,
            color: scheme.primary.withValues(alpha: 0.7),
            size: context.rs(22),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: context.rs(48)),
      ),
      onTap: lower.contains('date') ? () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: scheme,
              ),
              child: child!,
            );
          },
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
