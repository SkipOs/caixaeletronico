import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../services/api_service.dart';
import '../services/saldo_provider.dart';

class PixScreen extends StatefulWidget {
  final String numeroConta;

  const PixScreen({super.key, required this.numeroConta});

  @override
  _PixScreenState createState() => _PixScreenState();
}

class _PixScreenState extends State<PixScreen> {
  final ApiService _apiService = ApiService('http://localhost:8080');
  final SaldoProvider _saldoProvider = SaldoProvider();
  bool _isQrCodeGenerated = false;
  String _qrCodeData = '';
  final String _errorMessage = '';

  Future<void> _generateQrCode(double amount) async {
    final qrCodeData = jsonEncode({
      'idContaRemetente': widget.numeroConta, // ID do remetente
      'numeroContaDestinatario':
          widget.numeroConta, // Número da conta para depósito
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
        final response = await _apiService.urubudopix(scannedData);

        if (response['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pagamento realizado com sucesso!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
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
