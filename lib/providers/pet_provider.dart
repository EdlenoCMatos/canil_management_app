import 'package:flutter/material.dart';

class Pet {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final DateTime birthDate;

  Pet({required this.id, required this.name, required this.breed, required this.gender, required this.birthDate});
}

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  void addPet(Pet pet) {
    _pets.add(pet);
    notifyListeners();
  }

  Pet? getPetById(String id) {
    return _pets.firstWhere((pet) => pet.id == id, orElse: () => null as Pet);
  }
}
