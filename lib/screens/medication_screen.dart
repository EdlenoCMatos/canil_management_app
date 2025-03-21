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
  Pet? filterPet;

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
            onPressed: () => Navigator.pop(context),
            child: Text("Permanecer"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
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
    final applied = medicationProvider.appliedMedications.where((m) => filterPet == null || m['petId'] == filterPet!.id).toList();
    final pending = medicationProvider.pendingMedications.where((m) => filterPet == null || m['petId'] == filterPet!.id).toList();
    final overdue = medicationProvider.overdueMedications.where((m) => filterPet == null || m['petId'] == filterPet!.id).toList();

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
              onPressed: canRegister && selectedPet != null
                  ? () {
                      if (selectedMedication != null && applicationDate != null && selectedPet != null) {
                        medicationProvider.addMedication(
                          selectedMedication!['name'],
                          applicationDate!,
                          petId: selectedPet!.id,
                          petName: selectedPet!.name,
                          manufacturer: manufacturerController.text,
                          batch: batchController.text,
                        );
                        _showReturnDialog(context);
                      }
                    }
                  : null,
              child: Text('Salvar'),
            ),
            Divider(height: 32),
            DropdownButtonFormField<Pet>(
              value: filterPet,
              hint: Text("Filtrar por Pet"),
              decoration: InputDecoration(labelText: 'Filtrar post-its por pet'),
              items: [
                DropdownMenuItem<Pet>(value: null, child: Text("Todos")),
                ...petProvider.pets.map((Pet pet) {
                  return DropdownMenuItem<Pet>(
                    value: pet,
                    child: Text(pet.name),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  filterPet = value;
                });
              },
            ),
            SizedBox(height: 16),
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
      width: 180,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              med['name'],
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SizedBox(height: 6),
          if (med['petName'] != null)
            Text("🐾 Pet: ${med['petName']}", style: TextStyle(fontSize: 14)),
          Text("🏭 Fabricante: ${med['manufacturer']}", style: TextStyle(fontSize: 13)),
          Text("🔢 Lote: ${med['batch']}", style: TextStyle(fontSize: 13)),
          Text("📅 Aplicado: ${DateFormat('dd/MM/yyyy').format(med['date'])}", style: TextStyle(fontSize: 13)),
          Text("📆 Próxima: ${DateFormat('dd/MM/yyyy').format(med['nextDate'])}", style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}




/*import 'package:flutter/material.dart';
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
      int intervalDays = selectedMedication!['interval'];
      DateTime nextApplication = applicationDate!.add(Duration(days: intervalDays));

      setState(() {
        nextApplicationDate = DateFormat('dd/MM/yyyy').format(nextApplication);
        canRegister = true;
      });
    }
  }

  void _clearFields() {
    setState(() {
      selectedPet = null;
      selectedMedication = null;
      applicationDate = null;
      nextApplicationDate = null;
      canRegister = false;
      manufacturerController.clear();
      batchController.clear();
    });
  }

  void _showReturnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Medicamento Salvo"),
        content: Text("Deseja voltar ao menu principal?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Permanecer"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Voltar ao Menu"),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
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
              value: selectedPet,
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
              value: selectedMedication,
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
                      if (selectedPet == null || selectedMedication == null || applicationDate == null ||
                          manufacturerController.text.isEmpty || batchController.text.isEmpty) {
                        _showSnackBar("Preencha todos os campos antes de salvar.");
                        return;
                      }

                      medicationProvider.addMedication(
                        selectedMedication!['name'],
                        applicationDate!,
                        manufacturer: manufacturerController.text,
                        batch: batchController.text,
                      );

                      _showSnackBar("Medicamento cadastrado com sucesso!");
                      _clearFields();
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
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  med['name'],
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.medication, size: 18),
            ],
          ),
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
*/

