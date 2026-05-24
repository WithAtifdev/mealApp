import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category-response_model.dart';
import '../model/full_meal_response_model.dart';
import '../model/meal_by_category_model.dart';
import '../model/random_meal_model.dart';
import '../model/search_meal_model.dart';
import '../model/area_response_model.dart';

class MealRepository {
  // Search meals by name
  Future<SearchMealResponse> searchMeals(String name) async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return SearchMealResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to search meals');
    }
  }

  // Get a random meal
  Future<RandomMealResponse> getRandomMeal() async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return RandomMealResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch random meal');
    }
  }

  // Get full meal details by ID
  Future<FullMealResponse> getMealById(String id) async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return FullMealResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch meal details');
    }
  }

  // Get all categories
  Future<CategoryResponse> getCategories() async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return CategoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  // Get meals by category
  Future<MealsByCategoryResponse> getMealsByCategory(String categoryName) async {
    try {
      final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return MealsByCategoryResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch meals by category');
      }
    } catch (e) {
      throw Exception('Error fetching meals by category: $e');
    }
  }

  // Get all areas/cuisines
  Future<AreaResponse> getAreas() async {
    try {
      final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?a=list');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return AreaResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch areas');
      }
    } catch (e) {
      throw Exception('Error fetching areas: $e');
    }
  }

  // Get meals by area/cuisine
  Future<MealsByCategoryResponse> getMealsByArea(String areaName) async {
    try {
      final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?a=$areaName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return MealsByCategoryResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch meals by area');
      }
    } catch (e) {
      throw Exception('Error fetching meals by area: $e');
    }
  }
}
