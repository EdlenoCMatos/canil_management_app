import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canil_management_app/providers/theme_provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Bem-vindo ao Manduc Pet"),
        actions: [
          // Botão para alternar entre modo claro e escuro
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // 📌 Banner no topo
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/banner.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 20),

          // 📌 Logo arredondada
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/logo.png'),
            backgroundColor: Colors.grey[300],
          ),

          SizedBox(height: 10),

          // 📌 Nome do Aplicativo com fonte personalizada
          Text(
            "Manduc Pet",
            style: TextStyle(
              fontSize: 32,
              fontFamily: "Pacifico",
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          SizedBox(height: 30),

          // 📌 Botões de Login e Cadastro
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildButton(context, "Login", Colors.blueAccent, LoginScreen()),
                SizedBox(height: 20),
                _buildButton(context, "Cadastrar", Colors.green, RegisterScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        backgroundColor: color,
      ),
      child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}



