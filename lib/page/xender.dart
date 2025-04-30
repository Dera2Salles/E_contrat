import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contract Transfer App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  String? _qrData;
  bool _isHotspotEnabled = false;
  Uint8List? _signatureBytes;
  HttpServer? _server;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  String? scannedData;
  Uint8List? _receivedSignatureBytes;

  // Capture signature as Uint8List
  Future<void> _saveSignature() async {
    final image = await _signaturePadKey.currentState!.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      _signatureBytes = byteData!.buffer.asUint8List();
    });
  }

  // Start HTTP server to serve signature bytes
  Future<void> _startServer() async {
    if (_signatureBytes == null) return;
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
    setState(() {
      _server = server;
    });
    server.listen((HttpRequest request) async {
      if (request.uri.path == '/signature') {
        request.response
          ..headers.contentType = ContentType('image', 'png')
          ..add(_signatureBytes!)
          ..close();
      }
    });
  }

  // Enable hotspot and generate QR code
  Future<void> _enableHotspotAndGenerateQR() async {
    if (await Permission.location.request().isGranted) {
      try {
        await WiFiForIoTPlugin.setWiFiAPEnabled(true);
        setState(() {
          _isHotspotEnabled = true;
        });
        await _startServer();
        final data = {
          'name': _nameController.text,
          'surname': _surnameController.text,
          'address': _addressController.text,
          'server_ip': '192.168.43.1', // Typical hotspot IP
          'server_port': 8080,
        };
        setState(() {
          _qrData = jsonEncode(data);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hotspot and server enabled')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Scan QR code and fetch signature
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        scannedData = scanData.code;
      });
      final data = jsonDecode(scanData.code!);
      final serverUrl = 'http://${data['server_ip']}:${data['server_port']}/signature';
      final response = await http.get(Uri.parse(serverUrl));
      if (response.statusCode == 200) {
        setState(() {
          _receivedSignatureBytes = response.bodyBytes;
        });
      }
      controller.pauseCamera();
    });
  }

  @override
  void dispose() {
    _server?.close();
    qrController?.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contract Transfer App')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields for debtor
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 10),
            Text('Signature Pad', style: TextStyle(fontSize: 16)),
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(border: Border.all()),
              child: SfSignaturePad(
                key: _signaturePadKey,
                backgroundColor: Colors.white,
                strokeColor: Colors.black,
                minimumStrokeWidth: 2.0,
                maximumStrokeWidth: 4.0,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveSignature,
              child: Text('Save Signature'),
            ),
            if (_signatureBytes != null)
              Image.memory(_signatureBytes!, height: 100, width: 100),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _enableHotspotAndGenerateQR,
              child: Text('Enable Hotspot & Generate QR Code'),
            ),
            if (_qrData != null) ...[
              SizedBox(height: 20),
              QrImageView(
                data: _qrData!,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ],
            SizedBox(height: 20),
            // QR Scanner for creditor
            Text('Scan QR Code', style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 300,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            if (scannedData != null) ...[
              SizedBox(height: 20),
              Text('Received Data:', style: TextStyle(fontSize: 16)),
              Text(scannedData!),
              if (_receivedSignatureBytes != null)
                Image.memory(_receivedSignatureBytes!, height: 100, width: 100),
            ],
          ],
        ),
      ),
    );
  }
}