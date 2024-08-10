import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ChangePasswordForm(),
      ),
    );
  }
}

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Senha Atual'),
          obscureText: true,
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Nova Senha'),
          obscureText: true,
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Confirmar Nova Senha'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Alterar senha
          },
          child: const Text('Alterar Senha'),
        ),
      ],
    );
  }
}
