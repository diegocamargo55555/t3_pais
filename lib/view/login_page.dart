import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3_pais/view/components/my_button.dart';
import 'package:t3_pais/view/components/my_textfield.dart';
import 'package:t3_pais/view/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text,
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(title: Text("Usuário/Senha Incorretas!"));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                Image.asset('assets/imgs/onu_logo.png', width: 300),
                const SizedBox(height: 100),
                Text(
                  "Seja Bem Vindo!",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                MyTextfield(
                  controller: userNameController,
                  hintText: "Email",
                  obscureText: false,
                  fillColor: Colors.blue.shade100,
                ),

                const SizedBox(height: 15),

                MyTextfield(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                  fillColor: Colors.blue.shade100,
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Esqueceu sua senha?",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                MyButton(
                  onTap: signUserIn,
                  text: "Entrar",
                  color: Colors.blue[900],
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Não tem Cadastro?",
                      style: TextStyle(color: Colors.blue[800]),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Registre-se agora",
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
