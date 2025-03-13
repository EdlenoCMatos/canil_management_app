import 'package:flutter/material.dart';

class AddAnimalScreen extends StatefulWidget {
  @override
  _AddAnimalScreenState createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Animal')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Animal'),
            ),
            TextField(
              controller: _speciesController,
              decoration: InputDecoration(labelText: 'Espécie'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode salvar os dados no banco de dados
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
