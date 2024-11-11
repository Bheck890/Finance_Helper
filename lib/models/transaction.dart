import 'dart:convert';

class Transact {
  final int? id;
  final String name;
  final String description;
  final double ammount;
  final int sec;
  final int min;
  final int hour;
  final int day;
  final int month;
  final int year;

  Transact({
    this.id,
    required this.name,
    required this.description,
    required this.ammount,
    required this.sec,
    required this.min,
    required this.hour,
    required this.day,
    required this.month,
    required this.year,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ammount': ammount,
      'sec' : sec,
      'min': min,
      'hour': hour,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory Transact.fromMap(Map<String, dynamic> map) {
    return Transact(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ammount: map['ammount'] ?? '',
      sec: map['sec'] ?? '',
      min: map['min'] ?? '',
      hour: map['hour'] ?? '',
      day: map['day'] ?? '',
      month: map['month'] ?? '',
      year: map['year'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Transact.fromJson(String source) => Transact.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Transaction(id: $id, name: $name, description: $description, ammount $ammount, sec $sec, min $min, hour $hour, day $day, month $month, year $year)';
}
