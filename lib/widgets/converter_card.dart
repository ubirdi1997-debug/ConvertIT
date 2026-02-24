import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/conversion_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatter.dart';

class ConverterCard extends StatefulWidget {
  const ConverterCard({super.key});

  @override
  State<ConverterCard> createState() => _ConverterCardState();
}

class _ConverterCardState extends State<ConverterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _swapController;
  late Animation<double> _swapAnimation;
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _swapAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _swapController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ConversionProvider>();
      _inputController.text = provider.inputValue;
    });
  }

  @override
  void dispose() {
    _swapController.dispose();
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSwap() {
    _swapController.forward(from: 0);
    final provider = context.read<ConversionProvider>();
    provider.swapUnits();
    _inputController.text = provider.inputValue;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversionProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.card;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    // Sync input controller if changed externally
    if (_inputController.text != provider.inputValue &&
        !_focusNode.hasFocus) {
      _inputController.text = provider.inputValue;
    }

    return Column(
      children: [
        // FROM Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UnitDropdownRow(
                label: 'FROM',
                selectedUnit: provider.fromUnit,
                units: provider.currentUnits,
                onChanged: (unit) {
                  if (unit != null) provider.setFromUnit(unit);
                },
                isDark: isDark,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _inputController,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: false,
                    hintText: '0',
                    hintStyle: GoogleFonts.jetBrainsMono(
                      fontSize: 32,
                      color: textColor.withOpacity(0.3),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    provider.setInputValue(value);
                  },
                ),
              ),
            ],
          ),
        ),

        // SWAP button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: GestureDetector(
            onTap: _handleSwap,
            child: AnimatedBuilder(
              animation: _swapAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _swapAnimation.value * 3.14159,
                  child: child,
                );
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),

        // TO Card
        GestureDetector(
          onLongPress: () {
            final result = Formatter.formatNumber(
              provider.result,
              provider.decimalPlaces,
            );
            // Copy to clipboard handled in parent
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$result copied!'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UnitDropdownRow(
                  label: 'TO',
                  selectedUnit: provider.toUnit,
                  units: provider.currentUnits,
                  onChanged: (unit) {
                    if (unit != null) provider.setToUnit(unit);
                  },
                  isDark: isDark,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    Formatter.formatNumber(
                      provider.result,
                      provider.decimalPlaces,
                    ),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UnitDropdownRow extends StatelessWidget {
  final String label;
  final String selectedUnit;
  final List<String> units;
  final ValueChanged<String?> onChanged;
  final bool isDark;

  const _UnitDropdownRow({
    required this.label,
    required this.selectedUnit,
    required this.units,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _showUnitBottomSheet(context),
              child: Row(
                children: [
                  Text(
                    selectedUnit,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnitBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UnitSearchSheet(
        units: units,
        selectedUnit: selectedUnit,
        onSelected: (unit) {
          onChanged(unit);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _UnitSearchSheet extends StatefulWidget {
  final List<String> units;
  final String selectedUnit;
  final ValueChanged<String> onSelected;

  const _UnitSearchSheet({
    required this.units,
    required this.selectedUnit,
    required this.onSelected,
  });

  @override
  State<_UnitSearchSheet> createState() => _UnitSearchSheetState();
}

class _UnitSearchSheetState extends State<_UnitSearchSheet> {
  late List<String> _filtered;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.units;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      _filtered = widget.units
          .where((u) => u.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCard : AppColors.card;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search units...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.background,
                  ),
                  onChanged: _filter,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final unit = _filtered[index];
                    final isSelected = unit == widget.selectedUnit;
                    return ListTile(
                      title: Text(
                        unit,
                        style: GoogleFonts.inter(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected ? AppColors.accent : null,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.accent)
                          : null,
                      onTap: () => widget.onSelected(unit),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
