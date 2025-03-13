import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/cio_provider.dart';
import 'package:intl/intl.dart';

class CioRegisterScreen extends StatefulWidget {
  @override
  _CioRegisterScreenState createState() => _CioRegisterScreenState();
}

class _CioRegisterScreenState extends State<CioRegisterScreen> {
  String? selectedPetId;
  DateTime? cioDate;
  String? nextCioDate;

  void _calculateNextCio() {
    if (cioDate != null) {
      DateTime nextDate = cioDate!.add(Duration(days: 180));
      setState(() {
        nextCioDate = DateFormat('dd/MM/yyyy').format(nextDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final cioProvider = Provider.of<CioProvider>(context);
    final femalePets = petProvider.pets.where((pet) => pet.gender == 'Fêmea').toList();

    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Período do Cio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Selecione a cadela'),
              items: femalePets.map((pet) {
                return DropdownMenuItem<String>(
                  value: pet.id,
                  child: Text("${pet.name} - ${pet.breed}"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPetId = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Data do Último Cio'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  setState(() {
                    cioDate = pickedDate;
                    _calculateNextCio();
                  });
                }
              },
              controller: TextEditingController(
                text: cioDate != null ? DateFormat('dd/MM/yyyy').format(cioDate!) : '',
              ),
            ),
            SizedBox(height: 16),
            if (nextCioDate != null)
              Text(
                "Próximo cio previsto: $nextCioDate",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedPetId != null && cioDate != null) {
                  cioProvider.addCio(selectedPetId!, cioDate!);
                  Navigator.pop(context);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CioRegisterScreen extends StatefulWidget {
  @override
  _CioRegisterScreenState createState() => _CioRegisterScreenState();
}

class _CioRegisterScreenState extends State<CioRegisterScreen> {
  final TextEditingController dateController = TextEditingController();
  String? nextCioDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar Período do Cio")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDatePickerField("Data de Início do Cio", dateController),
            
            if (nextCioDate != null)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Próximo cio previsto: $nextCioDate",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveCioData,
              child: Text("Salvar Período do Cio"),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Campo para selecionar a data
  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            nextCioDate = DateFormat('dd/MM/yyyy')
                .format(pickedDate.add(Duration(days: 180))); // Calcula o próximo cio
          });
        }
      },
    );
  }

  // 📌 Simula salvamento dos dados do cio
  void _saveCioData() {
    if (dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, selecione a data de início do cio!")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Período do cio cadastrado com sucesso!")),
    );
  }
}
*/