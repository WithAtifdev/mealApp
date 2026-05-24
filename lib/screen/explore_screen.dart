import 'package:flutter/material.dart';
import '../sqlite/service/meal_service.dart';
import '../screen/categoeymealscreen.dart';
import '../widgets/mealbyarea.dart'; // your screen for area meals

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final MealService mealService = MealService();

  List<String> areas = [];
  List<String> ingredients = [];

  String? selectedArea;
  String? selectedIngredient;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() => loading = true);

      // ---------------- Areas ----------------
      areas = await mealService.getAllAreas();

      // ---------------- Ingredients / Categories ----------------
      final categories = await mealService.getAllCategories();
      ingredients = categories.map((c) => c.category ?? '').toList();

    } catch (e) {
      debugPrint("Error loading areas/ingredients: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Meals"),
        backgroundColor: Colors.orange,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            // ---------------- Countries / Areas Dropdown ----------------
            Expanded(

              child: DropdownButtonFormField<String>(
                isExpanded: true,
                hint: const Text("Select Country"),
                value: selectedArea,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: areas
                    .map((area) => DropdownMenuItem(
                  value: area,
                  child: Text(area),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() => selectedArea = value);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealsByAreaScreen(areaName: value),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),

            // ---------------- Ingredients / Categories Dropdown ----------------
            Expanded(
              child: DropdownButtonFormField<String>(
                hint: const Text("Select Ingredient"),
                value: selectedIngredient,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ingredients
                    .map((ing) => DropdownMenuItem(
                  value: ing,
                  child: Text(ing),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() => selectedIngredient = value);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryMealsScreen(categoryName: value),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
