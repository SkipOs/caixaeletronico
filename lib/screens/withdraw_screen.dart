import 'package:flutter/material.dart';

class WithdrawalScreen extends StatelessWidget {
  const WithdrawalScreen({Key? key})
      : super(key: key); // Adicionado o `Key? key` e `const`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saque'), // `const` adicionado
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // `const` adicionado
        child: Column(
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'Valor',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0), // `const` adicionado
            ElevatedButton(
              onPressed: () {
                // Logic to handle withdrawal
              },
              child: const Text('Saque'), // `const` adicionado
            ),
          ],
        ),
      ),
    );
  }
}
