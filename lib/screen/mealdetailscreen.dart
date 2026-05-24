import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../sqlite/service/meal_service.dart';
import '../sqlite/model/meal_model.dart';

/// Launch external URL
Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    print('Could not launch $url');
  }
}

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealService mealService = MealService();
  MealModel? meal;
  bool isLoading = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    setState(() => isLoading = true);
    try {
      // Fetch meal with offline support
      final fetchedMeal = await mealService.getMealById(widget.mealId);
      if (fetchedMeal != null) {
        final fav = await mealService.isFavorite(widget.mealId);

        setState(() {
          meal = fetchedMeal;
          isFavorite = fav;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching meal details: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleFavorite() async {
    if (meal == null) return;

    if (isFavorite) {
      await mealService.removeFavorite(meal!.mealId!);
    } else {
      await mealService.addFavorite(meal!);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (meal == null) {
      return const Scaffold(
        body: Center(child: Text("Meal details not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(meal!.title ?? "Meal Detail"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Image
            Container(
              width: double.infinity,
              height: 260,
              color: Colors.grey[300],
              child: meal!.image != null
                  ? CachedNetworkImage(
                imageUrl: meal!.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.broken_image, size: 50)),
              )
                  : const Center(child: Icon(Icons.image_not_supported,
                  size: 50)),
            ),
            const SizedBox(height: 12),

            // Meal Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal!.title ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${meal!.category ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Area: ${meal!.area ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Instructions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meal!.instructions ?? 'No instructions available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // YouTube Button
                  if (meal!.youtube != null && meal!.youtube!.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => launchURL(meal!.youtube!),
                      icon: const Icon(Icons.video_library),
                      label: const Text('Watch on YouTube'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
