import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../sqlite/model/meal_model.dart';
import '../sqlite/service/meal_service.dart';
import 'mealdetailscreen.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryMealsScreen({super.key, required this.categoryName});

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  final MealService mealService = MealService(); // Use new service
  List<Map<String, String>> meals = [];
  List<Map<String, String>> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealsByCategory();
    loadFavorites();
  }

  // 🔹 Fetch meals by category (online or from cache)
  Future<void> fetchMealsByCategory() async {
    try {
      List<MealModel> mealList =
      await mealService.getMealsByCategory(widget.categoryName);

      setState(() {
        meals = mealList.map((meal) => {
          'id': meal.mealId,
          'title': meal.title,
          'category': meal.category,
          'area': meal.area,
          'instructions': meal.instructions,
          'image': meal.image,
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching meals by category: $e");
      setState(() => isLoading = false);
    }
  }

  // 🔹 Load favorites
  void loadFavorites() async {
    final favMeals = await mealService.getFavorites();
    setState(() {
      favorites = favMeals.map((meal) => {
        'id': meal.mealId,
        'title': meal.title,
        'category': meal.category,
        'area': meal.area,
        'instructions': meal.instructions,
        'image': meal.image,
      }).toList();
    });
  }

  // 🔹 Toggle favorite
  void toggleFavorite(Map<String, String> mealMap, bool isFavorite) async {
    MealModel meal = MealModel(
      mealId: mealMap['id']!,
      title: mealMap['title']!,
      category: mealMap['category']!,
      area: mealMap['area']!,
      instructions: mealMap['instructions']!,
      image: mealMap['image']!,
    );

    if (isFavorite) {
      await mealService.removeFavorite(meal.mealId);
      setState(() {
        favorites.removeWhere((f) => f['id'] == meal.mealId);
      });
    } else {
      await mealService.addFavorite(meal);
      setState(() {
        favorites.add(mealMap);
      });
    }
  }

  bool isMealFavorite(String mealId) {
    return favorites.any((f) => f['id'] == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : meals.isEmpty
          ? const Center(child: Text("No meals found in this category"))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          final favorite = isMealFavorite(meal['id']!);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MealDetailScreen(mealId: meal['id']!),
                ),
              );
            },
            child: Stack(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (meal['image'] != null)
                        CachedNetworkImage(
                          imageUrl: meal['image']!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported, size: 40),
                        ),

                      const SizedBox(height: 10),
                      Text(
                        meal['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Favorite icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      toggleFavorite(meal, favorite);
                    },
                    child: Icon(
                      favorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
