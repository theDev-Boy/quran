import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../controllers/settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedLang = ref.watch(selectedLanguageProvider);
    final selectedSpeed = ref.watch(playbackSpeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Appearance'),
          _buildSettingRow(
            'Dark Mode',
            Switch(
              value: isDarkMode,
              onChanged: (val) {
                // Toggle theme logic (implement in settings controller)
              },
              activeThumbColor: AppTheme.primary,
            ),
          ),
          const Divider(),
          _buildSectionHeader('Reading Preferences'),
          _buildSettingRow(
            'Default Translation',
            _buildDropdown<String>(
              value: selectedLang,
              items: ['en', 'ur', 'hi', 'ps'],
              onChanged: (val) => ref.read(selectedLanguageProvider.notifier).state = val!,
              labels: {'en': 'English', 'ur': 'Urdu', 'hi': 'Hindi', 'ps': 'Pashto'},
            ),
          ),
          _buildSettingRow(
            'Recitation Speed',
            _buildDropdown<double>(
              value: selectedSpeed,
              items: [0.5, 0.75, 1.0, 1.25, 1.5],
              onChanged: (val) => ref.read(playbackSpeedProvider.notifier).state = val!,
              labels: {0.5: '0.5x', 0.75: '0.75x', 1.0: '1.0x', 1.25: '1.25x', 1.5: '1.5x'},
            ),
          ),
          _buildSettingRow(
            'Translation Font Size',
            Slider(
              value: 16, // Use state
              min: 12,
              max: 24,
              activeColor: AppTheme.primary,
              onChanged: (val) {},
            ),
          ),
          const Divider(),
          _buildSectionHeader('About'),
          _buildSettingRow('App Version', const Text('1.0.0', style: TextStyle(color: Colors.grey))),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('About Noor Quran'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show about dialog
            },
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'May Allah bless your journey with the Quran.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingRow(String title, Widget trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required Map<T, String> labels,
  }) {
    return DropdownButton<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(labels[item] ?? item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      underline: const SizedBox(),
      icon: const Icon(Icons.keyboard_arrow_down, size: 18),
    );
  }
}
