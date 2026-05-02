import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home/home_page.dart';
import 'bookmarks/bookmarks_page.dart';
import 'search/search_page.dart';
import 'settings/settings_page.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    final pages = [
      const HomePage(),
      const BookmarksPage(),
      const SearchPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (index) => ref.read(selectedTabProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavItem(Icons.home_outlined, Icons.home, 0, selectedTab),
          _buildNavItem(Icons.bookmark_outline, Icons.bookmark, 1, selectedTab),
          _buildNavItem(Icons.search, Icons.search, 2, selectedTab),
          _buildNavItem(Icons.settings_outlined, Icons.settings, 3, selectedTab),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, IconData activeIcon, int index, int selectedTab) {
    final isActive = selectedTab == index;
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? activeIcon : icon),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF775A19),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      label: '',
    );
  }
}
