import 'dart:convert';

class Transact {
  final int? id;
  final String name;
  final String description;
  final double ammount;

  Transact({
    this.id,
    required this.name,
    required this.description,
    required this.ammount,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ammount': ammount,
    };
  }

  factory Transact.fromMap(Map<String, dynamic> map) {
    return Transact(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ammount: map['ammount'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Transact.fromJson(String source) => Transact.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Transaction(id: $id, name: $name, description: $description, ammoutn $ammount)';
}
