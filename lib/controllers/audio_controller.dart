import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../main.dart';

class AudioState {
  final bool isPlaying;
  final int? currentSurah;
  final int? currentAyah;
  final String? currentTranslation;

  AudioState({
    this.isPlaying = false,
    this.currentSurah,
    this.currentAyah,
    this.currentTranslation,
  });

  AudioState copyWith({
    bool? isPlaying,
    int? currentSurah,
    int? currentAyah,
    String? currentTranslation,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyah: currentAyah ?? this.currentAyah,
      currentTranslation: currentTranslation ?? this.currentTranslation,
    );
  }
}

class AudioController extends StateNotifier<AudioState> {
  final Ref ref;

  AudioController(this.ref) : super(AudioState());

  Future<void> playVerse(int surahId, int ayahNumber, String languageCode) async {
    state = state.copyWith(isPlaying: true, currentSurah: surahId, currentAyah: ayahNumber);

    final recitation = ref.read(recitationServiceProvider);
    final translation = ref.read(translationServiceProvider);
    final tts = ref.read(ttsServiceProvider);

    // 1. Play Arabic
    await recitation.playVerse(surahId, ayahNumber, 1); // Qari 1

    // 2. Wait for completion (Listen to stream)
    await recitation.onVerseComplete.firstWhere((s) => s == ProcessingState.completed || s == ProcessingState.ready);
    
    // 3. Pause 400ms (PRD 4.4)
    await Future.delayed(const Duration(milliseconds: 400));

    // 4. Fetch Translation
    final text = await translation.getTranslation(
      surahId: surahId,
      ayahNumber: ayahNumber,
      languageCode: languageCode,
    );

    if (text != null) {
      state = state.copyWith(currentTranslation: text);
      // 5. Speak Translation
      await tts.speakTranslation(
        text: text,
        languageCode: languageCode,
        speed: 1.0, // Should come from settings
      );
    }

    state = state.copyWith(isPlaying: false);
  }

  void stop() {
    ref.read(recitationServiceProvider).stop();
    ref.read(ttsServiceProvider).stop();
    state = state.copyWith(isPlaying: false);
  }
}

final audioControllerProvider = StateNotifierProvider<AudioController, AudioState>((ref) {
  return AudioController(ref);
});
