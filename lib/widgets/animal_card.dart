import 'package:flutter/material.dart';
import '../models/animal_model.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;

  const AnimalCard({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(animal.photoUrl),
        ),
        title: Text(animal.name),
        subtitle: Text(animal.breed),
        onTap: () {
          // Navegar para a tela de detalhes
        },
      ),
    );
  }
}
