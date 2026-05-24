class IngredientResponse {
  List<Ingredient>? ingredients;

  IngredientResponse({this.ingredients});

  IngredientResponse.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      ingredients = <Ingredient>[];
      json['meals'].forEach((v) {
        ingredients!.add(Ingredient.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (ingredients != null) {
      data['meals'] = ingredients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ingredient {
  String? strIngredient;

  Ingredient({this.strIngredient});

  Ingredient.fromJson(Map<String, dynamic> json) {
    strIngredient = json['strIngredient'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['strIngredient'] = strIngredient;
    return data;
  }
}
