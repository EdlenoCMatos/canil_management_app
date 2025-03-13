import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela Inicial")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              title: Text("Cadastrar Pet"),
              onTap: () {
                Navigator.pushNamed(context, '/pet-register');
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_services),
              title: Text("Gerenciar Medicamentos"),
              onTap: () {
                Navigator.pushNamed(context, '/medicamentos'); // ✅ Corrigida a rota para Medicamentos
              },
            ),
            ListTile(
              leading: Icon(Icons.female),
              title: Text("Cadastrar Período do Cio"),
              onTap: () {
                Navigator.pushNamed(context, '/cio-register');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Perfil do Usuário"),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sair"),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bem-vindo à tela inicial!", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/medicamentos'); // ✅ Mantendo apenas um botão para Medicamentos
              },
              child: Text("Gerenciar Medicamentos"),
            ),
          ],
        ),
      ),
    );
  }
}
