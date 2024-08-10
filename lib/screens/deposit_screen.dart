import 'package:flutter/material.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depósito'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: DepositForm(),
      ),
    );
  }
}

class DepositForm extends StatelessWidget {
  const DepositForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Saldo Atual: R\$ 12.123,98',
          style: TextStyle(fontSize: 24),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Valor de Depósito'),
          keyboardType: TextInputType.number,
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Senha'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Realizar depósito
            Navigator.pop(context);
          },
          child: const Text('Realizar Depósito'),
        ),
      ],
    );
  }
}
