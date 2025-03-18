import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id, // 🔥 Incluímos o ID para armazenar corretamente no Firestore
      'name': name,
      'breed': breed,
      'gender': gender,
      'color': color,
      'birthDate': birthDate.toIso8601String(),
    };
  }

  factory Pet.fromMap(String id, Map<String, dynamic> data) {
    return Pet(
      id: id,
      name: data['name'],
      breed: data['breed'],
      gender: data['gender'],
      color: data['color'],
      birthDate: DateTime.parse(data['birthDate']),
    );
  }
}

class PetProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // 🔥 Firestore instanciado
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  /// ✅ **Adiciona um pet na lista local e no Firestore**
  Future<void> addPet(String name, String breed, String gender, String color, DateTime birthDate) async {
    final newPet = Pet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      breed: breed,
      gender: gender,
      color: color,
      birthDate: birthDate,
    );

    _pets.add(newPet);
    notifyListeners();

    // 🔥 **Agora salva no Firestore**
    try {
      await _firestore.collection('pets').doc(newPet.id).set(newPet.toMap());
      print("Pet adicionado com sucesso no Firestore!");
    } catch (e) {
      print("Erro ao adicionar pet no Firestore: $e");
    }
  }

  /// ✅ **Busca um pet pelo ID**
  Pet? getPetById(String id) {
    return _pets.firstWhere((pet) => pet.id == id, orElse: () => null as Pet);
  }

  /// ✅ **Carrega todos os pets do Firestore para a lista local**
  Future<void> fetchPets() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('pets').get();
      _pets = snapshot.docs.map((doc) => Pet.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
      notifyListeners();
    } catch (e) {
      print("Erro ao buscar pets do Firestore: $e");
    }
  }
}
