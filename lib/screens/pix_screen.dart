import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../services/api_service.dart';

class PixScreen extends StatefulWidget {
  final String numeroConta;

  const PixScreen({super.key, required this.numeroConta});

  @override
  _PixScreenState createState() => _PixScreenState();
}

class _PixScreenState extends State<PixScreen> {
  final ApiService _apiService = ApiService('https://localhost:8080');
  bool _isQrCodeGenerated = false;
  String _qrCodeData = '';
  String _errorMessage = '';

  Future<void> _generateQrCode(double amount) async {
    final qrCodeData = jsonEncode({
      'numeroContaDestinatario': widget.numeroConta,
      'amount': amount,
    });

    setState(() {
      _qrCodeData = qrCodeData;
      _isQrCodeGenerated = true;
    });
  }

  Future<void> _scanQRCode() async {
    try {
      final scannedData = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Cor do botão de cancelar
        'Cancelar', // Texto do botão de cancelar
        true, // Mostrar a grade do scanner
        ScanMode.QR,
      );

      if (scannedData != '-1') {
        // Decodifica o QR Code em um Map
        final Map<String, dynamic>? decodedData =
            jsonDecode(scannedData) as Map<String, dynamic>?;

        if (decodedData != null) {
          final response = await _apiService.transferir(decodedData);

          if (response == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pagamento realizado com sucesso!')),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro desconhecido.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dados do QR Code inválidos.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar pagamento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PIX'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isQrCodeGenerated)
              Expanded(
                child: QrImageView(
                  data: _qrCodeData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            if (_isQrCodeGenerated) const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _scanQRCode();
              },
              child: const Text('Pagar com QR Code'),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                final amount = double.tryParse(value);
                if (amount != null) {
                  _generateQrCode(amount);
                } else {
                  setState(() {
                    _errorMessage = 'Digite um valor válido.';
                  });
                }
              },
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
