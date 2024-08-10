import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(labelText: 'CPF'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Nome'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Senha'),
          obscureText: true,
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Confirme a Senha'),
          obscureText: true,
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'E-mail'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Data de Nascimento'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Cadastro completo
            Navigator.pop(context);
          },
          child: const Text('Cadastrar'),
        ),
      ],
    );
  }
}
