import 'package:flutter/material.dart';

class BalanceScreen extends StatefulWidget {
  final double currentBalance;

  const BalanceScreen({super.key, required this.currentBalance});

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  bool isBalanceVisible = true; // Estado para controlar a visibilidade do saldo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saldo Atual'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Seu Saldo Atual é:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              isBalanceVisible
                  ? 'R\$ ${widget.currentBalance.toStringAsFixed(2)}'
                  : 'R\$ ****,**', // Alterna entre mostrar e esconder o saldo
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isBalanceVisible = !isBalanceVisible; // Altera o estado da visibilidade
                });
              },
              child: Text(isBalanceVisible ? 'Esconder Saldo' : 'Exibir Saldo'), // Altera o texto do botão
            ),
          ],
        ),
      ),
    );
  }
}
