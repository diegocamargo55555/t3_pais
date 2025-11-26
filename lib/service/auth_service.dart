import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para monitorar se o usuário está logado ou não
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login com Email e Senha
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sucesso (null significa sem erros)
    } on FirebaseAuthException catch (e) {
      return e.message; // Retorna a mensagem de erro
    }
  }

  // Cadastro com Email e Senha
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
