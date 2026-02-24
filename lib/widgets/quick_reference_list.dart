import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/conversion_provider.dart';
import '../data/conversion_data.dart';
import '../theme/app_colors.dart';
import '../utils/formatter.dart';
import '../utils/converter.dart';

class QuickReferenceList extends StatelessWidget {
  const QuickReferenceList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversionProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputValue = double.tryParse(provider.inputValue) ?? 0.0;

    if (inputValue == 0) return const SizedBox.shrink();

    final cat = ConversionData.getCategoryByName(provider.selectedCategory);
    if (cat == null) return const SizedBox.shrink();

    final cardColor = isDark ? AppColors.darkCard : AppColors.card;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 2,
                color: AppColors.accent.withOpacity(0.5),
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Reference',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 2,
                color: AppColors.accent.withOpacity(0.5),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cat.units.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
            ),
            itemBuilder: (context, index) {
              final unit = cat.units[index];
              final isFrom = unit.name == provider.fromUnit;
              final isTo = unit.name == provider.toUnit;

              double convertedValue;
              try {
                convertedValue = Converter.convert(
                  category: provider.selectedCategory,
                  fromUnit: provider.fromUnit,
                  toUnit: unit.name,
                  value: inputValue,
                );
              } catch (_) {
                convertedValue = 0;
              }

              return ListTile(
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                title: Text(
                  unit.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: (isFrom || isTo)
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: (isFrom || isTo) ? AppColors.accent : textColor,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Formatter.formatNumber(
                          convertedValue, provider.decimalPlaces),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: (isFrom || isTo)
                            ? AppColors.accent
                            : textColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit.symbol,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (provider.selectedCategory == 'Currency')
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              '* Currency rates last updated: Jan 2024. For latest rates, use a currency app.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}

