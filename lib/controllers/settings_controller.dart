import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerseInfo {
  final int surahId;
  final int ayahNumber;
  final int pageNumber;

  VerseInfo({required this.surahId, required this.ayahNumber, required this.pageNumber});
}

class CurrentVerseNotifier extends StateNotifier<VerseInfo?> {
  CurrentVerseNotifier() : super(null);

  void setVerse(int surahId, int ayahNumber, int pageNumber) {
    state = VerseInfo(surahId: surahId, ayahNumber: ayahNumber, pageNumber: pageNumber);
  }
}

final currentVerseProvider = StateNotifierProvider<CurrentVerseNotifier, VerseInfo?>((ref) {
  return CurrentVerseNotifier();
});

final selectedLanguageProvider = StateProvider<String>((ref) => 'en');
final playbackSpeedProvider = StateProvider<double>((ref) => 1.0);
