import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/conversion_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state_widget.dart';
import '../utils/formatter.dart';

class HistoryScreen extends StatelessWidget {
  final VoidCallback? onNavigateToConvert;

  const HistoryScreen({super.key, this.onNavigateToConvert});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversionProvider>();
    final history = provider.history;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (history.isNotEmpty)
            TextButton(
              onPressed: () => _showClearDialog(context, provider),
              child: Text(
                'Clear',
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: history.isEmpty
          ? const EmptyStateWidget(
              emoji: '🕐',
              title: 'No history yet',
              subtitle:
                  'Your conversion history will appear here as you convert units.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                final cardColor = isDark ? AppColors.darkCard : AppColors.card;

                return GestureDetector(
                  onTap: () {
                    provider.openHistoryEntry(entry);
                    onNavigateToConvert?.call();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            entry.categoryEmoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      title: Text(
                        '${Formatter.formatNumber(entry.inputValue, 4)} ${entry.fromUnit}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '= ${Formatter.formatNumber(entry.resultValue, 4)} ${entry.toUnit}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.accent,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        Formatter.timeAgo(entry.timestamp),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showClearDialog(BuildContext context, ConversionProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear History',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to clear all conversion history?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Clear',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
