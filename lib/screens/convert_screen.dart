import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/category_chip_row.dart';
import '../widgets/converter_card.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/quick_reference_list.dart';
import '../theme/app_colors.dart';

class ConvertScreen extends StatelessWidget {
  const ConvertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ConvertIt',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _UnitSearchDelegate(),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 12),
            CategoryChipRow(),
            SizedBox(height: 20),
            ConverterCard(),
            SizedBox(height: 12),
            ActionButtonsRow(),
            QuickReferenceList(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _UnitSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search categories or units...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Type to search units...',
          style: GoogleFonts.inter(color: AppColors.textSecondary),
        ),
      );
    }

    // Search logic would go here
    return Center(
      child: Text(
        'No results for "$query"',
        style: GoogleFonts.inter(color: AppColors.textSecondary),
      ),
    );
  }
}
