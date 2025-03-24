import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/animal_model.dart';

class ApiService {
  final String baseUrl = 'https://sua-api.com';

  Future<List<Future<Animal>>> getAnimals() async {
    final response = await http.get(Uri.parse('$baseUrl/animals'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((animal) => Animal.fromMap(animal)).toList();
    } else {
      throw Exception('Falha ao carregar animais');
    }
  }

  Future<void> addAnimal(Animal animal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animals'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(animal.toMap()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao adicionar animal');
    }
  }
}