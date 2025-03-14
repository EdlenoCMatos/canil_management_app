import 'package:flutter/material.dart';

class Pet {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final String color;
  final DateTime birthDate;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.color,
    required this.birthDate,
  });
}

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  void addPet(String name, String breed, String gender, String color, DateTime birthDate) {
    final newPet = Pet(
      id: DateTime.now().toString(),
      name: name,
      breed: breed,
      gender: gender,
      color: color,
      birthDate: birthDate,
    );

    _pets.add(newPet);
    notifyListeners();
  }

  /// 🔥 **Correção aplicada**
  Pet? getPetById(String id) {
    return _pets.firstWhere((pet) => pet.id == id, orElse: () => null as Pet);
  }
}
