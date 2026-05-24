import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../sqlite/model/category_model.dart';
import '../sqlite/service/meal_service.dart';
import 'categoeymealscreen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final MealService mealService = MealService(); // Service for API + offline
  List<CategoryModel> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // 🔹 Fetch categories (online first, fallback to cache)
  Future<void> fetchCategories() async {
    try {
      final response = await mealService.getAllCategories(); // Returns List<CategoryModel>
      setState(() {
        categories = response;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (categories.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No categories found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // Navigate to meals in this category
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryMealsScreen(
                      categoryName: category.category,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (category.image.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: category.image,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                          const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      category.category,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
