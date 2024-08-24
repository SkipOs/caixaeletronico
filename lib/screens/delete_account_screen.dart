import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluir Conta'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: DeleteAccountForm(),
      ),
    );
  }
}

class DeleteAccountForm extends StatelessWidget {
  const DeleteAccountForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(labelText: 'Senha'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Excluir conta
            Navigator.pop(context);
          },
          child: const Text('Excluir Conta'),
        ),
      ],
    );
  }
}
