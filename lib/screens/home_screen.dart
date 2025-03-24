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
              leading: Icon(Icons.arrow_circle_up),
              title: Text("Cadastrar Período do Cio"),
              onTap: () {
                Navigator.pushNamed(context, '/cio-register');
              },
            ),

            ListTile(
              leading: Icon(Icons.ads_click),
              title: Text("Maternidade"),
              onTap: () {
                Navigator.pushNamed(context, '/maternity'); // ✅ Corrigida a rota para Medicamentos
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
            Text("Bem-vindo ao Manduc Pet!", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            // 🟡 Espaço para banner ou propaganda
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "🔔 Sua propaganda aqui!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            // ➕ Outros conteúdos ou banners podem ser colocados aqui futuramente
          ],
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';

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
*/