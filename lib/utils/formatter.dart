class Formatter {
  static String formatNumber(double value, int decimalPlaces) {
    if (value.isInfinite || value.isNaN) return '—';
    if (value == 0) return '0';

    // Use scientific notation for very large or very small numbers
    final absValue = value.abs();
    if (absValue != 0 && (absValue >= 1e15 || absValue < 1e-6)) {
      return value.toStringAsExponential(decimalPlaces);
    }

    // Format with specified decimal places
    String formatted = value.toStringAsFixed(decimalPlaces);

    // Remove trailing zeros after decimal point if decimalPlaces > 0
    if (decimalPlaces > 0 && formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }

    return formatted;
  }

  static String formatInput(String input) {
    if (input.isEmpty) return '';
    return input;
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
