import 'dart:io';
import 'package:sqflite/sqflite.dart';

void main() async {
  // This is a sample script to populate the translations.db
  // In a real app, this would be a pre-built DB in assets
  final dbPath = 'assets/db/translations.db';
  final dir = Directory('assets/db');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  final db = await openDatabase(
    dbPath,
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
    },
  );

  print('📦 Populating sample translations...');
  
  // Sample data for Al-Fatihah
  final samples = [
    {'surah': 1, 'ayah': 1, 'lang': 'en', 'text': 'In the name of Allah, the Entirely Merciful, the Especially Merciful.'},
    {'surah': 1, 'ayah': 1, 'lang': 'ur', 'text': 'شروع اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے'},
    {'surah': 1, 'ayah': 2, 'lang': 'en', 'text': '[All] praise is [due] to Allah, Lord of the worlds -'},
    {'surah': 1, 'ayah': 2, 'lang': 'ur', 'text': 'سب تعریفیں اللہ ہی کے لیے ہیں جو تمام جہانوں کا پالنے والا ہے'},
  ];

  for (var sample in samples) {
    await db.insert('translation_texts', {
      'surah_id': sample['surah'],
      'ayah_number': sample['ayah'],
      'language_code': sample['lang'],
      'translation_text': sample['text'],
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  print('✅ Sample translations populated!');
  await db.close();
}
