import 'package:flutter/material.dart';
import '../../sqlite/model/meal_model.dart';
import '../recipelist.dart';

class RecipeSection extends StatelessWidget {
  final String title;
  final List<MealModel> recipes;
  final List<MealModel> favorites;
  final void Function(MealModel meal, bool isFavorite) onFavoriteToggle;

  const RecipeSection({
    super.key,
    required this.title,
    required this.recipes,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        RecipeList(
          recipes: recipes,
          favorites: favorites,
          onFavoriteToggle: onFavoriteToggle,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
