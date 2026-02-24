import '../data/conversion_data.dart';

class Converter {
  static double convert({
    required String category,
    required String fromUnit,
    required String toUnit,
    required double value,
  }) {
    if (fromUnit == toUnit) return value;

    if (category == 'Temperature') {
      return _convertTemperature(fromUnit, toUnit, value);
    }

    final cat = ConversionData.getCategoryByName(category);
    if (cat == null) return value;

    try {
      final from = cat.units.firstWhere((u) => u.name == fromUnit);
      final to = cat.units.firstWhere((u) => u.name == toUnit);
      final baseValue = value * from.toBase;
      return baseValue / to.toBase;
    } catch (_) {
      return value;
    }
  }

  static double _convertTemperature(String from, String to, double value) {
    double celsius;
    switch (from) {
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      case 'Rankine':
        celsius = (value - 491.67) * 5 / 9;
        break;
      default:
        celsius = value;
    }

    switch (to) {
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      case 'Rankine':
        return (celsius + 273.15) * 9 / 5;
      default:
        return celsius;
    }
  }
}
