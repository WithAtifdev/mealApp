class FullMealResponse {
  List<FullMeal>? meals;

  FullMealResponse({this.meals});

  FullMealResponse.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      meals = <FullMeal>[];
      json['meals'].forEach((v) {
        meals!.add(FullMeal.fromJson(v));
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

class FullMeal {
  String? idMeal;
  String? strMeal;
  String? strCategory;
  String? strArea;
  String? strInstructions;
  String? strMealThumb;
  String? strYoutube;  // ← Add this field

  FullMeal({
    this.idMeal,
    this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strYoutube,    // ← Add this
  });

  FullMeal.fromJson(Map<String, dynamic> json) {
    idMeal = json['idMeal'];
    strMeal = json['strMeal'];
    strCategory = json['strCategory'];
    strArea = json['strArea'];
    strInstructions = json['strInstructions'];
    strMealThumb = json['strMealThumb'];
    strYoutube = json['strYoutube'];  // ← Add this
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idMeal'] = idMeal;
    data['strMeal'] = strMeal;
    data['strCategory'] = strCategory;
    data['strArea'] = strArea;
    data['strInstructions'] = strInstructions;
    data['strMealThumb'] = strMealThumb;
    data['strYoutube'] = strYoutube; // ← Add this
    return data;
  }
}
