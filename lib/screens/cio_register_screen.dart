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
  Pet? selectedPet;
  DateTime? cioDate;
  String? nextCioDate;
  bool canRegister = true;

  void _calculateNextCio(BuildContext context) {
    if (cioDate != null && selectedPet != null) {
      final cioProvider = Provider.of<CioProvider>(context, listen: false);
      DateTime? lastCioDate = cioProvider.getLastCioDate(selectedPet!.id);

      if (lastCioDate == null || cioDate!.isAfter(lastCioDate)) {
        DateTime nextDate = cioDate!.add(Duration(days: 180));
        setState(() {
          nextCioDate = DateFormat('dd/MM/yyyy').format(nextDate);
          canRegister = true;
        });
      } else {
        setState(() {
          nextCioDate = DateFormat('dd/MM/yyyy').format(lastCioDate.add(Duration(days: 180)));
          canRegister = false;
        });
      }
    }
  }

  void _showReturnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Período do Cio Salvo"),
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
    final cioProvider = Provider.of<CioProvider>(context);
    final femalePets = petProvider.pets.where((pet) => pet.gender == 'Fêmea').toList();

    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Período do Cio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Pet>(
              decoration: InputDecoration(labelText: 'Selecione a cadela'),
              items: femalePets.map((pet) {
                return DropdownMenuItem<Pet>(
                  value: pet,
                  child: Text("${pet.name} - ${pet.breed}"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPet = value;
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
                    _calculateNextCio(context);
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
                canRegister
                    ? "Próximo cio previsto: $nextCioDate"
                    : "Cadastro bloqueado até: $nextCioDate",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: canRegister ? Colors.green : Colors.red,
                ),
              ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: canRegister
                  ? () {
                      if (selectedPet != null && cioDate != null) {
                        cioProvider.addCio(selectedPet!.id, cioDate!);
                        _showReturnDialog(context);
                      }
                    }
                  : null,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
