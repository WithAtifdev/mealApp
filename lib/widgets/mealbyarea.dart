import 'package:flutter/material.dart';
import '../sqlite/service/meal_service.dart';
import '../sqlite/model/meal_model.dart';
import '../screen/mealdetailscreen.dart';

class MealsByAreaScreen extends StatefulWidget {
  final String areaName;
  const MealsByAreaScreen({super.key, required this.areaName});

  @override
  State<MealsByAreaScreen> createState() => _MealsByAreaScreenState();
}

class _MealsByAreaScreenState extends State<MealsByAreaScreen> {
  final MealService mealService = MealService();
  List<MealModel> meals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    setState(() => isLoading = true);
    try {
      // Fetch meals by area using MealService (with offline support)
      final fetchedMeals = await mealService.getMealsByArea(widget.areaName);
      setState(() {
        meals = fetchedMeals;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching meals: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.areaName} Meals"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : meals.isEmpty
          ? const Center(child: Text("No meals found"))
          : Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: meals.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final meal = meals[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealDetailScreen(
                        mealId: meal.mealId,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        meal.image,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(
                            child:
                            Icon(Icons.broken_image, size: 50)),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        meal.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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
