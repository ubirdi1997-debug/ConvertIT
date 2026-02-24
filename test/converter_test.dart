import 'package:flutter_test/flutter_test.dart';
import 'package:convertit/utils/converter.dart';
import 'package:convertit/utils/formatter.dart';

void main() {
  group('Converter', () {
    test('converts meters to kilometers', () {
      final result = Converter.convert(
        category: 'Length',
        fromUnit: 'Meter',
        toUnit: 'Kilometer',
        value: 1000,
      );
      expect(result, closeTo(1.0, 0.0001));
    });

    test('converts kilometers to miles', () {
      final result = Converter.convert(
        category: 'Length',
        fromUnit: 'Kilometer',
        toUnit: 'Mile',
        value: 1,
      );
      expect(result, closeTo(0.621371, 0.001));
    });

    test('converts kilograms to pounds', () {
      final result = Converter.convert(
        category: 'Weight',
        fromUnit: 'Kilogram',
        toUnit: 'Pound',
        value: 1,
      );
      expect(result, closeTo(2.20462, 0.001));
    });

    group('Temperature', () {
      test('converts Celsius to Fahrenheit', () {
        final result = Converter.convert(
          category: 'Temperature',
          fromUnit: 'Celsius',
          toUnit: 'Fahrenheit',
          value: 100,
        );
        expect(result, closeTo(212.0, 0.01));
      });

      test('converts Fahrenheit to Celsius', () {
        final result = Converter.convert(
          category: 'Temperature',
          fromUnit: 'Fahrenheit',
          toUnit: 'Celsius',
          value: 32,
        );
        expect(result, closeTo(0.0, 0.01));
      });

      test('converts Celsius to Kelvin', () {
        final result = Converter.convert(
          category: 'Temperature',
          fromUnit: 'Celsius',
          toUnit: 'Kelvin',
          value: 0,
        );
        expect(result, closeTo(273.15, 0.01));
      });
    });

    test('same unit returns same value', () {
      final result = Converter.convert(
        category: 'Length',
        fromUnit: 'Meter',
        toUnit: 'Meter',
        value: 42,
      );
      expect(result, 42.0);
    });

    test('converts liters to milliliters', () {
      final result = Converter.convert(
        category: 'Volume',
        fromUnit: 'Liter',
        toUnit: 'Milliliter',
        value: 1,
      );
      expect(result, closeTo(1000.0, 0.01));
    });
  });

  group('Formatter', () {
    test('formats number with decimal places', () {
      expect(Formatter.formatNumber(3.14159, 2), '3.14');
    });

    test('formats zero', () {
      expect(Formatter.formatNumber(0, 2), '0');
    });

    test('removes trailing zeros', () {
      expect(Formatter.formatNumber(1.50000, 4), '1.5');
    });

    test('formats large numbers in scientific notation', () {
      final result = Formatter.formatNumber(1.23e16, 2);
      expect(result.contains('e'), isTrue);
    });

    test('formats very small numbers in scientific notation', () {
      final result = Formatter.formatNumber(1.23e-8, 2);
      expect(result.contains('e'), isTrue);
    });
  });
}
