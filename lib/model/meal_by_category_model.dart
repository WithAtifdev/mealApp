class MealsByCategoryResponse {
  List<MealByCategory>? meals;

  MealsByCategoryResponse({this.meals});

  MealsByCategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      meals = <MealByCategory>[];
      json['meals'].forEach((v) {
        meals!.add(MealByCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (meals != null) {
      data['meals'] = meals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealByCategory {
  String? idMeal;
  String? strMeal;
  String? strMealThumb;

  MealByCategory({this.idMeal, this.strMeal, this.strMealThumb});

  MealByCategory.fromJson(Map<String, dynamic> json) {
    idMeal = json['idMeal'];
    strMeal = json['strMeal'];
    strMealThumb = json['strMealThumb'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idMeal'] = idMeal;
    data['strMeal'] = strMeal;
    data['strMealThumb'] = strMealThumb;
    return data;
  }
}
