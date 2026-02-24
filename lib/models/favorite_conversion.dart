class FavoriteConversion {
  final String id;
  final String category;
  final String categoryEmoji;
  final String fromUnit;
  final String toUnit;
  final double lastValue;

  const FavoriteConversion({
    required this.id,
    required this.category,
    required this.categoryEmoji,
    required this.fromUnit,
    required this.toUnit,
    this.lastValue = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'categoryEmoji': categoryEmoji,
        'fromUnit': fromUnit,
        'toUnit': toUnit,
        'lastValue': lastValue,
      };

  factory FavoriteConversion.fromJson(Map<String, dynamic> json) =>
      FavoriteConversion(
        id: json['id'] as String,
        category: json['category'] as String,
        categoryEmoji: json['categoryEmoji'] as String,
        fromUnit: json['fromUnit'] as String,
        toUnit: json['toUnit'] as String,
        lastValue: (json['lastValue'] as num).toDouble(),
      );

  FavoriteConversion copyWith({
    String? id,
    String? category,
    String? categoryEmoji,
    String? fromUnit,
    String? toUnit,
    double? lastValue,
  }) {
    return FavoriteConversion(
      id: id ?? this.id,
      category: category ?? this.category,
      categoryEmoji: categoryEmoji ?? this.categoryEmoji,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      lastValue: lastValue ?? this.lastValue,
    );
  }
}
