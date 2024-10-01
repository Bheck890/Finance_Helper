import 'dart:convert';

class Account {
  final int? id;
  final String name;
  final String description;

  Account({
    this.id,
    required this.name,
    required this.description,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) => Account.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Account(id: $id, name: $name, description: $description)';
}
