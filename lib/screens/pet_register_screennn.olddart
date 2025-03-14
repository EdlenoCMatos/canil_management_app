import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:canil_management_app/providers/theme_provider.dart';

class PetRegisterScreen extends StatefulWidget {
  @override
  _PetRegisterScreenState createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends State<PetRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  String gender = "Macho";
  DateTime? birthDate;
  String? calculatedAge;

  void _calculateAge() {
    if (birthDate == null) return;

    final today = DateTime.now();
    final difference = today.difference(birthDate!);

    final years = (difference.inDays / 365).floor();
    final remainingDaysAfterYears = difference.inDays % 365;
    final months = (remainingDaysAfterYears / 30).floor();
    final days = remainingDaysAfterYears % 30;

    setState(() {
      calculatedAge = "$years anos, $months meses e $days dias";
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro do Pet"),
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
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cadastro do Pet",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 20),

              _buildTextField("Nome do Pet", nameController, Icons.pets),
              _buildTextField("Raça", breedController, Icons.pets),
              _buildTextField("Cor", colorController, Icons.color_lens),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<String>(
                  value: gender,
                  items: ["Macho", "Fêmea"]
                      .map((String value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Sexo",
                    prefixIcon: Icon(Icons.male, color: Theme.of(context).colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
                  ),
                ),
              ),

              // Campo para Selecionar Data de Nascimento
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Data de Nascimento",
                    prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        birthDate = pickedDate;
                        _calculateAge();
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: birthDate != null ? DateFormat('dd/MM/yyyy').format(birthDate!) : '',
                  ),
                ),
              ),

              // Exibir idade calculada
              if (calculatedAge != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Idade: $calculatedAge",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),

              SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  backgroundColor: Colors.orangeAccent,
                ),
                child: Text("Salvar Pet", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
        ),
      ),
    );
  }
}
