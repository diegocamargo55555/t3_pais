import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3_pais/view/components/my_button.dart';
import 'package:t3_pais/view/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (mounted) Navigator.pop(context);
        if (mounted) Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showErrorMessage("As senhas não conferem!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900],
          title: Center(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Image.asset('assets/imgs/onu_logo.png', height: 300),
                const SizedBox(height: 25),

                Text(
                  'Crie sua conta',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  fillColor: Colors.blue.shade100,
                ),

                const SizedBox(height: 10),

                MyTextfield(
                  controller: passwordController,
                  hintText: 'Senha',
                  obscureText: true,
                  fillColor: Colors.blue.shade100,
                ),

                const SizedBox(height: 10),

                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: 'Confirme a Senha',
                  obscureText: true,
                  fillColor: Colors.blue.shade100,
                ),

                const SizedBox(height: 25),

                MyButton(
                  text: "Cadastrar",
                  onTap: signUserUp,
                  color: Colors.blue[900],
                ),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta?',
                      style: TextStyle(color: Colors.blue[800]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Entre agora',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
