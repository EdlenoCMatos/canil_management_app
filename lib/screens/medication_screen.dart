import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/medication_provider.dart';
import 'package:intl/intl.dart';

class MedicationScreen extends StatefulWidget {
  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  Map<String, dynamic>? selectedMedication;
  DateTime? applicationDate;
  String? nextApplicationDate;
  bool canRegister = false;

  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  Pet? selectedPet;

  void _calculateNextApplication(BuildContext context) {
    if (selectedMedication != null && applicationDate != null) {
      final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
      DateTime? lastNextApplication = medicationProvider.getNextApplicationDate(selectedMedication!['name']);

      if (lastNextApplication == null || applicationDate!.isAfter(lastNextApplication)) {
        int intervalDays = selectedMedication!['interval'];
        DateTime nextApplication = applicationDate!.add(Duration(days: intervalDays));
        setState(() {
          nextApplicationDate = DateFormat('dd/MM/yyyy').format(nextApplication);
          canRegister = true;
        });
      } else {
        setState(() {
          nextApplicationDate = DateFormat('dd/MM/yyyy').format(lastNextApplication);
          canRegister = false;
        });
      }
    }
  }

  void _showReturnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Medicamento Salvo"),
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
    final medicationProvider = Provider.of<MedicationProvider>(context);
    final medications = medicationProvider.medications;
    final applied = medicationProvider.appliedMedications;
    final pending = medicationProvider.pendingMedications;
    final overdue = medicationProvider.overdueMedications;

    return Scaffold(
      appBar: AppBar(title: Text('Gerenciar Medicamentos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Pet>(
              decoration: InputDecoration(labelText: 'Selecione o Pet'),
              items: petProvider.pets.map((Pet pet) {
                return DropdownMenuItem<Pet>(
                  value: pet,
                  child: Text(pet.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPet = value;
                });
              },
            ),
            SizedBox(height: 16),

            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: InputDecoration(labelText: 'Selecione o Medicamento'),
              items: medications.map((med) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: med,
                  child: Text(med['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMedication = value;
                });
              },
            ),
            SizedBox(height: 16),
            
            TextFormField(
              decoration: InputDecoration(labelText: 'Fabricante'),
              controller: manufacturerController,
            ),
            SizedBox(height: 16),

            TextFormField(
              decoration: InputDecoration(labelText: 'Lote'),
              controller: batchController,
            ),
            SizedBox(height: 16),

            TextFormField(
              decoration: InputDecoration(labelText: 'Data de Aplicação'),
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
                    applicationDate = pickedDate;
                    _calculateNextApplication(context);
                  });
                }
              },
              controller: TextEditingController(
                text: applicationDate != null ? DateFormat('dd/MM/yyyy').format(applicationDate!) : '',
              ),
            ),
            SizedBox(height: 16),

            if (nextApplicationDate != null)
              Text(
                canRegister
                    ? "Próxima aplicação em: $nextApplicationDate"
                    : "Você só pode cadastrar esse medicamento após: $nextApplicationDate",
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
                      if (selectedMedication != null && applicationDate != null) {
                        medicationProvider.addMedication(
                          selectedMedication!['name'],
                          applicationDate!,
                          manufacturer: manufacturerController.text,
                          batch: batchController.text,
                        );
                        _showReturnDialog(context);
                      }
                    }
                  : null,
              child: Text('Salvar'),
            ),

            SizedBox(height: 24),

            Expanded(
              child: ListView(
                children: [
                  _buildMedicationSection("✅ Aplicados", applied, Colors.green[200]!),
                  _buildMedicationSection("⏳ Pendentes", pending, Colors.yellow[200]!),
                  _buildMedicationSection("⚠️ Atrasados", overdue, Colors.red[200]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationSection(String title, List<Map<String, dynamic>> medications, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: medications.map((med) => _buildMedicationCard(med, color)).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMedicationCard(Map<String, dynamic> med, Color color) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(med['name'], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text("Fabricante: ${med['manufacturer']}"),
          Text("Lote: ${med['batch']}"),
          Text("Aplicado: ${DateFormat('dd/MM/yyyy').format(med['date'])}"),
          Text("Próxima: ${DateFormat('dd/MM/yyyy').format(med['nextDate'])}"),
        ],
      ),
    );
  }
}
