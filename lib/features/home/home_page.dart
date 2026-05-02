import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../reading/reading_page.dart';

final parahPageProvider = StateProvider<int>((ref) => 0); // 0 means 1-5, 1 means 6-10, etc.

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parahPage = ref.watch(parahPageProvider);
    final startParah = parahPage * 5 + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Noor Quran'),
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('logo.png'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParahSelector(context, ref, parahPage),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                final currentParah = startParah + index;
                if (currentParah > 30) return const SizedBox.shrink();
                return ParahCard(number: currentParah);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParahSelector(BuildContext context, WidgetRef ref, int parahPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Parah',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Row(
            children: [
              if (parahPage > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  onPressed: () => ref.read(parahPageProvider.notifier).state--,
                ),
              Text(
                '${parahPage * 5 + 1}-${(parahPage + 1) * 5 > 30 ? 30 : (parahPage + 1) * 5}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              if ((parahPage + 1) * 5 < 30)
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () => ref.read(parahPageProvider.notifier).state++,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ParahCard extends StatelessWidget {
  final int number;

  const ParahCard({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ReadingPage()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Decorative Border Pattern (Simulated)
              Positioned(
                top: -10, left: -10,
                child: Icon(Icons.star_outline, size: 40, color: AppTheme.primary.withValues(alpha: 0.05)),
              ),
              Positioned(
                bottom: -10, right: -10,
                child: Icon(Icons.star_outline, size: 40, color: AppTheme.primary.withValues(alpha: 0.05)),
              ),
              
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ornate Number Circle
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primary, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getParahArabicName(number),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Parah $number',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'English/Urdu Name', // Placeholder
                        style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getParahArabicName(int num) {
    // This would ideally come from the database
    final names = [
      "Alif Lam Meem", "Sayaqool", "Tilkal Rusull", "Lan Tanalu", "Wal Mohsanat",
      "La Yuhibbullah", "Wa Iza Samiu", "Wa Lau Annana", "Qalul Mala", "Wa'lamu",
      "Ya'tazirun", "Wa Ma Min Da'abbah", "Wa Ma Ubarriu", "Rubama", "Subhanallazi",
      "Qal Alam", "Aqtaraba", "Qad Aflaha", "Wa Qalallazina", "A'man Khalaqa",
      "Utlu Ma Uhiya", "Wa Man Yaqnut", "Wa Maliya", "Faman Azlamu", "Elahe Yuruddu",
      "Ha Meem", "Qala Fama Khatbukum", "Qad Sami Allah", "Tabarakallazi", "Amma Yatasa'alun"
    ];
    return names[num - 1];
  }
}
