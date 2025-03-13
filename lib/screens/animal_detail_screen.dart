import 'package:flutter/material.dart';
import '../models/animal_model.dart';

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;

  AnimalDetailScreen({required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(animal.name)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${animal.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Espécie: ${animal.species}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
