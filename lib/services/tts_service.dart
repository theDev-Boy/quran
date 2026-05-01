import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  
  Future<void> init() async {
    await _flutterTts.setLanguage('ur-PK'); // Default to Urdu
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.0);
  }
  
  Future<void> speakTranslation({
    required String text, 
    required String languageCode,
    required double speed,
  }) async {
    await _flutterTts.setLanguage(_getLanguageTag(languageCode));
    await _flutterTts.setSpeechRate(speed * 0.45);
    await _flutterTts.speak(text);
  }
  
  Future<void> stop() async {
    await _flutterTts.stop();
  }
  
  String _getLanguageTag(String code) {
    switch(code) {
      case 'en': return 'en-US';
      case 'ur': return 'ur-PK';
      case 'hi': return 'hi-IN';
      case 'ps': return 'ps-AF'; 
      default: return 'en-US';
    }
  }

  Future<bool> isLanguageAvailable(String code) async {
    return await _flutterTts.isLanguageAvailable(_getLanguageTag(code));
  }
}
