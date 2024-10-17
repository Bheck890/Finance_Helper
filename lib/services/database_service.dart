import 'dart:io';

import 'package:finance_helper/models/account.dart';
import 'package:finance_helper/models/dog.dart';
import 'package:finance_helper/models/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {

    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();

      // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
      // this step, it will use the sqlite version available on the system.
      databaseFactory = databaseFactoryFfi;

      print("     On desktop.");
    }
    else{
      print("     On mobile.");
    }
    

    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {

    final databasePath = await getDatabasesPath();
    print("Databese path: ======> $databasePath");
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'platform.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store breeds
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE accounts(id INTEGER PRIMARY KEY, name TEXT, description TEXT, ammount DOUBLE)',
    );
    // // Run the CREATE {dogs} TABLE statement on the database.
    // await db.execute(
    //   'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER, color INTEGER, breedId INTEGER, FOREIGN KEY (breedId) REFERENCES breeds(id) ON DELETE SET NULL)',
    // );
  }

  // Define a function that inserts breeds into the database
  Future<void> insertAccount(Account accnt, Transact transact) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    

    // Insert the Breed into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.

    //Adds Account to a main Data Table
    await db.insert(
      'accounts',
      accnt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //Creates Table with name of User made Account
    await db.execute(
      'CREATE TABLE ${accnt.name}(id INTEGER PRIMARY KEY, name TEXT, description TEXT, ammount DOUBLE)',
    );

    //Adds Transaction to the Table that was just made.
    await db.insert(
      accnt.name,
      transact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertDog(Dog dog) async {
    final db = await _databaseService.database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the breeds from the breeds table.
  Future<List<Account>> accounts() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('accounts');

    // Convert the List<Map<String, dynamic> into a List<Breed>.
    return List.generate(maps.length, (index) => Account.fromMap(maps[index]));
  }

  // A method that retrieves all the breeds from the breeds table.
  Future<List<Map<String, dynamic>>> accountsData() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('accounts');

    

    return maps;
    
    // Convert the List<Map<String, dynamic> into a List<Breed>.
    //List.generate(maps.length, (index) => Account.fromMap(maps[index]));
  }

  Future<Account> account(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('accounts', where: 'id = ?', whereArgs: [id]);
    return Account.fromMap(maps[0]);
  }

  Future<List<Dog>> dogs() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (index) => Dog.fromMap(maps[index]));
  }

  // A method that updates a breed data from the breeds table.
  Future<void> updateBreed(Account breed) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Update the given breed
    await db.update(
      'accounts',
      breed.toMap(),
      // Ensure that the Breed has a matching id.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [breed.id],
    );
  }

  Future<void> updateDog(Dog dog) async {
    final db = await _databaseService.database;
    await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  // A method that deletes a breed data from the breeds table.
  Future<void> deleteBreed(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the Breed from the database.
    await db.delete(
      'accounts',
      // Use a `where` clause to delete a specific breed.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteAccount(int id) async {
    final db = await _databaseService.database;
    await db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }

}
