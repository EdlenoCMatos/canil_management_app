import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import 'package:intl/intl.dart';

class PetRegisterScreen extends StatefulWidget {
  @override
  _PetRegisterScreenState createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends State<PetRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String gender = "Macho";
  String? selectedBreed;
  String? selectedColor;
  DateTime? birthDate;

  /// 📌 Lista com todas as raças de cães reconhecidas pela cinofilia mundial
  final List<String> dogBreeds = [
    "Labrador Retriever", "Golden Retriever", "Pastor Alemão", "Bulldog Francês", "Poodle", "Rottweiler", "Beagle",
    "Dachshund", "Shih Tzu", "Border Collie", "Chow Chow", "Doberman", "Akita", "Schnauzer", "Pit Bull", "Chihuahua",
    "Maltês", "Pug", "Spitz Alemão", "Boxer", "Lhasa Apso", "Husky Siberiano", "Yorkshire Terrier",
    "Cocker Spaniel", "Setter Irlandês", "Dogue Alemão", "Fox Terrier", "São Bernardo", "Basset Hound",
    "Weimaraner", "Whippet", "Samoyed", "Bulldog Inglês", "Airedale Terrier", "Cavalier King Charles Spaniel"
  ];

  /// 📌 Lista de cores reconhecidas na cinofilia mundial
  final List<String> dogColors = [
    "Preto", "Branco", "Marrom", "Caramelo", "Dourado", "Cinzento", "Tricolor", "Bicolor", "Rajado",
    "Tigrado", "Merle Azul", "Merle Vermelho", "Sable", "Creme", "Vermelho", "Chocolate", "Azul", "Cinza",
    "Bege", "Prata", "Champagne"
  ];

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        birthDate = pickedDate;
        birthDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  void _showReturnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pet Cadastrado"),
        content: Text("Deseja voltar ao menu principal?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Fica na tela
            child: Text("Permanecer"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              Navigator.pop(context); // Volta para o menu principal
            },
            child: Text("Voltar ao Menu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cadastro do Pet")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nome do Pet"),
            ),

            /// 📌 Campo para selecionar a raça do pet
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Raça"),
              value: selectedBreed,
              items: dogBreeds.map((String breed) {
                return DropdownMenuItem(value: breed, child: Text(breed));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBreed = value;
                });
              },
            ),

            /// 📌 Campo para selecionar a cor do pet
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Cor"),
              value: selectedColor,
              items: dogColors.map((String color) {
                return DropdownMenuItem(value: color, child: Text(color));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedColor = value;
                });
              },
            ),

            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(labelText: "Sexo"),
              items: ["Macho", "Fêmea"].map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  gender = newValue!;
                });
              },
            ),

            TextField(
              controller: birthDateController,
              decoration: InputDecoration(
                labelText: "Data de Nascimento",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(context),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    selectedBreed != null &&
                    selectedColor != null &&
                    birthDate != null) {
                  petProvider.addPet(
                    nameController.text,
                    selectedBreed!,
                    gender,
                    selectedColor!,
                    birthDate!,
                  );

                  nameController.clear();
                  birthDateController.clear();
                  setState(() {
                    gender = "Macho";
                    selectedBreed = null;
                    selectedColor = null;
                    birthDate = null;
                  });

                  _showReturnDialog(context); // 🔥 Chama o diálogo após salvar o pet
                }
              },
              child: Text("Salvar Pet"),
            ),

            SizedBox(height: 24),

            /// 📌 Exibe os pets cadastrados em formato de "post-it"
            Expanded(
              child: ListView(
                children: petProvider.pets.map((pet) => _buildPetCard(pet)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 **Função para calcular a idade do pet**
  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);

    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    final days = (difference.inDays % 30);

    if (years > 0) {
      return "$years anos, $months meses e $days dias";
    } else if (months > 0) {
      return "$months meses e $days dias";
    } else {
      return "$days dias";
    }
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.yellow[200], // Post-it style
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.pets, color: Colors.black),
        ),
        title: Text(
          pet.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Raça: ${pet.breed}\n"
          "Cor: ${pet.color}\n"
          "Sexo: ${pet.gender}\n"
          "Nascimento: ${DateFormat('dd/MM/yyyy').format(pet.birthDate)}\n"
          "Idade: ${_calculateAge(pet.birthDate)}",
        ),
      ),
    );
  }
}
