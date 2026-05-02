import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quran/flutter_quran.dart';
import '../../core/theme.dart';
import '../../controllers/settings_controller.dart';
import '../../services/asset_download_service.dart';

final downloadServiceProvider = ChangeNotifierProvider((ref) => AssetDownloadService());

class ReadingPage extends ConsumerStatefulWidget {
  const ReadingPage({super.key});

  @override
  ConsumerState<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends ConsumerState<ReadingPage> {
  @override
  void initState() {
    super.initState();
    _checkAssets();
  }

  Future<void> _checkAssets() async {
    final downloaded = await ref.read(downloadServiceProvider).areAssetsDownloaded();
    if (!downloaded) {
      _showDownloadDialog();
    }
  }

  void _showDownloadDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DownloadDialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSlimTopBar(context),
            Expanded(
              child: Stack(
                children: [
                  // Core Quran screen
                  InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Stack(
                      children: [
                        FlutterQuranScreen(),
                        // Per-line buttons overlay
                        _buildLineButtonsOverlay(),
                      ],
                    ),
                  ),
                  
                  // Surah Info Button (PRD: Somewhere on the page)
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: FloatingActionButton.small(
                      onPressed: () => _showSurahInfo(context),
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.info_outline),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineButtonsOverlay() {
    // Assuming 15 lines per page for a standard Mushaf
    const totalLines = 15;
    return LayoutBuilder(
      builder: (context, constraints) {
        final lineHeight = constraints.maxHeight / totalLines;
        return Stack(
          children: List.generate(totalLines, (index) {
            final lineNum = index + 1;
            return Positioned(
              top: index * lineHeight,
              left: 8,
              child: _LineControls(lineNum: lineNum),
            );
          }),
        );
      },
    );
  }

  Widget _buildSlimTopBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerTheme.color ?? Colors.transparent)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Surah Al-Baqarah',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.speed, size: 20),
            onPressed: () => _showSpeedControl(context),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _showSurahInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Surah Al-Baqarah', style: TextStyle(color: AppTheme.primary)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meaning: The Cow'),
            Text('Revealed: Madinah'),
            Text('Verses: 286'),
            SizedBox(height: 12),
            Text(
              'This is the longest Surah of the Quran. It contains Ayat al-Kursi and the last two verses which have great significance.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showSpeedControl(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Playback Speed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [0.5, 0.75, 1.0, 1.25, 1.5].map((s) => InkWell(
                onTap: () {
                  ref.read(playbackSpeedProvider.notifier).state = s;
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: ref.watch(playbackSpeedProvider) == s ? AppTheme.primary : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${s}x',
                    style: TextStyle(
                      color: ref.watch(playbackSpeedProvider) == s ? Colors.white : AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineControls extends ConsumerWidget {
  final int lineNum;
  const _LineControls({required this.lineNum});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconBtn(Icons.play_arrow_rounded, () {
          // Play line logic
        }),
        _buildIconBtn(Icons.language_rounded, () {
          _showLanguageMenu(context, ref);
        }),
        _buildIconBtn(Icons.bookmark_outline, () {
          // Bookmark logic
        }),
      ],
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Icon(icon, size: 16, color: AppTheme.primary.withValues(alpha: 0.6)),
      ),
    );
  }

  void _showLanguageMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['English', 'Urdu', 'Hindi', 'Pashto'].map((lang) => ListTile(
          title: Text(lang),
          onTap: () {
            // Set language and show translation below line
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }
}

class DownloadDialog extends ConsumerWidget {
  const DownloadDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadService = ref.watch(downloadServiceProvider);

    return AlertDialog(
      title: const Text('Downloading Quran Assets'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('The full Quran audio and translations are being downloaded for offline use. This may take a few minutes.'),
          const SizedBox(height: 24),
          if (downloadService.isDownloading) ...[
            LinearProgressIndicator(value: downloadService.progress > 0 ? downloadService.progress : null),
            const SizedBox(height: 8),
            Text(downloadService.status, style: const TextStyle(fontSize: 12)),
          ] else ...[
            ElevatedButton(
              onPressed: () => ref.read(downloadServiceProvider).downloadFullAssets(),
              child: const Text('Start Download'),
            ),
          ],
        ],
      ),
      actions: [
        if (!downloadService.isDownloading && downloadService.status == 'Download Complete!')
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Finish'),
          ),
      ],
    );
  }
}
