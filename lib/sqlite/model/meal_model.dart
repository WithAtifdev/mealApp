class MealModel {
  final int? id;
  final String mealId;
  final String title;
  String category; // made mutable
  String area;     // made mutable
  final String instructions;
  final String image;
  final String? youtube;

  MealModel({
    this.id,
    required this.mealId,
    required this.title,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
    this.youtube,
  });

  factory MealModel.fromMap(Map<String, dynamic> map) => MealModel(
    id: map['id'] as int?,
    mealId: map['mealId'] as String,
    title: map['title'] as String,
    category: map['category'] as String,
    area: map['area'] as String,
    instructions: map['instructions'] as String,
    image: map['image'] as String,
    youtube: map['youtube'] as String?,
  );

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'mealId': mealId,
    'title': title,
    'category': category,
    'area': area,
    'instructions': instructions,
    'image': image,
    'youtube': youtube,
  };

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
    mealId: json['idMeal'] ?? '',
    title: json['strMeal'] ?? '',
    category: json['strCategory'] ?? '',
    area: json['strArea'] ?? '',
    instructions: json['strInstructions'] ?? '',
    image: json['strMealThumb'] ?? '',
    youtube: json['strYoutube'],
  );

  Map<String, dynamic> toJson() => {
    'idMeal': mealId,
    'strMeal': title,
    'strCategory': category,
    'strArea': area,
    'strInstructions': instructions,
    'strMealThumb': image,
    'strYoutube': youtube,
  };
}
