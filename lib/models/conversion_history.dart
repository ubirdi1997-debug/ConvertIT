class ConversionHistory {
  final String category;
  final String categoryEmoji;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final double resultValue;
  final DateTime timestamp;

  const ConversionHistory({
    required this.category,
    required this.categoryEmoji,
    required this.fromUnit,
    required this.toUnit,
    required this.inputValue,
    required this.resultValue,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'categoryEmoji': categoryEmoji,
        'fromUnit': fromUnit,
        'toUnit': toUnit,
        'inputValue': inputValue,
        'resultValue': resultValue,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ConversionHistory.fromJson(Map<String, dynamic> json) =>
      ConversionHistory(
        category: json['category'] as String,
        categoryEmoji: json['categoryEmoji'] as String,
        fromUnit: json['fromUnit'] as String,
        toUnit: json['toUnit'] as String,
        inputValue: (json['inputValue'] as num).toDouble(),
        resultValue: (json['resultValue'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
