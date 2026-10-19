import 'package:flutter/material.dart';
import '../widgets/arena_header.dart';
import '../widgets/arena_search_bar.dart';
import '../widgets/arena_tab.dart';
import '../widgets/challenge_list.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'package:gamer_app/core/widgets/app_background.dart';
import '../tabs/stakes_tab.dart';
import '../tabs/live_tab.dart';

class ArenaScreen extends StatefulWidget {
  const ArenaScreen({super.key});

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {

  int _selectedTab = 0;

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090304),

      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              ArenaHeader(onFilterTap: () => _showFilterSheet(context)),
              const ArenaSearchBar(),
              const SizedBox(height: 8),
              ArenaTab(
  selectedIndex: _selectedTab,
  onTabSelected: (index) {
    setState(() {
      _selectedTab = index;
    });
  },
),
              const SizedBox(height: 8),
              Expanded(
  child: _buildTab(),
),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab() {
  switch (_selectedTab) {
    case 0:
      return const StakesTab();

    case 1:
      return const LiveTab();

    default:
      return const StakesTab();
  }
}
}
