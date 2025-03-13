class Medication {
  final String name;
  final DateTime applicationDate;
  final List<DateTime> nextDoses;

  Medication({required this.name, required this.applicationDate, required this.nextDoses});
}
