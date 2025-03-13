import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil do Usuário"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // 📌 Ícone de Perfil
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/logo.png'),
            ),

            SizedBox(height: 20),

            // 📌 Campos de Edição
            _buildTextField("Nome", nameController, Icons.person, enabled: _isEditing),
            _buildTextField("CPF", cpfController, Icons.assignment_ind, enabled: false),
            _buildTextField("Telefone", phoneController, Icons.phone, enabled: _isEditing),
            _buildTextField("E-mail", emailController, Icons.email, enabled: _isEditing),

            Divider(height: 40),

            Text("Alterar Senha", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            _buildTextField("Nova Senha", newPasswordController, Icons.lock, isPassword: true),
            _buildTextField("Confirmar Senha", confirmPasswordController, Icons.lock, isPassword: true),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              child: Text("Salvar Alterações"),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Método para Criar Campos de Entrada
  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool enabled = true, bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  // 📌 Método para Salvar Alterações
  void _saveChanges() {
    if (newPasswordController.text.isNotEmpty && newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("As senhas não coincidem!")));
      return;
    }

    // Simulação de salvamento dos dados
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dados atualizados com sucesso!")));

    setState(() {
      _isEditing = false;
    });
  }
}
