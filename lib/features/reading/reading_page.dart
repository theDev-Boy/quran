import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quran/flutter_quran.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/settings_controller.dart';

class ReadingPage extends ConsumerStatefulWidget {
  const ReadingPage({super.key});

  @override
  ConsumerState<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends ConsumerState<ReadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOOR Quran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate_rounded),
            onPressed: () => _showTranslationSettings(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // The core Quran screen from the package
          FlutterQuranScreen(),
          
          // Custom overlay for translation (PRD 1.5 - Bottom Panel mode)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TranslationPanel(),
          ),
        ],
      ),
    );
  }

  void _showTranslationSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const TranslationSettingsDrawer(),
    );
  }
}

class TranslationPanel extends ConsumerWidget {
  const TranslationPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVerse = ref.watch(currentVerseProvider);
    final audioState = ref.watch(audioControllerProvider);
    final lang = ref.watch(selectedLanguageProvider);

    if (currentVerse == null) {
      return Container(
        height: 60,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: const Center(child: Text('Select a verse to see translation')),
      );
    }

    return Container(
      height: 150,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Verse ${currentVerse.surahId}:${currentVerse.ayahNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(audioState.isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded),
                  onPressed: () {
                    if (audioState.isPlaying) {
                      ref.read(audioControllerProvider.notifier).stop();
                    } else {
                      ref.read(audioControllerProvider.notifier).playVerse(
                        currentVerse.surahId,
                        currentVerse.ayahNumber,
                        lang,
                      );
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  audioState.currentTranslation ?? 'Fetching translation...',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TranslationSettingsDrawer extends ConsumerWidget {
  const TranslationSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLang = ref.watch(selectedLanguageProvider);
    final selectedSpeed = ref.watch(playbackSpeedProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Language Selection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _LangChip(
                  label: 'English', 
                  code: 'en', 
                  isActive: selectedLang == 'en',
                  onTap: () => ref.read(selectedLanguageProvider.notifier).state = 'en',
                ),
                _LangChip(
                  label: 'اردو', 
                  code: 'ur', 
                  isActive: selectedLang == 'ur',
                  onTap: () => ref.read(selectedLanguageProvider.notifier).state = 'ur',
                ),
                _LangChip(
                  label: 'हिंदी', 
                  code: 'hi', 
                  isActive: selectedLang == 'hi',
                  onTap: () => ref.read(selectedLanguageProvider.notifier).state = 'hi',
                ),
                _LangChip(
                  label: 'پښتو', 
                  code: 'ps', 
                  isActive: selectedLang == 'ps',
                  onTap: () => ref.read(selectedLanguageProvider.notifier).state = 'ps',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'TTS Playback Speed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SpeedBtn(
                label: '0.5x', 
                isActive: selectedSpeed == 0.5,
                onTap: () => ref.read(playbackSpeedProvider.notifier).state = 0.5,
              ),
              _SpeedBtn(
                label: '1.0x', 
                isActive: selectedSpeed == 1.0,
                onTap: () => ref.read(playbackSpeedProvider.notifier).state = 1.0,
              ),
              _SpeedBtn(
                label: '1.5x', 
                isActive: selectedSpeed == 1.5,
                onTap: () => ref.read(playbackSpeedProvider.notifier).state = 1.5,
              ),
              _SpeedBtn(
                label: '2.0x', 
                isActive: selectedSpeed == 2.0,
                onTap: () => ref.read(playbackSpeedProvider.notifier).state = 2.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final String code;
  final bool isActive;
  final VoidCallback onTap;

  const _LangChip({required this.label, required this.code, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isActive,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _SpeedBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SpeedBtn({required this.label, this.isActive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Theme.of(context).primaryColor : Colors.grey[200],
        foregroundColor: isActive ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}
