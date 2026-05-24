import 'package:flutter/material.dart';
import '../sqlite/model/meal_model.dart';
import '../sqlite/service/meal_service.dart';
import '../widgets/customsearchfield.dart';
import '../widgets/home_widget/recipedraggablesheet.dart';
import '../screen/favouritescreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MealService mealService = MealService();
  final TextEditingController searchController = TextEditingController();

  List<MealModel> randomMeals = [];
  List<MealModel> searchResults = [];
  List<MealModel> favorites = [];

  @override
  void initState() {
    super.initState();
    loadRandomMeals();
    loadFavorites();
  }

  // 🔹 Load multiple random meals with caching
  Future<void> loadRandomMeals() async {
    try {
      // Try to load cached meals first
      List<MealModel> cachedMeals = await mealService.dbHelper.getAllMeals();
      if (cachedMeals.isNotEmpty) {
        setState(() => randomMeals = cachedMeals.take(10).toList());
        return;
      }

      // Otherwise fetch online random meals
      final meals = await mealService.getMultipleRandomMeals(10);
      setState(() => randomMeals = meals);
    } catch (e) {
      debugPrint("Error loading random meals: $e");
    }
  }

  // 🔹 Search meals
  Future<void> searchMeal(String value) async {
    if (value.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    try {
      List<MealModel> results = await mealService.searchMeals(value);
      setState(() => searchResults = results);
    } catch (e) {
      debugPrint("Error searching meals: $e");
    }
  }

  // 🔹 Load favorites
  Future<void> loadFavorites() async {
    try {
      List<MealModel> favMeals = await mealService.getFavorites();
      setState(() => favorites = favMeals);
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
  }

  // 🔹 Toggle favorite
  Future<void> toggleFavorite(MealModel meal, bool isFavorite) async {
    try {
      if (isFavorite) {
        await mealService.removeFavorite(meal.mealId);
        setState(() {
          favorites.removeWhere((m) => m.mealId == meal.mealId);
        });
      } else {
        await mealService.addFavorite(meal);
        setState(() {
          favorites.add(meal);
        });
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔶 Background
          Container(
            color: Colors.orange,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Code With Atif... Peshawar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FavouriteScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 🔹 Search field
                CustomSearchField(
                  controller: searchController,
                  onChanged: searchMeal,
                  icon: Icons.search,
                  hintText: "Search recipes...",
                  fillColor: Colors.grey[200]!,
                  textColor: Colors.black,
                  secondaryTextColor: Colors.black54,
                  iconColor: Colors.black,
                ),
              ],
            ),
          ),

          // 🔽 Draggable Sheet
          RecipeDraggableSheet(
            popularRecipes: randomMeals,
            searchResults: searchResults,
            favorites: favorites,
            onFavoriteToggle: toggleFavorite,
          ),
        ],
      ),
    );
  }
}
