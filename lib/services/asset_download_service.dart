import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';

class AssetDownloadService extends ChangeNotifier {
  double _progress = 0;
  String _status = '';
  bool _isDownloading = false;

  double get progress => _progress;
  String get status => _status;
  bool get isDownloading => _isDownloading;

  Future<bool> areAssetsDownloaded() async {
    final docDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(docDir.path, 'translations.db'));
    // Just check for the database for now
    return await dbFile.exists();
  }

  Future<void> downloadFullAssets() async {
    _isDownloading = true;
    _status = 'Connecting to server...';
    notifyListeners();

    try {
      final docDir = await getApplicationDocumentsDirectory();
      
      // 1. Download Translation Databases from Official Quran Android CDN
      _status = 'Downloading English Translation...';
      notifyListeners();
      await _downloadFile('https://android.quran.com/data/databases/en.sahih.db', p.join(docDir.path, 'en.db'));

      _status = 'Downloading Urdu Translation...';
      notifyListeners();
      await _downloadFile('https://android.quran.com/data/databases/ur.jalandhari.db', p.join(docDir.path, 'ur.db'));

      _status = 'Downloading Hindi Translation...';
      notifyListeners();
      await _downloadFile('https://android.quran.com/data/databases/hi.hindi.db', p.join(docDir.path, 'hi.db'));

      _status = 'Downloading Pashto Translation...';
      notifyListeners();
      await _downloadFile('https://android.quran.com/data/databases/ps.abdulwali.db', p.join(docDir.path, 'ps.db'));

      // 2. Download Timestamp Database
      _status = 'Downloading Timestamps...';
      notifyListeners();
      await _downloadFile('https://everyayah.com/data/Alafasy_128kbps/timing.db', p.join(docDir.path, 'timestamps.db'));

      // 3. Download Audio Files (114 Surahs)
      _status = 'Preparing Audio Downloads...';
      notifyListeners();
      
      final audioDir = Directory(p.join(docDir.path, 'audio', 'qari_1'));
      if (!await audioDir.exists()) await audioDir.create(recursive: true);

      for (int i = 1; i <= 114; i++) {
        final surahNum = i.toString().padLeft(3, '0');
        final fileName = 'surah_$surahNum.mp3';
        final savePath = p.join(audioDir.path, fileName);
        
        if (!await File(savePath).exists()) {
          _status = 'Downloading Surah $i of 114...';
          _progress = i / 114;
          notifyListeners();
          
          // Using a reliable public source for full surah mp3s
          await _downloadFile(
            'https://everyayah.com/data/Alafasy_128kbps/$surahNum.mp3', 
            savePath
          );
        }
      }
      
      _status = 'Download Complete!';
      _isDownloading = false;
      notifyListeners();
    } catch (e) {
      _status = 'Error: $e';
      _isDownloading = false;
      notifyListeners();
    }
  }

  Future<void> _downloadFile(String url, String savePath) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
    }
  }
}
