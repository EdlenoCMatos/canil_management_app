import 'package:flutter/material.dart';

class Cio {
  final String petId;
  final DateTime cioDate;
  final DateTime nextCioDate;

  Cio({required this.petId, required this.cioDate, required this.nextCioDate});
}

class CioProvider with ChangeNotifier {
  List<Cio> _cios = [];

  List<Cio> get cios => _cios;

  void addCio(String petId, DateTime cioDate) {
    DateTime nextCioDate = cioDate.add(Duration(days: 180)); // 6 meses para o próximo cio
    _cios.add(Cio(petId: petId, cioDate: cioDate, nextCioDate: nextCioDate));
    notifyListeners();
  }

  List<Cio> getCiosByPetId(String petId) {
    return _cios.where((cio) => cio.petId == petId).toList();
  }

  /// 📌 Método corrigido para obter a última data de cio do pet
  DateTime? getLastCioDate(String petId) {
    final ciosByPet = getCiosByPetId(petId);
    if (ciosByPet.isEmpty) return null;
    
    ciosByPet.sort((a, b) => b.cioDate.compareTo(a.cioDate)); // Ordena do mais recente para o mais antigo
    return ciosByPet.first.cioDate; // Retorna a data do último cio
  }
}
