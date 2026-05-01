import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TranslationService {
  late Database _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'translations.db');
    
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE translation_texts (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              surah_id INTEGER NOT NULL,
              ayah_number INTEGER NOT NULL,
              language_code TEXT NOT NULL,
              translation_text TEXT NOT NULL,
              UNIQUE(surah_id, ayah_number, language_code)
          )
        ''');
        await db.execute('CREATE INDEX idx_translation_lookup ON translation_texts(surah_id, ayah_number, language_code)');
      },
    );
  }

  Future<String?> getTranslation({
    required int surahId, 
    required int ayahNumber, 
    required String languageCode,
  }) async {
    final result = await _db.query(
      'translation_texts',
      columns: ['translation_text'],
      where: 'surah_id = ? AND ayah_number = ? AND language_code = ?',
      whereArgs: [surahId, ayahNumber, languageCode],
    );
    if (result.isNotEmpty) {
      return result.first['translation_text'] as String;
    }
    return null;
  }
}
