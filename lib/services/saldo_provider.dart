import 'dart:async';
import 'package:flutter/material.dart';

class SaldoProvider with ChangeNotifier {
  bool _saldoVisivel = false;
  final StreamController<String> _saldoController = StreamController<String>();

  bool get saldoVisivel => _saldoVisivel;
  Stream<String> get saldoStream => _saldoController.stream;

  void toggleSaldoVisibility() {
    _saldoVisivel = !_saldoVisivel;
    notifyListeners();
  }

  void setSaldoVisibility(bool visibility) {
    _saldoVisivel = visibility;
    notifyListeners();
  }

  void updateSaldo(String saldo) {
    _saldoController.add(saldo);
  }

  @override
  void dispose() {
    _saldoController.close();
    super.dispose();
  }
}
