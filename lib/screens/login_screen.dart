import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key})
      : super(key: key); // Adicionado o `Key? key` e `const`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), // `const` adicionado
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // `const` adicionado
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0), // `const` adicionado
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0), // `const` adicionado
            ElevatedButton(
              onPressed: () {
                // Logic to handle login
              },
              child: const Text('Login'), // `const` adicionado
            ),
          ],
        ),
      ),
    );
  }
}
