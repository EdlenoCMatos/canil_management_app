class Animal {
  final String id;
  final String name;
  final String species;
  final String photoUrl;
  final String breed; // caso use raça separadamente de species

  Animal({
    required this.id,
    required this.name,
    required this.species,
    required this.photoUrl,
    required this.breed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'photoUrl': photoUrl,
      'breed': breed,
    };
  }

  static Future<Animal> fromMap(Map<String, dynamic> map) async {
    return Animal(
      id: map['id'],
      name: map['name'],
      species: map['species'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      breed: map['breed'] ?? '',
    );
  }
}
