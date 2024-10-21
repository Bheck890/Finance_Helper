import 'dart:convert';

class Account {
  final int? id;
  final String name;
  final String tableID;
  final String description;
  final double ammount;

  Account({
    this.id,
    required this.name,
    required this.tableID,
    required this.description,
    required this.ammount,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableID': tableID,
      'name': name,
      'description': description,
      'ammount': ammount,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id']?.toInt() ?? 0,
      tableID: map['tableID'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ammount: map['ammount'] ?? 0
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) => Account.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Account(id: $id, table: $tableID, name: $name, description: $description)';
}
