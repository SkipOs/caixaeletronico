import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;

  const CustomInputField({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      obscureText: isPassword,
      keyboardType: keyboardType,
    );
  }
}
