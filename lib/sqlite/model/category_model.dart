class CategoryModel {
  final int? id;
  final String title;
  final String category;
  final String image;

  CategoryModel({
    this.id,
    required this.title,
    required this.category,
    required this.image,
  });

  // From SQLite Map
  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
    id: map['id'] as int?,
    title: map['title'] as String,
    category: map['category'] as String,
    image: map['image'] as String,
  );

  // To SQLite Map
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'title': title,
      'category': category,
      'image': image,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  // From API JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: null,
    title: json['strCategory'] ?? '',
    category: json['strCategory'] ?? '',
    image: json['strCategoryThumb'] ?? '',
  );

  // To API JSON
  Map<String, dynamic> toJson() => {
    'strCategory': title,
    'strCategoryThumb': image,
  };
}
