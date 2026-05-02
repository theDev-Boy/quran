import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../reading/reading_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade200),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search Surah or Parah...',
              prefixIcon: Icon(Icons.search, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (val) {
              // Trigger search logic
              setState(() {});
            },
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Surahs'),
            Tab(text: 'Parahs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SurahList(query: _searchController.text),
          _ParahList(query: _searchController.text),
        ],
      ),
    );
  }
}

class _SurahList extends StatelessWidget {
  final String query;
  const _SurahList({required this.query});

  @override
  Widget build(BuildContext context) {
    // Placeholder list
    final surahs = List.generate(114, (i) => i + 1)
        .where((i) => i.toString().contains(query)) // Simple filter for demo
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: surahs.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final id = surahs[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
            child: Text('$id', style: const TextStyle(color: AppTheme.primary, fontSize: 12)),
          ),
          title: const Text('Surah Al-Fatiha'), // Replace with real names
          subtitle: const Text('The Opening'),
          trailing: const Text(
            'الفاتحة',
            style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
          ),
          onTap: () {
            // Navigate to reading page
          },
        );
      },
    );
  }
}

class _ParahList extends StatelessWidget {
  final String query;
  const _ParahList({required this.query});

  @override
  Widget build(BuildContext context) {
    final parahs = List.generate(30, (i) => i + 1)
        .where((i) => i.toString().contains(query))
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: parahs.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final id = parahs[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
            child: Text('$id', style: const TextStyle(color: AppTheme.primary, fontSize: 12)),
          ),
          title: Text('Parah $id'),
          trailing: const Text(
            'الجزء',
            style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReadingPage()));
          },
        );
      },
    );
  }
}
