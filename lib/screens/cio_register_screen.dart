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

  /// 🔥 **Validação para evitar cadastro duplicado de cio no mesmo ciclo**
  bool _canRegisterCio(BuildContext context) {
    final cioProvider = Provider.of<CioProvider>(context, listen: false);

    if (selectedPet == null || cioDate == null) return false;

    DateTime? lastCioDate = cioProvider.getLastCioDate(selectedPet!.id);

    if (lastCioDate != null) {
      DateTime nextValidCioDate = lastCioDate.add(Duration(days: 180));

      if (cioDate!.isBefore(nextValidCioDate)) {
        // Bloqueia o cadastro se a data for menor que o próximo ciclo permitido
        _showErrorDialog(context, "Esta cadela já tem um cio registrado neste ciclo.\nPróximo cio permitido após ${DateFormat('dd/MM/yyyy').format(nextValidCioDate)}");
        return false;
      }
    }
    return true;
  }

  /// 🔥 **Exibe um diálogo de erro quando o cio não pode ser cadastrado**
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cadastro Bloqueado"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
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
    final cios = cioProvider.cios;

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
              onPressed: () {
                if (_canRegisterCio(context)) {
                  if (selectedPet != null && cioDate != null) {
                    Provider.of<CioProvider>(context, listen: false).addCio(selectedPet!.id, cioDate!);
                    _showReturnDialog(context);
                  }
                }
              },
              child: Text('Salvar'),
            ),
            SizedBox(height: 24),

            /// 🔥 **Lista de cios cadastrados**
            Expanded(
              child: ListView(
                children: cios.map((cio) => _buildCioCard(cio, petProvider)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 **Cria um card para exibir os períodos de cio cadastrados**
  Widget _buildCioCard(Cio cio, PetProvider petProvider) {
    Pet? pet = petProvider.getPetById(cio.petId);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.pink[100], // Estilo de post-it
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red[300],
          child: Icon(Icons.female, color: Colors.white),
        ),
        title: Text(
          pet != null ? pet.name : "Desconhecido",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Raça: ${pet?.breed ?? 'Desconhecida'}\n"
          "Último Cio: ${DateFormat('dd/MM/yyyy').format(cio.cioDate)}\n"
          "Próximo Cio: ${DateFormat('dd/MM/yyyy').format(cio.nextCioDate)}",
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
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
    final cioProvider = Provider.of<CioProvider>(context);
    final femalePets = petProvider.pets.where((pet) => pet.gender == 'Fêmea').toList();
    final cios = cioProvider.cios; // Obtém todos os cios cadastrados

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
            SizedBox(height: 24),

            /// 🔥 **Post-its para exibir os períodos de cio cadastrados**
            Expanded(
              child: ListView(
                children: cios.map((cio) => _buildCioCard(cio, petProvider)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 **Cria um card tipo post-it para exibir os períodos de cio**
  Widget _buildCioCard(Cio cio, PetProvider petProvider) {
    Pet? pet = petProvider.getPetById(cio.petId);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.pink[100], // Cor de post-it para diferenciar
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red[300],
          child: Icon(Icons.female, color: Colors.white),
        ),
        title: Text(
          pet != null ? pet.name : "Desconhecido",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Raça: ${pet?.breed ?? 'Desconhecida'}\n"
          "Último Cio: ${DateFormat('dd/MM/yyyy').format(cio.cioDate)}\n"
          "Próximo Cio: ${DateFormat('dd/MM/yyyy').format(cio.nextCioDate)}",
        ),
      ),
    );
  }
}

*/
