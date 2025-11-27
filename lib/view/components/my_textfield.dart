import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  // Adicione a variável para a cor
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color? fillColor; // Nova propriedade

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.fillColor, // Adicione ao construtor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          // Usa a cor passada ou um cinza claro padrão
          fillColor: fillColor ?? Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
