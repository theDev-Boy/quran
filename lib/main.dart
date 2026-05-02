import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'core/theme.dart';
import 'services/translation_service.dart';
import 'services/tts_service.dart';
import 'services/recitation_service.dart';
import 'features/launch/launch_page.dart';

final translationServiceProvider = Provider((ref) => TranslationService());
final ttsServiceProvider = Provider((ref) => TtsService());
final recitationServiceProvider = Provider((ref) => RecitationService());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FlutterQuran (bundles all pages offline)
  await FlutterQuran().init();
  
  runApp(
    const ProviderScope(
      child: NoorQuranApp(),
    ),
  );
}

class NoorQuranApp extends ConsumerWidget {
  const NoorQuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize services
    ref.read(translationServiceProvider).init();
    ref.read(ttsServiceProvider).init();
    ref.read(recitationServiceProvider).init();

    return MaterialApp(
      title: 'Noor Quran',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Will be controlled by settings later
      home: const LaunchPage(),
    );
  }
}
