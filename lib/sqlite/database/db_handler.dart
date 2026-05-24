import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/meal_model.dart';
import '../model/category_model.dart';

class DBHelper {
  static Database? _db;

  // ================= DATABASE =================
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'mealbook.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // ---------------- FAVORITES ----------------
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mealId TEXT UNIQUE,
            title TEXT,
            category TEXT,
            area TEXT,
            instructions TEXT,
            image TEXT,
            youtube TEXT
          )
        ''');

        // ---------------- CACHED MEALS ----------------
        await db.execute('''
          CREATE TABLE cached_meals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mealId TEXT UNIQUE,
            title TEXT,
            category TEXT,
            area TEXT,
            instructions TEXT,
            image TEXT,
            youtube TEXT
          )
        ''');

        // ---------------- CACHED CATEGORIES ----------------
        await db.execute('''
          CREATE TABLE cached_categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            category TEXT UNIQUE,
            image TEXT
          )
        ''');
      },
    );
  }

  // ================= FAVORITES =================
  Future<void> addFavorite(MealModel meal) async {
    final db = await database;
    await db.insert('favorites', meal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String mealId) async {
    final db = await database;
    await db.delete('favorites', where: 'mealId = ?', whereArgs: [mealId]);
  }

  Future<List<MealModel>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');
    return maps.map((e) => MealModel.fromMap(e)).toList();
  }

  Future<bool> isFavorite(String mealId) async {
    final db = await database;
    final maps = await db.query('favorites',
        where: 'mealId = ?', whereArgs: [mealId]);
    return maps.isNotEmpty;
  }

  // ================= CACHED MEALS =================
  Future<void> saveMeals(List<MealModel> meals) async {
    final db = await database;
    final batch = db.batch();
    for (var meal in meals) {
      batch.insert('cached_meals', meal.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<MealModel>> getMealsByCategory(String category) async {
    final db = await database;
    final maps =
    await db.query('cached_meals', where: 'category = ?', whereArgs: [category]);
    return maps.map((e) => MealModel.fromMap(e)).toList();
  }

  Future<List<MealModel>> getMealsByArea(String area) async {
    final db = await database;
    final maps =
    await db.query('cached_meals', where: 'area = ?', whereArgs: [area]);
    return maps.map((e) => MealModel.fromMap(e)).toList();
  }

  Future<List<MealModel>> getCachedMealsByName(String name) async {
    final db = await database;
    final maps =
    await db.query('cached_meals', where: 'title LIKE ?', whereArgs: ['%$name%']);
    return maps.map((e) => MealModel.fromMap(e)).toList();
  }

  Future<MealModel?> getCachedMealById(String mealId) async {
    final db = await database;
    final maps =
    await db.query('cached_meals', where: 'mealId = ?', whereArgs: [mealId]);
    if (maps.isNotEmpty) return MealModel.fromMap(maps.first);
    return null;
  }

  Future<List<MealModel>> getCachedRandomMeals() async {
    // Random meals are just cached meals with category "Random"
    return getMealsByCategory("Random");
  }

  // ✅ New: Get all cached meals
  Future<List<MealModel>> getAllMeals() async {
    final db = await database;
    final maps = await db.query('cached_meals');
    return maps.map((e) => MealModel.fromMap(e)).toList();
  }

  Future<List<String>> getAreas() async {
    final db = await database;
    final maps =
    await db.rawQuery('SELECT DISTINCT area FROM cached_meals WHERE area IS NOT NULL');
    return maps.map((e) => e['area'].toString()).toList();
  }

  Future<void> clearCachedMeals() async {
    final db = await database;
    await db.delete('cached_meals');
  }

  // ================= CACHED CATEGORIES =================
  Future<void> saveCategories(List<CategoryModel> categories) async {
    final db = await database;
    final batch = db.batch();
    for (var cat in categories) {
      batch.insert('cached_categories', cat.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final maps = await db.query('cached_categories');
    return maps.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<void> clearCachedCategories() async {
    final db = await database;
    await db.delete('cached_categories');
  }
}
