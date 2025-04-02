//MANDEHA TSARA


import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePadPage extends StatefulWidget {
  const SignaturePadPage({super.key});

  @override
  State<SignaturePadPage> createState() => _SignaturePadPageState();
}

class _SignaturePadPageState extends State<SignaturePadPage> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  void _clearSignature() {
    _signaturePadKey.currentState!.clear();
  }

  Future<void> _saveSignature() async {
    final ui.Image data = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    if (bytes != null) {
      // Afficher l'image ou la sauvegarder
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Signature Sauvegardée')),
              body: Center(
                child: Image.memory(bytes.buffer.asUint8List()),
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signature Pad Exemple')),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: SfSignaturePad(
              key: _signaturePadKey,
              backgroundColor: Colors.white,
              strokeColor: Colors.black,
              minimumStrokeWidth: 1.0,
              maximumStrokeWidth: 4.0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _saveSignature,
                child: const Text('Sauvegarder'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _clearSignature,
                child: const Text('Effacer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}