import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _medications = [
    {'name': 'Vacina V8', 'interval': 28},
    {'name': 'Vacina V10', 'interval': 28},
    {'name': 'Vacina Antirrábica', 'interval': 365},
    {'name': 'Vermífugo Filhote', 'interval': 15},
    {'name': 'Vermífugo Adulto', 'interval': 90},
  ];

  final List<Map<String, dynamic>> _appliedMedications = [];

  List<Map<String, dynamic>> get medications => _medications;
  List<Map<String, dynamic>> get appliedMedications => _appliedMedications;

  List<Map<String, dynamic>> get pendingMedications {
    return _appliedMedications.where((med) => med['status'] == 'pending').toList();
  }

  List<Map<String, dynamic>> get overdueMedications {
    return _appliedMedications.where((med) => med['status'] == 'overdue').toList();
  }

  void addMedication(
    String name,
    DateTime date, {
    required String petId,
    required String petName,
    required String manufacturer,
    required String batch,
  }) {
    final interval = _getIntervalForMedication(name);
    final nextDate = date.add(Duration(days: interval));

    _appliedMedications.add({
      'name': name,
      'date': date,
      'nextDate': nextDate,
      'manufacturer': manufacturer,
      'batch': batch,
      'petId': petId,
      'petName': petName,
    });

    notifyListeners();
  }

  int _getIntervalForMedication(String name) {
    final med = _medications.firstWhere(
      (m) => m['name'] == name,
      orElse: () => {'interval': 30},
    );
    return med['interval'];
  }

  DateTime? getNextApplicationDate(String name, [String? petId]) {
    var meds = _appliedMedications.where((med) => med['name'] == name && (petId == null || med['petId'] == petId)).toList();
    if (meds.isNotEmpty) {
      meds.sort((a, b) => b['nextDate'].compareTo(a['nextDate']));
      return meds.first['nextDate'];
    }
    return null;
  }
}
