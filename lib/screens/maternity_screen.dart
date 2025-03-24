import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';

class MaternityScreen extends StatefulWidget {
  @override
  _MaternityScreenState createState() => _MaternityScreenState();
}

class _MaternityScreenState extends State<MaternityScreen> {
  final TextEditingController crossingDateController = TextEditingController();
  final TextEditingController puppyNameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  String gender = "Macho";
  Pet? selectedMother;
  Pet? selectedFather;
  DateTime? crossingDate;
  DateTime? estimatedBirthDate;

  List<Map<String, dynamic>> puppies = [];
  List<String> suggestedColors = [];

  void _pickCrossingDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        crossingDate = picked;
        estimatedBirthDate = picked.add(Duration(days: 63));
      });
      crossingDateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _updateBreedAndColorSuggestions() {
    String? breed;
    List<String> colors = [];

    if (selectedMother != null && selectedFather != null) {
      breed = "${selectedMother!.breed} x ${selectedFather!.breed}";
      colors = [selectedMother!.color, selectedFather!.color];
    } else if (selectedMother != null) {
      breed = selectedMother!.breed;
      colors = [selectedMother!.color];
    } else if (selectedFather != null) {
      breed = selectedFather!.breed;
      colors = [selectedFather!.color];
    }

    setState(() {
      if (breed != null) {
        breedController.text = breed;
      }
      suggestedColors = colors.toSet().toList();
    });
  }

  void _registerPuppy() {
    if (puppyNameController.text.isNotEmpty && breedController.text.isNotEmpty && colorController.text.isNotEmpty && estimatedBirthDate != null) {
      final birthDate = estimatedBirthDate!;
      final vaccine = birthDate.add(Duration(days: 45));
      final vermifuge = birthDate.add(Duration(days: 30));

      setState(() {
        puppies.add({
          'name': puppyNameController.text,
          'breed': breedController.text,
          'color': colorController.text,
          'gender': gender,
          'birthDate': birthDate,
          'vaccine': vaccine,
          'vermifuge': vermifuge,
          'mother': selectedMother?.name ?? 'Desconhecida',
          'father': selectedFather?.name ?? 'Desconhecido',
        });

        puppyNameController.clear();
        breedController.clear();
        colorController.clear();
        gender = "Macho";
      });
    }
  }

  Widget _buildPuppyCard(Map<String, dynamic> puppy) {
    final today = DateTime.now();
    final isVaccineOverdue = puppy['vaccine'].isBefore(today);
    final isVermifugeOverdue = puppy['vermifuge'].isBefore(today);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🐶 ${puppy['name']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text("Raça: ${puppy['breed']}"),
          Text("Cor: ${puppy['color']}, Sexo: ${puppy['gender']}"),
          Text("Nascimento: ${DateFormat('dd/MM/yyyy').format(puppy['birthDate'])}"),
          Text("Mãe: ${puppy['mother']}, Pai: ${puppy['father']}"),
          SizedBox(height: 8),
          Text(
            isVaccineOverdue
              ? "⚠️ Vacina atrasada: ${DateFormat('dd/MM/yyyy').format(puppy['vaccine'])}"
              : "💉 Vacina: ${DateFormat('dd/MM/yyyy').format(puppy['vaccine'])}",
            style: TextStyle(color: isVaccineOverdue ? Colors.red : Colors.green),
          ),
          Text(
            isVermifugeOverdue
              ? "⚠️ Vermífugo atrasado: ${DateFormat('dd/MM/yyyy').format(puppy['vermifuge'])}"
              : "🧪 Vermífugo: ${DateFormat('dd/MM/yyyy').format(puppy['vermifuge'])}",
            style: TextStyle(color: isVermifugeOverdue ? Colors.red : Colors.green),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    final allColors = [
      ...suggestedColors,
      "Preto", "Branco", "Marrom", "Caramelo", "Dourado", "Cinzento", "Tricolor", "Bicolor", "Rajado", "Tigrado",
      "Merle Azul", "Merle Vermelho", "Sable", "Creme", "Vermelho", "Chocolate", "Azul", "Cinza", "Bege", "Prata", "Champagne"
    ].toSet().toList();

    return Scaffold(
      appBar: AppBar(title: Text("Maternidade")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📅 Data do Cruzamento", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: crossingDateController,
              readOnly: true,
              onTap: _pickCrossingDate,
              decoration: InputDecoration(
                hintText: "Escolher data",
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 8),
            if (estimatedBirthDate != null)
              Text("🍼 Nascimento estimado: ${DateFormat('dd/MM/yyyy').format(estimatedBirthDate!)}", style: TextStyle(color: Colors.blue)),
            Divider(height: 24),
            Text("🐾 Cadastro de Filhotes", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<Pet>(
              decoration: InputDecoration(labelText: "Mãe"),
              value: selectedMother,
              items: petProvider.pets.map((pet) => DropdownMenuItem(value: pet, child: Text(pet.name))).toList(),
              onChanged: (value) => setState(() {
                selectedMother = value;
                _updateBreedAndColorSuggestions();
              }),
            ),
            DropdownButtonFormField<Pet>(
              decoration: InputDecoration(labelText: "Pai"),
              value: selectedFather,
              items: petProvider.pets.map((pet) => DropdownMenuItem(value: pet, child: Text(pet.name))).toList(),
              onChanged: (value) => setState(() {
                selectedFather = value;
                _updateBreedAndColorSuggestions();
              }),
            ),
            TextField(controller: puppyNameController, decoration: InputDecoration(labelText: "Nome do Filhote")),
            TextField(controller: breedController, decoration: InputDecoration(labelText: "Raça")),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Cor"),
              value: allColors.contains(colorController.text) ? colorController.text : null,
              items: allColors.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (value) => setState(() => colorController.text = value ?? ""),
            ),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(labelText: "Sexo"),
              items: ["Macho", "Fêmea"].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => gender = value!),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _registerPuppy,
              child: Text("Cadastrar Filhote"),
            ),
            Divider(height: 32),
            Text("📋 Filhotes Cadastrados", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...puppies.map(_buildPuppyCard).toList(),
          ],
        ),
      ),
    );
  }
}
