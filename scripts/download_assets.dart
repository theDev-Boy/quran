import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

void main() async {
  print('🚀 NOOR Quran - Asset Downloader Initialized');
  
  // 1. Download Pages (Sample: first 5 pages)
  final pageBaseUrl = 'https://raw.githubusercontent.com/Sadaqa-Al-Jarirah/Hafizi-Quran-16-Lines-Images/master/images/';
  final pagesDir = Directory('assets/pages');
  if (!pagesDir.existsSync()) pagesDir.createSync(recursive: true);

  print('📖 Downloading sample pages...');
  for (int i = 1; i <= 5; i++) {
    final fileName = 'page_${i.toString().padLeft(3, '0')}.png';
    final url = '$pageBaseUrl$fileName';
    await _downloadFile(url, p.join(pagesDir.path, fileName));
  }

  // 2. Download Arabic Audio (Sample: first 10 verses of Al-Fatihah)
  // Qari: Mishary Rashid Alafasy
  final arabicAudioUrl = 'https://everyayah.com/data/Alafasy_128kbps/';
  final arabicDir = Directory('assets/audio/qari_1');
  if (!arabicDir.existsSync()) arabicDir.createSync(recursive: true);

  print('🔊 Downloading sample Arabic audio...');
  for (int i = 1; i <= 7; i++) {
    final fileName = '001${i.toString().padLeft(3, '0')}.mp3';
    final url = '$arabicAudioUrl$fileName';
    await _downloadFile(url, p.join(arabicDir.path, fileName));
  }

  // 3. Download English Translation Audio (Sample: first 10 verses)
  // Voice: Ibrahim Walk
  final englishAudioUrl = 'https://everyayah.com/data/English_Ibrahim_Walk_192kbps/';
  final englishDir = Directory('assets/translations_audio/english/male_voice_1');
  if (!englishDir.existsSync()) englishDir.createSync(recursive: true);

  print('🌍 Downloading sample English translation audio...');
  for (int i = 1; i <= 7; i++) {
    final fileName = '001${i.toString().padLeft(3, '0')}.mp3';
    final url = '$englishAudioUrl$fileName';
    await _downloadFile(url, p.join(englishDir.path, fileName));
  }

  print('\n✅ Sample assets downloaded successfully!');
  print('📍 Pages: assets/pages/');
  print('📍 Audio: assets/audio/ and assets/translations_audio/');
  print('\n💡 To download the FULL Quran (604 pages, 6236 verses):');
  print('Edit this script to change the loop ranges and run it again.');
}

Future<void> _downloadFile(String url, String savePath) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      print('   ✓ Saved ${p.basename(savePath)}');
    } else {
      print('   ✗ Failed to download ${p.basename(savePath)} (Status: ${response.statusCode})');
    }
  } catch (e) {
    print('   ✗ Error downloading ${p.basename(savePath)}: $e');
  }
}
