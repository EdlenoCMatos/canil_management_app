import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canil_management_app/providers/theme_provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),

            // 📌 Exibição da Logo
            Image.asset('assets/logo.png', height: 100, width: 100),

            SizedBox(height: 20),

            // 📌 Título do App
            Text(
              "Manduc Pet",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),

            SizedBox(height: 20),

            // 📌 Campos de Entrada
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildTextField(context, "CPF", cpfController, Icons.assignment_ind),
                  _buildTextField(context, "Senha", passwordController, Icons.lock, isPassword: true),
                ],
              ),
            ),

            SizedBox(height: 10),

            // 📌 Botão de Login
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
              child: Text("Entrar", style: TextStyle(fontSize: 18)),
            ),

            SizedBox(height: 20),

            // 📌 Link para Cadastro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Não tem conta?", style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // ✅ Rota corrigida
                  },
                  child: Text(
                    "Cadastre-se",
                    style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 📌 Método para Criar os Campos de Entrada
  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: label == "CPF" ? TextInputType.number : TextInputType.text, // 📌 CPF aceita apenas números
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
        ),
      ),
    );
  }
}
