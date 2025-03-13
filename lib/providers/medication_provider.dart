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

  void addMedication(String name, DateTime date, {String manufacturer = '', String batch = ''}) {
    final medication = _medications.firstWhere((med) => med['name'] == name, orElse: () => {});
    
    if (medication.isNotEmpty) {
      int intervalDays = medication['interval'];
      DateTime nextApplication = date.add(Duration(days: intervalDays));

      String status = DateTime.now().isBefore(nextApplication) ? 'pending' : 'overdue';

      _appliedMedications.add({
        'name': name,
        'date': date,
        'nextDate': nextApplication,
        'manufacturer': manufacturer,
        'batch': batch,
        'status': status,
      });

      notifyListeners();
    }
  }

  DateTime? getNextApplicationDate(String name) {
    var lastMed = _appliedMedications.where((med) => med['name'] == name).toList();
    if (lastMed.isNotEmpty) {
      lastMed.sort((a, b) => b['nextDate'].compareTo(a['nextDate']));
      return lastMed.first['nextDate'];
    }
    return null;
  }
}
