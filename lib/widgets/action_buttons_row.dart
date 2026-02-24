import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/conversion_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatter.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversionProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = provider.isFavorite(
      provider.selectedCategory,
      provider.fromUnit,
      provider.toUnit,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _ActionButton(
            icon: Icons.copy_rounded,
            label: 'Copy',
            isDark: isDark,
            onTap: () {
              final result = Formatter.formatNumber(
                provider.result,
                provider.decimalPlaces,
              );
              Clipboard.setData(ClipboardData(text: result));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$result copied to clipboard'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _ActionButton(
            icon: isFav ? Icons.star_rounded : Icons.star_outline_rounded,
            label: isFav ? 'Saved' : 'Save',
            isDark: isDark,
            color: isFav ? AppColors.accent : null,
            onTap: () {
              provider.toggleFavorite();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav ? 'Removed from favorites' : 'Added to favorites',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _ActionButton(
            icon: Icons.share_rounded,
            label: 'Share',
            isDark: isDark,
            onTap: () {
              final result = Formatter.formatNumber(
                provider.result,
                provider.decimalPlaces,
              );
              final input = provider.inputValue;
              final from = provider.fromUnit;
              final to = provider.toUnit;
              Share.share(
                '$input $from = $result $to\n\nConverted with ConvertIt: Units & Measures',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.darkCard : AppColors.card;
    final textColor = color ??
        (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: textColor),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
