import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canil_management_app/providers/theme_provider.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildTextField("Nome", nameController, Icons.person),
                _buildTextField("CPF", cpfController, Icons.assignment_ind),
                _buildTextField("Telefone", phoneController, Icons.phone),
                _buildTextField("E-mail", emailController, Icons.email),
                _buildTextField("Senha", passwordController, Icons.lock, isPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  ),
                  child: Text("Cadastrar", style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: label == "CPF" ? TextInputType.number : TextInputType.text,
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



