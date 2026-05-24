import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/db_handler.dart';
import '../model/meal_model.dart';
import '../model/category_model.dart';

class MealService {
  final DBHelper dbHelper = DBHelper();

  // ----------------- Check Internet -----------------
  Future<bool> _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // ----------------- Get meal by ID (offline + online) -----------------
  Future<MealModel?> getMealById(String mealId) async {
    final cachedMeal = await dbHelper.getCachedMealById(mealId);
    if (cachedMeal != null) return cachedMeal;

    if (await _checkInternet()) {
      final fetchedMeal = await _fetchMealDetails(mealId);
      if (fetchedMeal != null) {
        await dbHelper.saveMeals([fetchedMeal]);
      }
      return fetchedMeal;
    }
    return null;
  }

  // ----------------- Fetch single meal details -----------------
  Future<MealModel?> _fetchMealDetails(String mealId) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mealData = data['meals'][0];
        return MealModel.fromJson(mealData);
      }
    } catch (e) {
      debugPrint("Fetch meal details error: $e");
    }
    return null;
  }

  // ----------------- Meals by Category -----------------
  Future<List<MealModel>> getMealsByCategory(String category) async {
    final cachedMeals = await dbHelper.getMealsByCategory(category);
    if (cachedMeals.isNotEmpty) return cachedMeals;

    if (await _checkInternet()) {
      try {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List mealsJson = data['meals'] ?? [];

          final mealList = await Future.wait(mealsJson.map((meal) async {
            final fullMeal = await getMealById(meal['idMeal']);
            return fullMeal;
          }).toList());

          final fullMeals = mealList.whereType<MealModel>().toList();
          await dbHelper.saveMeals(fullMeals);
          return fullMeals;
        }
      } catch (e) {
        debugPrint("Meals by category fetch error: $e");
      }
    }
    return [];
  }

  // ----------------- Meals by Area -----------------
  Future<List<MealModel>> getMealsByArea(String area) async {
    final cachedMeals = await dbHelper.getMealsByArea(area);
    if (cachedMeals.isNotEmpty) return cachedMeals;

    if (await _checkInternet()) {
      try {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?a=$area'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List mealsJson = data['meals'] ?? [];

          final mealList = await Future.wait(mealsJson.map((meal) async {
            final fullMeal = await getMealById(meal['idMeal']);
            return fullMeal;
          }).toList());

          final fullMeals = mealList.whereType<MealModel>().toList();
          await dbHelper.saveMeals(fullMeals);
          return fullMeals;
        }
      } catch (e) {
        debugPrint("Meals by area fetch error: $e");
      }
    }
    return [];
  }

  // ----------------- Search Meals -----------------
  Future<List<MealModel>> searchMeals(String query) async {
    final cachedMeals = await dbHelper.getCachedMealsByName(query);
    if (cachedMeals.isNotEmpty) return cachedMeals;

    if (await _checkInternet()) {
      try {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List mealsJson = data['meals'] ?? [];
          final mealList = mealsJson.map<MealModel>((meal) => MealModel.fromJson(meal)).toList();
          await dbHelper.saveMeals(mealList);
          return mealList;
        }
      } catch (e) {
        debugPrint("Search meals error: $e");
      }
    }
    return [];
  }

  // ----------------- Favorites -----------------
  Future<void> addFavorite(MealModel meal) async => await dbHelper.addFavorite(meal);
  Future<void> removeFavorite(String mealId) async => await dbHelper.removeFavorite(mealId);
  Future<List<MealModel>> getFavorites() async => await dbHelper.getFavorites();
  Future<bool> isFavorite(String mealId) async => await dbHelper.isFavorite(mealId);

  // ----------------- Categories -----------------
  Future<List<CategoryModel>> getAllCategories() async {
    final cachedCategories = await dbHelper.getCategories();
    if (cachedCategories.isNotEmpty) return cachedCategories;

    if (await _checkInternet()) {
      try {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List categoriesJson = data['categories'] ?? [];
          final categories = categoriesJson.map<CategoryModel>((cat) {
            return CategoryModel(
              id: null,
              title: cat['strCategory'],
              category: cat['strCategory'],
              image: cat['strCategoryThumb'],
            );
          }).toList();

          await dbHelper.saveCategories(categories);
          return categories;
        }
      } catch (e) {
        debugPrint("Fetch categories error: $e");
      }
    }

    return [];
  }

  // ----------------- Areas -----------------
  Future<List<String>> getAllAreas() async {
    List<String> areas = await dbHelper.getAreas();

    if (await _checkInternet()) {
      try {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?a=list'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final onlineAreas = (data['meals'] as List).map<String>((a) => a['strArea'].toString()).toList();
          if (onlineAreas.isNotEmpty) areas = onlineAreas;
        }
      } catch (e) {
        debugPrint("Fetch areas error: $e");
      }
    }

    return areas;
  }

  // ----------------- Random Meals -----------------
  Future<MealModel?> getRandomMeal() async {
    if (await _checkInternet()) {
      try {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final meal = MealModel.fromJson(data['meals'][0]);
          await dbHelper.saveMeals([meal]);
          return meal;
        }
      } catch (e) {
        debugPrint("Random meal fetch error: $e");
      }
    }
    return null;
  }

  Future<List<MealModel>> getMultipleRandomMeals(int count) async {
    final Set<String> ids = {}; // track unique mealIds
    final List<MealModel> meals = [];

    while (meals.length < count) {
      final meal = await getRandomMeal();
      if (meal != null && !ids.contains(meal.mealId)) {
        meals.add(meal);
        ids.add(meal.mealId);
      }
    }

    return meals;
  }
}
