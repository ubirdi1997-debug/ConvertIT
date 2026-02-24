import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/conversion_provider.dart';
import '../data/conversion_data.dart';
import '../theme/app_colors.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversionProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'PREFERENCES'),
          const SizedBox(height: 8),
          _SettingsCard(
            isDark: isDark,
            children: [
              // Decimal Places
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Decimal Places',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${provider.decimalPlaces}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: provider.decimalPlaces.toDouble(),
                      min: 0,
                      max: 6,
                      divisions: 6,
                      activeColor: AppColors.accent,
                      onChanged: (value) {
                        provider.setDecimalPlaces(value.round());
                      },
                    ),
                  ],
                ),
              ),
              _Divider(isDark: isDark),

              // Default Category
              ListTile(
                title: Text(
                  'Default Category',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: DropdownButton<String>(
                  value: provider.defaultCategory,
                  underline: const SizedBox(),
                  items: ConversionData.categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.name,
                          child: Text(
                            '${c.emoji} ${c.name}',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) provider.setDefaultCategory(value);
                  },
                ),
              ),
              _Divider(isDark: isDark),

              // Theme
              ListTile(
                title: Text(
                  'Theme',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: SegmentedButton<ThemeMode>(
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: AppColors.accent,
                    selectedForegroundColor: Colors.white,
                    textStyle: GoogleFonts.inter(fontSize: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode, size: 16),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode, size: 16),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto, size: 16),
                    ),
                  ],
                  selected: {provider.themeMode},
                  onSelectionChanged: (selection) {
                    if (selection.isNotEmpty) {
                      provider.setThemeMode(selection.first);
                    }
                  },
                ),
              ),
              _Divider(isDark: isDark),

              // Haptic Feedback
              SwitchListTile(
                title: Text(
                  'Haptic Feedback',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: provider.hapticFeedback,
                activeColor: AppColors.accent,
                onChanged: (value) {
                  provider.setHapticFeedback(value);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          _SectionHeader(title: 'ABOUT'),
          const SizedBox(height: 8),
          _SettingsCard(
            isDark: isDark,
            children: [
              // App Version
              ListTile(
                title: Text(
                  'App Version',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  '1.0.0',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              _Divider(isDark: isDark),

              // Rate Us
              ListTile(
                title: Text(
                  'Rate Us',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.star_rate_rounded,
                  color: Colors.amber,
                ),
                onTap: () async {
                  const url =
                      'https://play.google.com/store/apps/details?id=com.convertit.units';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri,
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
              _Divider(isDark: isDark),

              // Privacy Policy
              ListTile(
                title: Text(
                  'Privacy Policy',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingsCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: isDark
          ? Colors.white.withOpacity(0.08)
          : Colors.black.withOpacity(0.06),
    );
  }
}
