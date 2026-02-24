import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/conversion_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state_widget.dart';
import '../utils/formatter.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback? onNavigateToConvert;

  const FavoritesScreen({super.key, this.onNavigateToConvert});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversionProvider>();
    final favorites = provider.favorites;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: favorites.isEmpty
          ? const EmptyStateWidget(
              emoji: '⭐',
              title: 'No favorites yet',
              subtitle:
                  'Save your first conversion by tapping the ⭐ button on the converter screen.',
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final fav = favorites[index];
                  final isDarkCard = isDark;
                  final cardColor =
                      isDarkCard ? AppColors.darkCard : AppColors.card;

                  return Dismissible(
                    key: Key(fav.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      provider.removeFavorite(fav.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Removed from favorites'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Would need to restore - simplified here
                            },
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        provider.openFavorite(fav);
                        onNavigateToConvert?.call();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  fav.categoryEmoji,
                                  style: const TextStyle(fontSize: 22),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    fav.category,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              fav.fromUnit,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.arrow_downward_rounded,
                                  size: 14,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    fav.toUnit,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accent,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatter.formatNumber(fav.lastValue, 2),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
