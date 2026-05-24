import 'package:flutter/material.dart';
import '../sqlite/service/meal_service.dart';
import '../widgets/recipelist.dart';
import '../sqlite/model/meal_model.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final MealService mealService = MealService();
  List<MealModel> favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  // 🔹 Load favorites using MealService
  Future<void> loadFavorites() async {
    final favMeals = await mealService.getFavorites();
    setState(() {
      favoriteMeals = favMeals;
    });
  }

  // 🔹 Toggle favorite status
  Future<void> toggleFavorite(MealModel meal, bool isFav) async {
    if (isFav) {
      await mealService.removeFavorite(meal.mealId!);
      setState(() {
        favoriteMeals.removeWhere((m) => m.mealId == meal.mealId);
      });
    } else {
      await mealService.addFavorite(meal);
      setState(() {
        favoriteMeals.add(meal);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.orange,
      ),
      body: favoriteMeals.isEmpty
          ? const Center(
        child: Text(
          "No favorite meals yet!",
          style: TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: RecipeList(
          recipes: favoriteMeals,
          favorites: favoriteMeals,
          onFavoriteToggle: toggleFavorite,
        ),
      ),
    );
  }
}
