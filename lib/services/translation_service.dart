import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TranslationService {
  final Map<String, Database> _databases = {};

  Future<void> init() async {
    // Initialized on demand when language is selected or during download check
  }

  Future<String?> getTranslation({
    required int surahId, 
    required int ayahNumber, 
    required String languageCode,
  }) async {
    final db = await _getDatabase(languageCode);
    if (db == null) return null;

    // Official Quran Android DB schema: table 'translations' with 'sura', 'aya', 'text'
    final result = await db.query(
      'verses', // Most common table name in these DBs
      columns: ['text'],
      where: 'sura = ? AND aya = ?',
      whereArgs: [surahId, ayahNumber],
    );

    if (result.isNotEmpty) {
      return result.first['text'] as String;
    }
    
    // Try fallback table name 'translations'
    try {
      final resultFallback = await db.query(
        'translations',
        columns: ['text'],
        where: 'sura = ? AND aya = ?',
        whereArgs: [surahId, ayahNumber],
      );
      if (resultFallback.isNotEmpty) {
        return resultFallback.first['text'] as String;
      }
    } catch (_) {}

    return null;
  }

  Future<Database?> _getDatabase(String code) async {
    if (_databases.containsKey(code)) return _databases[code];

    try {
      final docDir = await getApplicationDocumentsDirectory();
      final path = join(docDir.path, '$code.db');
      
      if (!await File(path).exists()) return null;

      final db = await openDatabase(path, readOnly: true);
      _databases[code] = db;
      return db;
    } catch (e) {
      return null;
    }
  }
}
