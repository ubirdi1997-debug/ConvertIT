class ConversionUnit {
  final String name;
  final String symbol;
  final double toBase; // Factor to convert to base unit (null for non-linear like temp)
  final bool isBaseUnit;

  const ConversionUnit({
    required this.name,
    required this.symbol,
    this.toBase = 1.0,
    this.isBaseUnit = false,
  });
}

class ConversionCategory {
  final String name;
  final String emoji;
  final List<ConversionUnit> units;

  const ConversionCategory({
    required this.name,
    required this.emoji,
    required this.units,
  });
}
