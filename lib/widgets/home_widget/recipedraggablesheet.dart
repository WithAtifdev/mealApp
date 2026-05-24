import 'package:flutter/material.dart';
import 'recipesection.dart';
import '../../sqlite/model/meal_model.dart';

class RecipeDraggableSheet extends StatelessWidget {
  final List<MealModel> popularRecipes;
  final List<MealModel> searchResults;
  final List<MealModel> favorites;
  final void Function(MealModel meal, bool isFavorite) onFavoriteToggle;

  const RecipeDraggableSheet({
    super.key,
    required this.popularRecipes,
    required this.searchResults,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 160,
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 0.4,
        maxChildSize: 1,
        builder: (_, scrollController) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 20),
              children: [
                RecipeSection(
                  title: "Popular Recipes",
                  recipes: popularRecipes,
                  favorites: favorites,
                  onFavoriteToggle: onFavoriteToggle,
                ),
                RecipeSection(
                  title: "Search Results",
                  recipes: searchResults,
                  favorites: favorites,
                  onFavoriteToggle: onFavoriteToggle,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
