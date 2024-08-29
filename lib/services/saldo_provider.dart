// saldo_provider.dart

import 'package:flutter/material.dart';

class SaldoProvider with ChangeNotifier {
  bool _saldoVisivel = false;

  bool get saldoVisivel => _saldoVisivel;

  void toggleSaldoVisibility() {
    _saldoVisivel = !_saldoVisivel;
    notifyListeners();
  }

  void setSaldoVisibility(bool visibility) {
    _saldoVisivel = visibility;
    notifyListeners();
  }
}
