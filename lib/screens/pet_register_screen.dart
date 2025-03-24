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
  final TextEditingController searchController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String gender = "Macho";
  String? selectedBreed;
  String? selectedColor;
  DateTime? birthDate;
  Pet? editingPet;
  Pet? filterPet;
  String searchQuery = "";

  final List<String> dogBreeds = [
    "Labrador Retriever", "Golden Retriever", "Pastor Alemão", "Bulldog Francês", "Poodle", "Rottweiler", "Beagle",
    "Dachshund", "Shih Tzu", "Border Collie", "Chow Chow", "Doberman", "Akita", "Schnauzer", "Pit Bull", "Chihuahua",
    "Maltês", "Pug", "Spitz Alemão", "Boxer", "Lhasa Apso", "Husky Siberiano", "Yorkshire Terrier",
    "Cocker Spaniel", "Setter Irlandês", "Dogue Alemão", "Fox Terrier", "São Bernardo", "Basset Hound",
    "Weimaraner", "Whippet", "Samoyed", "Bulldog Inglês", "Airedale Terrier", "Cavalier King Charles Spaniel"
  ];

  final List<String> dogColors = [
    "Preto", "Branco", "Marrom", "Caramelo", "Dourado", "Cinzento", "Tricolor", "Bicolor", "Rajado", "BlackTan",
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

  void _loadPetForEditing(Pet pet) {
    setState(() {
      editingPet = pet;
      nameController.text = pet.name;
      birthDateController.text = DateFormat('dd/MM/yyyy').format(pet.birthDate);
      selectedBreed = pet.breed;
      selectedColor = pet.color;
      gender = pet.gender;
      birthDate = pet.birthDate;
    });
  }

  Future<void> _updatePet(BuildContext context) async {
    if (editingPet != null &&
        nameController.text.isNotEmpty &&
        selectedBreed != null &&
        selectedColor != null &&
        birthDate != null) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);

      await petProvider.updatePet(
        editingPet!.id,
        nameController.text,
        selectedBreed!,
        gender,
        selectedColor!,
        birthDate!,
      );

      setState(() {
        editingPet = null;
        nameController.clear();
        birthDateController.clear();
        selectedBreed = null;
        selectedColor = null;
        birthDate = null;
      });

      _showReturnDialog(context, "Pet atualizado com sucesso!");
    }
  }

  void _showReturnDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sucesso"),
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
    final pets = petProvider.pets;

    final filteredPets = pets.where((pet) {
      final matchesFilter = filterPet == null || pet.id == filterPet!.id;
      final matchesSearch = searchQuery.isEmpty ||
        pet.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        pet.breed.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Cadastro do Pet")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nome do Pet",
                helperText: "Digite o nome completo do animal",
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Raça",
                helperText: "Selecione a raça do animal",
              ),
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Cor",
                helperText: "Selecione a cor predominante",
              ),
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
              decoration: InputDecoration(
                labelText: "Sexo",
                helperText: "Informe o sexo do animal",
              ),
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
                helperText: "Toque no ícone para escolher a data",
              ),
              readOnly: true,
              onTap: () => _pickDate(context),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedBreed != null &&
                    selectedColor != null &&
                    birthDate != null) {

                  final petProvider = Provider.of<PetProvider>(context, listen: false);
                  final existing = petProvider.pets.any((pet) =>
                    pet.name.toLowerCase() == nameController.text.toLowerCase() &&
                    (editingPet == null || editingPet!.id != pet.id));

                  if (existing) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Já existe um pet com esse nome.")),
                    );
                    return;
                  }

                  if (editingPet == null) {
                    await petProvider.addPet(
                      nameController.text,
                      selectedBreed!,
                      gender,
                      selectedColor!,
                      birthDate!,
                    );
                    _showReturnDialog(context, "Pet cadastrado com sucesso!");
                  } else {
                    await _updatePet(context);
                  }

                  setState(() {
                    nameController.clear();
                    birthDateController.clear();
                    selectedBreed = null;
                    selectedColor = null;
                    birthDate = null;
                    editingPet = null;
                  });
                }
              },
              child: Text(editingPet == null ? "Salvar Pet" : "Atualizar Pet"),
            ),

            SizedBox(height: 16),

            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Buscar por nome ou raça",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            SizedBox(height: 16),

            DropdownButtonFormField<Pet>(
              decoration: InputDecoration(labelText: "Filtrar por Pet"),
              value: filterPet,
              items: [
                DropdownMenuItem<Pet>(value: null, child: Text("Todos")),
                ...petProvider.pets.map((pet) => DropdownMenuItem<Pet>(value: pet, child: Text(pet.name))),
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
                children: filteredPets.map((pet) => _buildPetCard(pet, context)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(Pet pet, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.pets, color: Colors.black),
        ),
        title: Text(pet.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Raça: ${pet.breed}\n"
          "Cor: ${pet.color}\n"
          "Sexo: ${pet.gender}\n"
          "Nascimento: ${DateFormat('dd/MM/yyyy').format(pet.birthDate)}",
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _loadPetForEditing(pet),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirmar exclusão"),
                    content: Text("Tem certeza que deseja excluir o pet '${pet.name}'?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Excluir"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  Provider.of<PetProvider>(context, listen: false).deletePet(pet.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


/*
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
  Pet? editingPet; // 🔥 Armazena o pet que está sendo editado
  Pet? filterPet; // 🔥 Filtro por pet

  final List<String> dogBreeds = [
    "Labrador Retriever", "Golden Retriever", "Pastor Alemão", "Bulldog Francês", "Poodle", "Rottweiler", "Beagle",
    "Dachshund", "Shih Tzu", "Border Collie", "Chow Chow", "Doberman", "Akita", "Schnauzer", "Pit Bull", "Chihuahua",
    "Maltês", "Pug", "Spitz Alemão", "Boxer", "Lhasa Apso", "Husky Siberiano", "Yorkshire Terrier",
    "Cocker Spaniel", "Setter Irlandês", "Dogue Alemão", "Fox Terrier", "São Bernardo", "Basset Hound",
    "Weimaraner", "Whippet", "Samoyed", "Bulldog Inglês", "Airedale Terrier", "Cavalier King Charles Spaniel"
  ];

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

  void _loadPetForEditing(Pet pet) {
    setState(() {
      editingPet = pet;
      nameController.text = pet.name;
      birthDateController.text = DateFormat('dd/MM/yyyy').format(pet.birthDate);
      selectedBreed = pet.breed;
      selectedColor = pet.color;
      gender = pet.gender;
      birthDate = pet.birthDate;
    });
  }

  Future<void> _updatePet(BuildContext context) async {
    if (editingPet != null &&
        nameController.text.isNotEmpty &&
        selectedBreed != null &&
        selectedColor != null &&
        birthDate != null) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);

      await petProvider.updatePet(
        editingPet!.id,
        nameController.text,
        selectedBreed!,
        gender,
        selectedColor!,
        birthDate!,
      );

      setState(() {
        editingPet = null;
        nameController.clear();
        birthDateController.clear();
        selectedBreed = null;
        selectedColor = null;
        birthDate = null;
      });

      _showReturnDialog(context, "Pet atualizado com sucesso!");
    }
  }

  void _showReturnDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sucesso"),
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
    final pets = petProvider.pets;
    final filteredPets = filterPet != null ? pets.where((pet) => pet.id == filterPet!.id).toList() : pets;

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
              onPressed: editingPet == null
                  ? () async {
                      if (nameController.text.isNotEmpty &&
                          selectedBreed != null &&
                          selectedColor != null &&
                          birthDate != null) {
                        await petProvider.addPet(
                          nameController.text,
                          selectedBreed!,
                          gender,
                          selectedColor!,
                          birthDate!,
                        );

                        setState(() {
                          nameController.clear();
                          birthDateController.clear();
                          selectedBreed = null;
                          selectedColor = null;
                          birthDate = null;
                        });

                        _showReturnDialog(context, "Pet cadastrado com sucesso!");
                      }
                    }
                  : () => _updatePet(context),
              child: Text(editingPet == null ? "Salvar Pet" : "Atualizar Pet"),
            ),

            SizedBox(height: 16),

            DropdownButtonFormField<Pet>(
              decoration: InputDecoration(labelText: "Filtrar por Pet"),
              value: filterPet,
              items: [
                DropdownMenuItem<Pet>(value: null, child: Text("Todos")),
                ...petProvider.pets.map((pet) => DropdownMenuItem<Pet>(value: pet, child: Text(pet.name))),
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
                children: filteredPets.map((pet) => _buildPetCard(pet)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.pets, color: Colors.black),
        ),
        title: Text(pet.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Raça: ${pet.breed}\n"
          "Cor: ${pet.color}\n"
          "Sexo: ${pet.gender}\n"
          "Nascimento: ${DateFormat('dd/MM/yyyy').format(pet.birthDate)}",
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _loadPetForEditing(pet),
        ),
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';
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
  Pet? editingPet; // 🔥 Armazena o pet que está sendo editado

  final List<String> dogBreeds = [
    "Labrador Retriever", "Golden Retriever", "Pastor Alemão", "Bulldog Francês", "Poodle", "Rottweiler", "Beagle",
    "Dachshund", "Shih Tzu", "Border Collie", "Chow Chow", "Doberman", "Akita", "Schnauzer", "Pit Bull", "Chihuahua",
    "Maltês", "Pug", "Spitz Alemão", "Boxer", "Lhasa Apso", "Husky Siberiano", "Yorkshire Terrier",
    "Cocker Spaniel", "Setter Irlandês", "Dogue Alemão", "Fox Terrier", "São Bernardo", "Basset Hound",
    "Weimaraner", "Whippet", "Samoyed", "Bulldog Inglês", "Airedale Terrier", "Cavalier King Charles Spaniel"
  ];

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

  void _loadPetForEditing(Pet pet) {
    setState(() {
      editingPet = pet;
      nameController.text = pet.name;
      birthDateController.text = DateFormat('dd/MM/yyyy').format(pet.birthDate);
      selectedBreed = pet.breed;
      selectedColor = pet.color;
      gender = pet.gender;
      birthDate = pet.birthDate;
    });
  }

  /// 🔥 **Função para atualizar um pet já cadastrado**
  Future<void> _updatePet(BuildContext context) async {
    if (editingPet != null &&
        nameController.text.isNotEmpty &&
        selectedBreed != null &&
        selectedColor != null &&
        birthDate != null) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);

      await petProvider.updatePet(
        editingPet!.id,
        nameController.text,
        selectedBreed!,
        gender,
        selectedColor!,
        birthDate!,
      );

      setState(() {
        editingPet = null;
        nameController.clear();
        birthDateController.clear();
        selectedBreed = null;
        selectedColor = null;
        birthDate = null;
      });

      _showReturnDialog(context, "Pet atualizado com sucesso!");
    }
  }

  void _showReturnDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sucesso"),
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
              onPressed: editingPet == null
                  ? () async {
                      if (nameController.text.isNotEmpty &&
                          selectedBreed != null &&
                          selectedColor != null &&
                          birthDate != null) {
                        await petProvider.addPet(
                          nameController.text,
                          selectedBreed!,
                          gender,
                          selectedColor!,
                          birthDate!,
                        );

                        setState(() {
                          nameController.clear();
                          birthDateController.clear();
                          selectedBreed = null;
                          selectedColor = null;
                          birthDate = null;
                        });

                        _showReturnDialog(context, "Pet cadastrado com sucesso!");
                      }
                    }
                  : () => _updatePet(context), // 🔥 Chama a função de atualização
              child: Text(editingPet == null ? "Salvar Pet" : "Atualizar Pet"),
            ),

            SizedBox(height: 24),

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

  Widget _buildPetCard(Pet pet) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.yellow[200],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.pets, color: Colors.black),
        ),
        title: Text(pet.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Raça: ${pet.breed}\n"
          "Cor: ${pet.color}\n"
          "Sexo: ${pet.gender}\n"
          "Nascimento: ${DateFormat('dd/MM/yyyy').format(pet.birthDate)}",
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _loadPetForEditing(pet), // 🔥 Adiciona a funcionalidade de edição
        ),
      ),
    );
  }
}

*/


/*import 'package:flutter/material.dart';
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

Pet? editingPet; // 🔥 Armazena o pet que está sendo editado


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

  void _loadPetForEditing(Pet pet) {
  setState(() {
    editingPet = pet;
    nameController.text = pet.name;
    birthDateController.text = DateFormat('dd/MM/yyyy').format(pet.birthDate);
    selectedBreed = pet.breed;
    selectedColor = pet.color;
    gender = pet.gender;
    birthDate = pet.birthDate;
  });
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
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedBreed != null &&
                    selectedColor != null &&
                    birthDate != null) {
                  try {
                    await petProvider.addPet(
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

                    _showReturnDialog(context); // 🔥 Exibe o alerta após salvar

                  } catch (e) {
                    // Se houver erro, exibe um alerta
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Erro"),
                        content: Text("Erro ao cadastrar pet: $e"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
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
*/