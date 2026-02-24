import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/conversion_data.dart';
import '../models/conversion_history.dart';
import '../models/favorite_conversion.dart';
import '../utils/converter.dart';

class ConversionProvider extends ChangeNotifier {
  // State
  String _selectedCategory = 'Length';
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  String _inputValue = '1';
  double _result = 0.001;
  List<ConversionHistory> _history = [];
  List<FavoriteConversion> _favorites = [];

  // Settings
  int _decimalPlaces = 4;
  ThemeMode _themeMode = ThemeMode.system;
  bool _hapticFeedback = true;
  String _defaultCategory = 'Length';

  // Getters
  String get selectedCategory => _selectedCategory;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  String get inputValue => _inputValue;
  double get result => _result;
  List<ConversionHistory> get history => List.unmodifiable(_history);
  List<FavoriteConversion> get favorites => List.unmodifiable(_favorites);
  int get decimalPlaces => _decimalPlaces;
  ThemeMode get themeMode => _themeMode;
  bool get hapticFeedback => _hapticFeedback;
  String get defaultCategory => _defaultCategory;

  List<String> get currentUnits {
    final cat = ConversionData.getCategoryByName(_selectedCategory);
    return cat?.units.map((u) => u.name).toList() ?? [];
  }

  ConversionProvider() {
    _loadPreferences();
    _calculate();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    final units = currentUnits;
    _fromUnit = units.isNotEmpty ? units[0] : '';
    _toUnit = units.length > 1 ? units[1] : units[0];
    _calculate();
    notifyListeners();
  }

  void setFromUnit(String unit) {
    _fromUnit = unit;
    _calculate();
    notifyListeners();
  }

  void setToUnit(String unit) {
    _toUnit = unit;
    _calculate();
    notifyListeners();
  }

  void setInputValue(String value) {
    _inputValue = value;
    _calculate();
    notifyListeners();
  }

  void swapUnits() {
    final tempUnit = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = tempUnit;

    // Also swap the value
    final oldResult = _result;
    _inputValue = oldResult.toString();
    _calculate();
    notifyListeners();
  }

  void _calculate() {
    final value = double.tryParse(_inputValue) ?? 0.0;
    if (_fromUnit.isEmpty || _toUnit.isEmpty) {
      _result = 0;
      return;
    }
    _result = Converter.convert(
      category: _selectedCategory,
      fromUnit: _fromUnit,
      toUnit: _toUnit,
      value: value,
    );
    _addToHistory();
  }

  void _addToHistory() {
    final value = double.tryParse(_inputValue) ?? 0.0;
    if (value == 0) return;
    if (_fromUnit.isEmpty || _toUnit.isEmpty) return;

    final cat = ConversionData.getCategoryByName(_selectedCategory);
    if (cat == null) return;

    final entry = ConversionHistory(
      category: _selectedCategory,
      categoryEmoji: cat.emoji,
      fromUnit: _fromUnit,
      toUnit: _toUnit,
      inputValue: value,
      resultValue: _result,
      timestamp: DateTime.now(),
    );

    // Don't add duplicate consecutive entries
    if (_history.isNotEmpty) {
      final last = _history.first;
      if (last.category == entry.category &&
          last.fromUnit == entry.fromUnit &&
          last.toUnit == entry.toUnit &&
          last.inputValue == entry.inputValue) {
        return;
      }
    }

    _history.insert(0, entry);
    if (_history.length > 50) {
      _history = _history.sublist(0, 50);
    }
    _saveHistory();
  }

  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  void openHistoryEntry(ConversionHistory entry) {
    _selectedCategory = entry.category;
    _fromUnit = entry.fromUnit;
    _toUnit = entry.toUnit;
    _inputValue = entry.inputValue.toString();
    _calculate();
    notifyListeners();
  }

  bool isFavorite(String category, String fromUnit, String toUnit) {
    return _favorites.any((f) =>
        f.category == category && f.fromUnit == fromUnit && f.toUnit == toUnit);
  }

  void toggleFavorite() {
    final existing = _favorites.indexWhere((f) =>
        f.category == _selectedCategory &&
        f.fromUnit == _fromUnit &&
        f.toUnit == _toUnit);

    if (existing >= 0) {
      _favorites.removeAt(existing);
    } else {
      final cat = ConversionData.getCategoryByName(_selectedCategory);
      final value = double.tryParse(_inputValue) ?? 1.0;
      _favorites.add(FavoriteConversion(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory,
        categoryEmoji: cat?.emoji ?? '',
        fromUnit: _fromUnit,
        toUnit: _toUnit,
        lastValue: value,
      ));
    }
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(String id) {
    _favorites.removeWhere((f) => f.id == id);
    _saveFavorites();
    notifyListeners();
  }

  void openFavorite(FavoriteConversion favorite) {
    _selectedCategory = favorite.category;
    _fromUnit = favorite.fromUnit;
    _toUnit = favorite.toUnit;
    _inputValue = favorite.lastValue.toString();
    _calculate();
    notifyListeners();
  }

  void setDecimalPlaces(int places) {
    _decimalPlaces = places;
    _savePreferences();
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _savePreferences();
    notifyListeners();
  }

  void setHapticFeedback(bool enabled) {
    _hapticFeedback = enabled;
    _savePreferences();
    notifyListeners();
  }

  void setDefaultCategory(String category) {
    _defaultCategory = category;
    _savePreferences();
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _decimalPlaces = prefs.getInt('decimalPlaces') ?? 4;
    _hapticFeedback = prefs.getBool('hapticFeedback') ?? true;
    _defaultCategory = prefs.getString('defaultCategory') ?? 'Length';

    final themeModeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex.clamp(0, 2)];

    // Load history
    final historyJson = prefs.getStringList('history') ?? [];
    _history = historyJson
        .map((j) => ConversionHistory.fromJson(jsonDecode(j) as Map<String, dynamic>))
        .toList();

    // Load favorites
    final favJson = prefs.getStringList('favorites') ?? [];
    _favorites = favJson
        .map((j) => FavoriteConversion.fromJson(jsonDecode(j) as Map<String, dynamic>))
        .toList();

    // Set default category
    _selectedCategory = _defaultCategory;
    final units = currentUnits;
    _fromUnit = units.isNotEmpty ? units[0] : '';
    _toUnit = units.length > 1 ? units[1] : (units.isNotEmpty ? units[0] : '');
    _calculate();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _history.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList('history', historyJson);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favJson = _favorites.map((f) => jsonEncode(f.toJson())).toList();
    await prefs.setStringList('favorites', favJson);
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('decimalPlaces', _decimalPlaces);
    await prefs.setBool('hapticFeedback', _hapticFeedback);
    await prefs.setString('defaultCategory', _defaultCategory);
    await prefs.setInt('themeMode', _themeMode.index);
  }
}
